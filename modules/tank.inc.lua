-- NEBULA native tank extension. Embedded in Garage, not an external executor loader.
-- Complete tank behavior remains experimental until the deferred in-game checks.
do
local T={};C.Tank=T
function T.previewNative(q,cf,parent)
 if q.size or q.second then return false end
 local storage=game:GetService("ReplicatedStorage");local templates=storage:FindFirstChild("BuildingParts");local original=templates and templates:FindFirstChild(q.kind)
 if not original or not original:IsA("Model")then return false end
 local clone=original:Clone();local primary=clone:FindFirstChild("PPart")or clone.PrimaryPart
 if not primary then clone:Destroy();return false end
 local old=primary.CFrame
 for _,v in ipairs(clone:GetDescendants())do
  if v:IsA("LuaSourceContainer")then v:Destroy()
  elseif v:IsA("BasePart")then
   v.CFrame=cf*old:ToObjectSpace(v.CFrame);v.Anchored=true;v.CanCollide=false;v.CanTouch=false;v.CanQuery=false;v.CastShadow=false
   if not q.skipPaint then v.Color=Color3.fromRGB(table.unpack(q.color))end
   if q.transparency then v.Transparency=q.transparency end
  elseif v:IsA("Constraint")then v.Enabled=false end
 end
 clone.Name=q.id;clone.Parent=parent;return true
end
T.help="Q + E — вперёд; A + D — назад. Q + D / A + E — разворот. J/L — башня; I/K — ствол; F — игровая пушка; U/O — люк. Команды работают из водительского кресла."
local function byId(record)
 local ids={};for _,entry in ipairs(record.models)do ids[entry.spec.id]=entry.model end;return ids
end
local function beamTo(seat,model)
 for _,beam in ipairs(seat:GetChildren())do
  if beam:IsA("Beam")and beam.Attachment1 and beam.Attachment1.Parent and beam.Attachment1.Parent:IsDescendantOf(model)then return true end
 end
 return false
end
function T.validate(plan)
 assert(plan.tank==true and plan.id=="abrams-m1a2"and plan.revision==2,"Неподдерживаемая схема танка")
 assert(type(plan.trackLinks)=="number"and plan.trackLinks%1==0 and plan.trackLinks>=6 and plan.trackLinks<=80,"Неверная длина цепи")
 local ids,pins,motors={}, {left=0,right=0},{left=0,right=0}
 for _,q in ipairs(plan.parts)do
  ids[q.id]=q
  if q.group=="track"or q.group=="drive"then
   assert(q.track=="left"or q.track=="right","Не указана сторона гусеницы")
   if q.group=="track"then
    assert(type(q.trackLink)=="number"and q.trackLink%1==0 and q.trackLink>=0 and q.trackLink<plan.trackLinks,"Неверный номер звена")
    if q.kind=="Hinge"then pins[q.track]=pins[q.track]+1 end
   else assert(q.kind=="Motor","В приводе нужен игровой Motor");motors[q.track]=motors[q.track]+1 end
  end
 end
 for _,id in ipairs({"spine","driver","turretServo","gunServo","hatchServo","turret:frame","gun:frame","hatch:panel","cannon"})do assert(ids[id],"Нет узла: "..id)end
 assert(ids.driver.kind=="CarSeat"and ids.cannon.kind=="Cannon","Неверные кресло/пушка")
 for _,id in ipairs({"turretServo","gunServo","hatchServo"})do assert(ids[id].kind=="Servo","Не игровой сервопривод")end
 for _,side in ipairs({"left","right"})do assert(pins[side]==plan.trackLinks and motors[side]>=2,"Неполная ходовая: "..side)end
 assert(type(plan.controls)=="table","Нет описания управления")
end
function T.commands(record)
 local ids=byId(record);local commands={}
 local function add(models,keys)
  assert(#models>0,"Нет управляемых механизмов")
  local groups={}
  for _,model in ipairs(models)do
   local count=0
   for _,v in ipairs(model:GetChildren())do local action=v:FindFirstChild("ActionName")
    if v.Name:sub(1,4)=="Bind"and action and type(action.Value)=="string"then
     assert(keys[action.Value],"Нет клавиши для "..action.Value)
     groups[action.Value]=groups[action.Value]or {};table.insert(groups[action.Value],v);count=count+1
    end
   end
   assert(count>0,"Механизм не поддерживает игровые привязки: "..model.Name)
  end
  local values={};for action,key in pairs(keys)do values[action]=Enum.KeyCode[key].Value end
  commands[#commands+1]={groups=groups,models=models,keys=values}
 end
 for _,side in ipairs({"left","right"})do
  local models={};for _,entry in ipairs(record.models)do if entry.spec.group=="drive"and entry.spec.track==side then models[#models+1]=entry.model end end
  -- Mirrored axles require opposite angular velocity for the same travel direction.
  add(models,side=="left"and {Forward="Q",Backward="A"}or {Forward="D",Backward="E"})
 end
 add({ids.turretServo},{Left="J",Right="L"})
 add({ids.gunServo},{Left="K",Right="I"})
 add({ids.hatchServo},{Left="U",Right="O"})
 add({ids.cannon},{Activate="F"})
 return commands,ids.driver
end
function T.step(run)
 if run.phase=="bind"then
  local record={models=run.models,plan=run.plan};run.tankCommands,run.tankSeat=T.commands(record);run.tankCommandIndex=1;run.phase="tankBind";run.phaseTime=0
 end
 if run.phase=="tankBind"then
  local command=run.tankCommands[run.tankCommandIndex]
  if not command then run.phase="finish";run.phaseTime=0;return end
  -- Live tool schema: action groups, array of controllers, explicit keys, disconnect,
  -- custom-seat-input mode. The game handles key events; no spoofed server packets.
  H.invoke(run,run.tools.bind,run.tools.bindRF,{command.groups,{run.tankSeat},command.keys,false,true},"tankBindVerify")
 elseif run.phase=="tankBindVerify"then
  local command=run.tankCommands[run.tankCommandIndex]
  for _,model in ipairs(command.models)do if not beamTo(run.tankSeat,model)then return end end
  run.tankCommandIndex=run.tankCommandIndex+1;run.phase="tankBind";run.phaseTime=0
 end
end
function T.audit(record)
 assert(record and record.plan and record.plan.tank and #record.models==#record.plan.parts,"Нет законченного танка")
 T.validate(record.plan)
 local ids=byId(record);local allowed,parents={},{},{}
 local function root(p)parents[p]=parents[p]or p;if parents[p]~=p then parents[p]=root(parents[p])end;return parents[p]end
 local function union(a,b)if allowed[a]and allowed[b]then parents[root(a)]=root(b)end end
 for _,entry in ipairs(record.models)do
  assert(entry.model.Parent==record.folder,"Узел танка удалён/перемещён")
  for _,part in ipairs(entry.model:GetDescendants())do if part:IsA("BasePart")then allowed[part]=entry.spec end end
  if entry.spec.noCollide then local pp=entry.model:FindFirstChild("PPart");assert(pp and not pp.CanCollide,"Коллизия декоративной/внутренней детали не отключена: "..entry.spec.id)end
 end
 for _,entry in ipairs(record.models)do for _,joint in ipairs(entry.model:GetDescendants())do
  if joint:IsA("Snap")or joint:IsA("Weld")or joint:IsA("ManualWeld")or joint:IsA("WeldConstraint")then union(joint.Part0,joint.Part1)end
 end end
 local spine=assert(ids.spine:FindFirstChild("PPart"));local bodyRoot=root(spine)
 local turretRoot=root(ids["turret:frame"].PPart);local gunRoot=root(ids["gun:frame"].PPart);local hatchRoot=root(ids["hatch:panel"].PPart)
 assert(turretRoot~=bodyRoot and gunRoot~=bodyRoot and gunRoot~=turretRoot and hatchRoot~=bodyRoot,"Подвижный узел жёстко сварен с корпусом")
 local roots={body=bodyRoot,seat=bodyRoot,turret=turretRoot,gun=gunRoot,hatch=hatchRoot}
 for part,spec in pairs(allowed)do if roots[spec.group]then assert(root(part)==roots[spec.group],"Не закреплена панель/деталь: "..spec.id)end end
 for part,spec in pairs(allowed)do if spec.group=="tankWheelSkin"then
  local motor=assert(ids[spec.driveId],"Missing roadwheel drive");local joint=assert(motor:FindFirstChildWhichIsA("HingeConstraint",true))
  assert(joint.Attachment1 and root(part)==root(joint.Attachment1.Parent)and root(part)~=bodyRoot,"Roadwheel skin is detached or welded to hull")
 end end
 local seat=assert(ids.driver:FindFirstChildWhichIsA("VehicleSeat",true),"Нет настоящего водительского кресла")
 local function actuator(model,expectedBase,expectedOutput,mode)
  local constraint=model:FindFirstChildWhichIsA("HingeConstraint",true)
  assert(constraint and constraint.Enabled~=false and constraint.ActuatorType==mode and constraint.Attachment0 and constraint.Attachment1,"Нет рабочего привода: "..model.Name)
  local a,b=constraint.Attachment0.Parent,constraint.Attachment1.Parent
  assert(allowed[a]and allowed[b]and root(a)==expectedBase and root(a)~=root(b),"Привод закреплён неверно/заблокирован")
  if expectedOutput then assert(root(b)==expectedOutput,"Выход привода не соединён со своим узлом")end
  if mode==Enum.ActuatorType.Motor then assert(constraint.MotorMaxTorque>0,"Нулевой момент мотора")else assert(constraint.ServoMaxTorque>0,"Нулевой момент сервопривода")end
  assert(beamTo(ids.driver,model),"Не подтверждена привязка кресла: "..model.Name)
  return constraint
 end
 actuator(ids.turretServo,bodyRoot,turretRoot,Enum.ActuatorType.Servo)
 actuator(ids.gunServo,turretRoot,gunRoot,Enum.ActuatorType.Servo)
 actuator(ids.hatchServo,bodyRoot,hatchRoot,Enum.ActuatorType.Servo)
 assert(root(ids.cannon.PPart)==gunRoot and beamTo(ids.driver,ids.cannon),"Пушка не соединена со стволом/креслом")
 for _,entry in ipairs(record.models)do if entry.spec.group=="drive"then actuator(entry.model,bodyRoot,nil,Enum.ActuatorType.Motor)end end
 for _,side in ipairs({"left","right"})do
  local components,degrees,graph={},{},{};local hinges=0
  for part,spec in pairs(allowed)do if spec.group=="track"and spec.track==side then local r=root(part);assert(r~=bodyRoot and r~=turretRoot and r~=gunRoot,"Гусеница приварена к корпусу/башне");components[r]=true end end
  for _,entry in ipairs(record.models)do if entry.spec.group=="track"and entry.spec.track==side then
   for _,j in ipairs(entry.model:GetDescendants())do if j:IsA("Rotate")then
    local a,b=j.Part0,j.Part1
    assert(allowed[a]and allowed[b]and allowed[a].track==side and allowed[b].track==side,"Шарнир гусеницы соединён с посторонней деталью")
    a,b=root(a),root(b);assert(a~=b,"Шарнир звена жёстко замкнут")
    hinges=hinges+1;degrees[a]=(degrees[a]or 0)+1;degrees[b]=(degrees[b]or 0)+1
    graph[a]=graph[a]or {};graph[b]=graph[b]or {};table.insert(graph[a],b);table.insert(graph[b],a)
   end end
  end end
  local count=0;local first;for r in pairs(components)do count=count+1;first=first or r;assert(degrees[r]==2,"У звена нет двух подвижных соседей")end
  assert(count==record.plan.trackLinks and hinges==count,"Не все звенья/шарниры собраны: "..side)
  local visited={};local function visit(r)if visited[r]then return end;visited[r]=true;for _,neighbor in ipairs(graph[r]or {})do visit(neighbor)end end;visit(first)
  local connected=0;for _ in pairs(visited)do connected=connected+1 end;assert(connected==count,"Цепь разорвана: "..side)
 end
 return "Танк: две замкнутые шарнирные цепи, моторы, кресло, башня, подъём ствола и крепление пушки подтверждены. Езда и выстрел ещё требуют проверки в игре."
end
function T.sit()
 assert(not N.job and C.last and C.last.plan.tank,"Нет готового своего танка")
 local ids=byId(C.last);local seat=assert(ids.driver:FindFirstChildWhichIsA("VehicleSeat",true),"Нет кресла")
 assert(ids.driver.Parent==C.last.folder,"Кресло перемещено")
 local humanoid=assert(humOf(me),"Нет персонажа");humanoid:UnequipTools()
 me.Character:PivotTo(seat.CFrame*CFrame.new(0,2.5,0));seat:Sit(humanoid)
 A.status(T.help)
end
function T.startProbe()
 assert(not N.job,"Сначала останови сборку");T.audit(C.last)
 local ids=byId(C.last);local seat=ids.driver:FindFirstChildWhichIsA("VehicleSeat",true)
 assert(seat.Occupant==humOf(me),"Сядь в водительское кресло танка")
 local spine=ids.spine.PPart;assert(not spine.Anchored,"Танк ещё закреплён")
 C.probe={tank=true,record=C.last,seat=seat,spine=spine,character=me.Character,origin=spine.Position,elapsed=0,distance=0,turn=0,yaw=math.atan2(-spine.CFrame.LookVector.X,-spine.CFrame.LookVector.Z),left=false,right=false,chain=false}
 A.status("12 секунд: проедь и развернись. Замер не управляет танком. "..T.help)
end
function T.stepProbe(dt)
 local p=C.probe;if not p then return end
 if not A.alive or N.job or p.character~=me.Character or not p.spine.Parent or p.seat.Occupant~=humOf(me)then C.probe=nil;return end
 p.elapsed=p.elapsed+dt;local delta=p.spine.Position-p.origin;p.distance=math.max(p.distance,math.sqrt(delta.X^2+delta.Z^2))
 local angle=math.atan2(-p.spine.CFrame.LookVector.X,-p.spine.CFrame.LookVector.Z)-p.yaw;p.turn=math.max(p.turn,math.abs(math.atan2(math.sin(angle),math.cos(angle))))
 for _,entry in ipairs(p.record.models)do
  if entry.spec.group=="drive"then local c=entry.model:FindFirstChildWhichIsA("HingeConstraint",true);if c and math.abs(c.AngularVelocity)>.5 then p[entry.spec.track]=true end
  elseif entry.spec.group=="track"and entry.spec.id:sub(-5)==":shoe"then local pp=entry.model:FindFirstChild("PPart");if pp and pp.AssemblyAngularVelocity.Magnitude>.5 then p.chain=true end end
 end
 if p.elapsed>=12 then
  C.lastDriveReport={tank=true,seconds=p.elapsed,horizontalStuds=p.distance,yawDegrees=math.deg(p.turn),leftDriveSeen=p.left,rightDriveSeen=p.right,chainMotionSeen=p.chain,driveObserved=p.distance>2 and p.left and p.right and p.chain,steeringObserved=p.turn>math.rad(8)}
  C.probe=nil;A.status(string.format("Танк: %.1f studs, поворот %.1f°. Движение цепи: %s. Стрельба этим замером не проверяется.",p.distance,math.deg(p.turn),p.chain and "видно"or "не подтверждено"))
 end
end
end
