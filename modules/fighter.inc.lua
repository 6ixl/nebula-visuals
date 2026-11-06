-- Su-57-inspired native BABFT aircraft adapter. No local CFrame flight or fake explosion.
-- Flight, servo directions and release timing require the deferred Roblox session.
do
local F={clock=0};C.Fighter=F
F.help="R — игровые двигатели. Управление полётом — штатное PilotSeat. C — фонарь (удерживать), G — шасси (удерживать). W/S и A/D связаны с рулями. Z/X — левый/правый динамитный подвес с игровой задержкой 3 с."
local function native(kind)
 local folder=game:GetService("ReplicatedStorage"):FindFirstChild("BuildingParts");return folder and folder:FindFirstChild(kind)
end
local function pp(model)return model and(model:FindFirstChild("PPart")or model.PrimaryPart)end
local function seatOf(model)return model and(model:FindFirstChildWhichIsA("VehicleSeat",true)or model:FindFirstChildWhichIsA("Seat",true))end
local function map(record)local result={};for _,e in ipairs(record.models)do result[e.spec.id]=e.model end;return result end
local function beamTo(controller,model)
 for _,v in ipairs(controller:GetChildren())do if v:IsA("Beam")and v.Attachment1 and v.Attachment1.Parent and v.Attachment1.Parent:IsDescendantOf(model)then return true end end
 return false
end
local function value(model,name)local v=model and model:FindFirstChild(name);return v and v.Value end
function F.validate(plan)
 assert(plan.aircraft==true and not plan.tank and plan.id=="su57"and plan.revision==5,"Неподдерживаемая схема самолёта: загрузи обновлённую модель")
 local ids={};local jets,payloads,glue,delays=0,0,0,0
 for _,q in ipairs(plan.parts)do
  ids[q.id]=q
  if q.kind=="JetTurbine"then jets=jets+1 end
  if q.kind=="SticksOfTNT"then payloads=payloads+1 end
  if q.kind=="Glue"then glue=glue+1 end
  if q.kind=="Delay"then delays=delays+1 end
  if q.kind=="Glue"or q.kind=="SticksOfTNT"or q.kind=="Delay"or q.group=="bomb"then assert(q.bombSide=="left"or q.bombSide=="right","Не указан подвес")end
  if q.kind=="Servo"then assert(type(q.role)=="string"and #q.role<40,"Нет роли сервопривода")end
 end
 assert(ids.spine and ids.driver and ids.driver.kind=="PilotSeat","Нужен штатный PilotSeat")
 assert(jets==2 and payloads==2 and glue==2 and delays==2,"Неполные двигатели/подвесы")
 for _,role in ipairs({"canopy","gear:front","gear:left","gear:right","aileron:-1","aileron:1","elevator:-1","elevator:1","rudder:-1","rudder:1"})do assert(ids["servo:"..role],"Нет сервопривода: "..role)end
end
function F.prepare(plan)
 local ids={};for _,q in ipairs(plan.parts)do ids[q.id]=q end
 local function box(id,pos,size,group,extra)
  local q={id=id,kind="MetalBlock",pos=pos,size=size,color={58,62,67},rot={0,0,0},group=group,noCollide=true,transparency=1}
  for k,v in pairs(extra or {})do q[k]=v end;plan.parts[#plan.parts+1]=q;ids[id]=q;return q
 end
 local seatTemplate=native("PilotSeat");local seatPrimary=pp(seatTemplate);local seat=seatOf(seatTemplate)
 if seatPrimary and seat then
  local offset=seatPrimary.CFrame:ToObjectSpace(seat.CFrame).Position
  ids.driver.pos={-offset.X,10-offset.Y,-13.5-offset.Z}
  local bottom=ids.driver.pos[2]-seatPrimary.Size.Y*.5
  if bottom>9.35+.05 then box("pilotMount",{ids.driver.pos[1],(bottom+9.35)*.5,ids.driver.pos[3]},{1.2,bottom-9.35,1.2},"airframe")end
 end
 for _,q in ipairs(plan.parts)do
  if q.kind=="JetTurbine"then local source=pp(native(q.kind));q.pos[2]=9.6+(source and source.Size.Y or 4)*.5 end
 end
 local servos={};for _,q in ipairs(plan.parts)do if q.kind=="Servo"then servos[#servos+1]=q end end
 for _,q in ipairs(servos)do
  local source=native("Servo");local base=pp(source);local output=source and source:FindFirstChild("Part")
  local cf=C.cf(q,CFrame.new());local baseHalfY
  if base then local m={cf:GetComponents()};baseHalfY=(math.abs(m[7])*base.Size.X+math.abs(m[8])*base.Size.Y+math.abs(m[9])*base.Size.Z)*.5 else baseHalfY=q.role:match("^rudder")and .5 or 1 end
  local bottom=q.pos[2]-baseHalfY
  box("servoTie:"..q.role,{0,9.35,q.pos[3]},{math.max(4,math.abs(q.pos[1])*2+2),.5,1},"airframe")
  if bottom>9.65 then box("servoPost:"..q.role,{q.pos[1],(bottom+9.6)*.5,q.pos[3]},{.5,bottom-9.6,.5},"airframe")end
  local outCF=base and output and cf*base.CFrame:ToObjectSpace(output.CFrame)or cf*CFrame.new(-1.5,1,0)
  local size=output and output.Size or Vector3.new(3,1,2);local m={outCF:GetComponents()}
  local halfZ=(math.abs(m[10])*size.X+math.abs(m[11])*size.Y+math.abs(m[12])*size.Z)*.5
  local group=q.role=="canopy"and "canopy"or q.role:match("^gear:")and "gear"or "flightSurface"
  local root=ids["frame:"..q.role]
  local target={outCF.Position.X,outCF.Position.Y,outCF.Position.Z-halfZ-.2}
  if root then root.pos=target else root=box("frame:"..q.role,target,{.8,.4,.4},group,{role=q.role})end
  -- A hidden rigid adapter connects the servo output frame to the authored surface.
  local anchor
  if q.role=="canopy"then anchor={0,12.5,-6.4}
  elseif q.role:match("^gear:")then anchor={q.role=="gear:front"and 0 or q.role=="gear:left"and -4.8 or 4.8,9.5,q.role=="gear:front"and -21.2 or 6.8}
  else local side=tonumber(q.role:match(":(-?%d+)$"));anchor={side*(q.role:match("^aileron")and 14 or q.role:match("^elevator")and 7 or 5.5),10,q.role:match("^aileron")and 17 or q.role:match("^elevator")and 25 or 28}end
  box("surfaceAnchor:"..q.role,anchor,{.6,.4,.6},group,{role=q.role})
  local previous={target[1],target[2],target[3]}
  for axis=1,3 do
   local distance=anchor[axis]-previous[axis]
   if math.abs(distance)>.025 then local centre={previous[1],previous[2],previous[3]};centre[axis]=(previous[axis]+anchor[axis])*.5;local extent={.3,.3,.3};extent[axis]=math.abs(distance)+.3;box("surfaceAdapter:"..q.role..":"..axis,centre,extent,group,{role=q.role});previous[axis]=anchor[axis]end
  end
 end
 for _,side in ipairs({"left","right"})do
  local glueQ,payload,delay=ids["bombGlue:"..side],ids["bombPayload:"..side],ids["bombDelay:"..side]
  local glueSize=pp(native("Glue"));local payloadSize=pp(native("SticksOfTNT"));local delaySize=pp(native("Delay"))
  local gy=glueSize and glueSize.Size.Y or 2;local py=payloadSize and payloadSize.Size.Y or 2
  glueQ.pos[2]=7.5-gy*.5;local payloadY=7.5-gy-py*.5;local delta=payloadY-4.5
  for _,q in ipairs(plan.parts)do if q.bombSide==side and q.group=="bomb"then q.pos[2]=q.pos[2]+delta end end
  payload.pos[2]=payloadY;delay.pos[2]=payloadY
  delay.pos[3]=payload.pos[3]-(payloadSize and payloadSize.Size.Z or 2)*.5-(delaySize and delaySize.Size.Z or 2)*.5
  ids["bombFrame:"..side].pos[2]=payloadY-py*.5-.2
  -- Keep the release rack visibly continuous with the pylon while preserving a
  -- gap to fixed airframe parts. Glue remains the only rigid release bridge.
  local rack=ids["bombRack:"..side]
  if rack then
   local bottom=payloadY+.75;local top=7.30;assert(top>bottom,"Glue/payload dimensions do not fit the release rack")
   rack.pos[2]=(top+bottom)*.5;rack.size[2]=top-bottom;rack.transparency=1
   for j=0,1 do local rail=ids["bombRackRail:"..side..":"..j];assert(rail,"Missing slim release bracket");rail.pos[2]=rack.pos[2];rail.size[2]=rack.size[2]end
  end
 end
 plan.bill={};for _,q in ipairs(plan.parts)do plan.bill[q.kind]=(plan.bill[q.kind]or 0)+1 end
 return plan
end
function F.checkTemplates(plan)
 F.validate(plan)
 for _,kind in ipairs({"PilotSeat","JetTurbine","Servo","BackWheel","Glue","SticksOfTNT","Delay"})do local model=native(kind);assert(model and pp(model),"Игра не предоставляет "..kind)end
 assert(seatOf(native("PilotSeat")),"В PilotSeat нет настоящего Seat/VehicleSeat")
 for _,kind in ipairs({"JetTurbine","Glue","SticksOfTNT","Delay"})do
  local found=false
  for _,v in ipairs(native(kind):GetChildren())do if v.Name:sub(1,4)=="Bind"and v:FindFirstChild("ActionName")then found=true end end
  assert(found,"Нет игровых привязок у "..kind.."; сборка не начата")
 end
end
local function commands(record)
 local ids=map(record);local queue={}
 local function bind(models,controller,keys,mode)
  local groups={}
  for _,model in ipairs(models)do local found=0
   for _,v in ipairs(model:GetChildren())do local action=v:FindFirstChild("ActionName")
    if v.Name:sub(1,4)=="Bind"and action then
     assert(mode==false or keys[action.Value]or keys.any,"Неизвестная команда механизма: "..tostring(action.Value))
     groups[action.Value]=groups[action.Value]or {};table.insert(groups[action.Value],v);found=found+1
    end
   end
   assert(found>0,"Нет Bind/ActionName у "..model.Name)
  end
  local explicit={};if mode~=false then for action in pairs(groups)do explicit[action]=Enum.KeyCode[keys[action]or keys.any].Value end end
  queue[#queue+1]={models=models,controller=controller,groups=groups,keys=explicit,custom=mode~=false}
 end
 local pilot=ids.driver
 bind({ids["jet:-1"],ids["jet:1"]},pilot,{any="R"})
 bind({ids["servo:canopy"]},pilot,{Left="V",Right="C"})
 bind({ids["servo:gear:front"],ids["servo:gear:left"],ids["servo:gear:right"]},pilot,{Left="G",Right="H"})
 for _,side in ipairs({-1,1})do
  bind({ids["servo:aileron:"..side]},pilot,side==-1 and {Left="D",Right="A"}or {Left="A",Right="D"})
  bind({ids["servo:elevator:"..side]},pilot,{Left="S",Right="W"})
  bind({ids["servo:rudder:"..side]},pilot,{Left="A",Right="D"})
 end
 for _,role in ipairs({"gear:front","gear:left","gear:right"})do bind({ids["landingWheel:"..role]},pilot,{Forward="W",Backward="S"})end
 for _,side in ipairs({"left","right"})do
  local key=side=="left"and "Z"or "X"
  -- Payload has no direct pilot binding. Native Delay activates it after release.
  bind({ids["bombPayload:"..side]},ids["bombDelay:"..side],{},false)
  bind({ids["bombGlue:"..side],ids["bombDelay:"..side]},pilot,{any=key})
 end
 return queue
end
function F.step(run)
 if run.phase=="bind"then run.flightCommands=commands({models=run.models});run.flightCommandIndex=1;run.phase="flightBind";run.phaseTime=0 end
 local item=run.flightCommands[run.flightCommandIndex]
 if not item then run.phase="finish";run.phaseTime=0;return end
 if run.phase=="flightBindVerify"then
  for _,model in ipairs(item.models)do if not beamTo(item.controller,model)then return end end
  run.flightCommandIndex=run.flightCommandIndex+1;run.phase="flightBind";run.phaseTime=0;return
 end
 H.invoke(run,run.tools.bind,run.tools.bindRF,{item.groups,{item.controller},item.keys,false,item.custom},"flightBindVerify")
end
function F.audit(record)
 assert(record and record.plan and record.plan.aircraft and #record.models==#record.plan.parts,"Нет полной сборки самолёта")
 F.validate(record.plan);local ids=map(record);local allowed,parent={},{},{}
 local function root(p)parent[p]=parent[p]or p;if parent[p]~=p then parent[p]=root(parent[p])end;return parent[p]end
 local function union(a,b)if allowed[a]and allowed[b]then parent[root(a)]=root(b)end end
 local joints={}
 for _,entry in ipairs(record.models)do
  assert(entry.model.Parent==record.folder,"Узел самолёта удалён/перемещён: "..entry.spec.id)
  for _,v in ipairs(entry.model:GetDescendants())do if v:IsA("BasePart")then allowed[v]=entry.spec elseif v:IsA("Snap")or v:IsA("Weld")or v:IsA("ManualWeld")or v:IsA("WeldConstraint")then joints[#joints+1]=v end end
 end
 for _,j in ipairs(joints)do union(j.Part0,j.Part1)end
 local spine=root(pp(ids.spine));assert(seatOf(ids.driver),"Нет кресла пилота")
 local roles={}
 for _,entry in ipairs(record.models)do if entry.spec.kind=="Servo"then
  local model=entry.model;local h=model:FindFirstChildWhichIsA("HingeConstraint",true)
  assert(h and h.Enabled and h.ActuatorType==Enum.ActuatorType.Servo and h.ServoMaxTorque>0 and h.Attachment0 and h.Attachment1,"Нет сервопривода: "..entry.spec.role)
  assert(root(h.Attachment0.Parent)==spine and root(h.Attachment1.Parent)~=spine,"Сервопривод закреплён неверно/заблокирован")
  local output=root(h.Attachment1.Parent);local frame=ids["frame:"..entry.spec.role];assert(frame and root(pp(frame))==output,"Нет связи с фонарём/рулём/шасси")
  roles[entry.spec.role]=output
 end end
 local rotor={}
 for _,entry in ipairs(record.models)do if entry.spec.group=="landingWheel"then
  local h=entry.model:FindFirstChildWhichIsA("HingeConstraint",true);assert(h and h.Attachment0 and h.Attachment1 and h.MotorMaxTorque>0,"Нет шарнира колеса шасси")
  assert(root(h.Attachment0.Parent)==roles[entry.spec.role]and root(h.Attachment1.Parent)~=roles[entry.spec.role],"Колесо шасси заблокировано/не закреплено")
  local collider=entry.model:FindFirstChild("InvisPart",true)or entry.model:FindFirstChild("WheelCollider",true);assert(collider and collider.CanCollide,"Нет коллайдера шасси")
  rotor[entry.spec.id]=root(h.Attachment1.Parent)
 end end
 for part,q in pairs(allowed)do
  local expected
  if q.group=="airframe"or q.group=="pilot"or q.group=="jet"then expected=spine
  elseif q.group=="canopy"or q.group=="flightSurface"or q.group=="gear"then expected=roles[q.role]
  elseif q.group=="airWheelSkin"then expected=rotor[q.wheelId]end
  if expected then assert(root(part)==expected,"Не закреплена деталь самолёта: "..q.id)end
 end
 for _,id in ipairs({"jet:-1","jet:1"})do
  local jet=ids[id];assert(value(jet,"Fuel")and value(jet,"Fuel")>0,"Нет топлива в JetTurbine")
  assert(jet:FindFirstChildWhichIsA("BodyVelocity",true),"Нет штатного механизма тяги JetTurbine")
 end
 local queued=commands(record)
 for _,item in ipairs(queued)do for _,model in ipairs(item.models)do assert(beamTo(item.controller,model),"Не подтверждена игровая привязка")end end
 -- Recompute rigid components with each Glue removed. A hung bomb must then be
 -- separate from hull; extra welds would prevent its native release.
 for _,side in ipairs({"left","right"})do
  local glue=ids["bombGlue:"..side];local payload=ids["bombPayload:"..side];assert(root(pp(glue))==spine and root(pp(payload))==spine,"Подвес не закреплён до сброса")
  local cut={};local function r(p)cut[p]=cut[p]or p;if cut[p]~=p then cut[p]=r(cut[p])end;return cut[p]end
  for _,j in ipairs(joints)do local a,b=j.Part0,j.Part1
   if allowed[a]and allowed[b]and not a:IsDescendantOf(glue)and not b:IsDescendantOf(glue)then cut[r(a)]=r(b)end
  end
  assert(r(pp(payload))~=r(pp(ids.spine)),"Динамитный подвес приварен в обход Glue")
  local bombRoot=r(pp(payload))
  for part,q in pairs(allowed)do if q.group=="bomb"and q.bombSide==side then assert(r(part)==bombRoot,"Отдельная деталь/Delay не закреплены на подвесе")end end
  assert(not beamTo(ids.driver,payload),"Динамит нельзя напрямую подключать к креслу")
 end
 return "Су-57: каркас, шасси, фонарь, рули, тяга и цепи Glue → Delay → динамит структурно подтверждены. Полёт, сброс и подрыв ещё требуют испытания в игре."
end
function F.sit()
 assert(not N.job and C.last and C.last.plan.aircraft,"Нет своего собранного самолёта")
 local ids=map(C.last);local model=ids.driver;assert(model and model.Parent==C.last.folder,"Кресло пилота удалено")
 local seat=assert(seatOf(model),"Нет кресла пилота");local h=assert(humOf(me),"Нет персонажа")
 h:UnequipTools();me.Character:PivotTo(seat.CFrame*CFrame.new(0,2.5,0));seat:Sit(h);F.record=C.last;A.status(F.help)
end
function F.summary(record)
 local ids=map(record);local held=0
 for _,side in ipairs({"left","right"})do local g=ids["bombGlue:"..side];if g and g.Parent==record.folder then held=held+1 end end
 local fuel=0;local known=false
 for _,id in ipairs({"jet:-1","jet:1"})do local n=value(ids[id],"Fuel");if finite(n)then fuel=fuel+n;known=true end end
 local root=pp(ids.spine);return string.format("Су-57 · %.1f studs/с · топливо %s · подвесов %d/2",root.AssemblyLinearVelocity.Magnitude,known and string.format("%.0f",fuel)or "?",held)
end
function F.update(dt)
 F.clock=F.clock+dt;if F.clock<.2 then return end;F.clock=0
 local record=F.record or C.last
 if not record or not record.plan.aircraft then if F.hud then F.hud.Visible=false end;return end
 local ids=map(record);local seat=seatOf(ids.driver);local visible=A.alive and seat and seat.Occupant==humOf(me)
 if not F.hud and visible then
  F.hud=new("Frame",{Name="NEBULAFlightHUD",Position=UDim2.new(1,-365,1,-92),Size=UDim2.fromOffset(345,62),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=.12,BorderSizePixel=0},gui)
  F.readout=text(F.hud,"",UDim2.fromOffset(10,7),UDim2.new(1,-20,1,-14),Enum.Font.Code);F.readout.TextWrapped=true;F.readout.TextSize=11
 end
 if F.hud then F.hud.Visible=visible==true;if visible then F.readout.Text=F.summary(record).."\nR: тяга   C/V: фонарь   G/H: шасси   Z/X: сброс"end end
end
function F.cleanup()destroy(F.hud);F.hud=nil;F.readout=nil;F.record=nil end
end
