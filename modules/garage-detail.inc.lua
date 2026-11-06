-- Presentation geometry and native-mechanism alignment shared by Legacy and New.
do
local D={};C.Detail=D
local function copy(value)
 if type(value)~="table"then return value end;local out={};for k,v in pairs(value)do out[k]=copy(v)end;return out
end
local function template(kind)
 local storage=game:GetService("ReplicatedStorage");local folder=storage:FindFirstChild("BuildingParts");return folder and folder:FindFirstChild(kind)
end
local function wheelInfo()
 local diameter,offset=5.1,{0,0,3};local original=template("FrontWheel")
 if original then
  local pp=original:FindFirstChild("PPart");local collider=original:FindFirstChild("InvisPart",true)or original:FindFirstChild("WheelCollider",true)
  if pp and collider then local cf=pp.CFrame:ToObjectSpace(collider.CFrame);offset={cf.Position.X,cf.Position.Y,cf.Position.Z};diameter=math.max(collider.Size.Y,collider.Size.Z)end
 end
 return diameter,offset
end
function D.materials(plan)
 local amount,scaled={},{}
 for _,q in ipairs(plan.parts)do
  local cost=1
  if q.size then scaled[q.kind]=true;local source=template(q.kind);local pp=source and source:FindFirstChild("PPart");local base=pp and pp.Size.X*pp.Size.Y*pp.Size.Z or 8
   cost=q.size[1]*q.size[2]*q.size[3]/math.max(.001,base)
  end
  amount[q.kind]=(amount[q.kind]or 0)+cost
 end
 plan.required={};for kind,value in pairs(amount)do plan.required[kind]=math.ceil(value+(scaled[kind]and .999 or 0))end
 return plan.required
end
function D.prepare(raw)
 local p=copy(raw)
 if p.tank then
  local seats={}
  for _,q in ipairs(p.parts)do
   if q.group=="track"and not q.id:match(":shoe$")then q.transparency=1 end
   if q.id:match("^skinSupport:")then q.transparency=1 end
   if q.kind=="CarSeat"then
    q.transparency=1;q.noCollide=true
    local x,y,z=q.pos[1],q.pos[2]-2,q.pos[3]-.1
    seats[#seats+1]={id="seatVisual:"..q.id..":pad",kind="PlasticBlock",pos={x,y,z},size={1.8,.3,1.7},color={19,22,19},rot={0,0,0},group="body",noCollide=true}
    seats[#seats+1]={id="seatVisual:"..q.id..":back",kind="PlasticBlock",pos={x,y+.9,z+.8},size={1.8,1.8,.3},color={25,29,24},rot={-10,0,0},group="body",noCollide=true}
   end
  end
  for _,q in ipairs(seats)do p.parts[#p.parts+1]=q;p.bill[q.kind]=(p.bill[q.kind]or 0)+1 end
  D.materials(p);return p
 end
 if p.detailRevision==1 then return p end
 local diameter,offset=wheelInfo();local scale=diameter/3.16
 p.renderScale=scale;p.detailRevision=1;p.disableSkinCollision=true
 p.length=p.length*scale;p.width=p.width*scale;p.height=p.height*scale;p.wheelbase=p.wheelbase*scale
 local output={};local body={90,94,99};local black={15,17,20};local width=p.width*.5;local wheelY=diameter*.5;local hasSeatVisual=false
 local function add(id,kind,pos,size,color,group,extra)
  local q={id=id,kind=kind,pos=pos,size=size,color=color or body,group=group or "body",rot={0,0,0}}
  for k,v in pairs(extra or {})do q[k]=v end;output[#output+1]=q;return q
 end
 local function box(id,pos,size,color,group,extra)return add(id,"MetalBlock",pos,size,color,group,extra)end
 for _,q in ipairs(p.parts)do
  local chassis=q.id=="spine"or q.id=="driver"or q.id:match("^crossmember")or q.id:match("^rail")or q.id:match("^sill")or q.id:match("^upperMount")or q.id:match("^outrigger")
  if q.group~="wheel"and q.group~="carrier"and q.group~="spring"and q.group~="link"and q.group~="seat"and not chassis then
   for j=1,3 do q.pos[j]=q.pos[j]*scale;if q.size then q.size[j]=q.size[j]*scale end end
   if q.second then for j=1,3 do q.second[j]=q.second[j]*scale end end
   q.noCollide=true
   if q.id:match("^seatPad")then hasSeatVisual=true end
   if q.id:match("^seatBack")then q.rot[1]=12 end
   if q.kind=="Wedge"and q.size then q.size[1]=.05 end
   local sourceGlass=q.color and q.color[1]==25 and q.color[2]==34 and q.color[3]==43
   if q.kind=="GlassBlock"or q.glass or sourceGlass then q.transparency=.5 end
   output[#output+1]=q
  end
 end
 -- A compact core leaves the wheel carriers free. Exterior panels do not collide.
 box("spine",{0,2.1,0},{2.4,.6,p.length*.84})
 box("cabinFloor",{0,2.55,0},{7.2,.3,6.5})
 if not hasSeatVisual then
  for _,side in ipairs({-1,1})do
   local x,z=side*1.03*scale,.4*scale
   box("seatVisual:pedestal:"..side,{x,2.875,z},{1.8,.35,1.5},black,"body",{noCollide=true,transparency=1})
   add("seatVisual:pad:"..side,"PlasticBlock",{x,3.2,z},{2.05,.3,2.15},black,"body",{noCollide=true})
   add("seatVisual:back:"..side,"PlasticBlock",{x,4.35,z+1},{2.05,2.4,.32},{23,25,29},"body",{noCollide=true,rot={12,0,0}})
   for _,edge in ipairs({-1,1})do add("seatVisual:bolster:"..side..":"..edge,"PlasticBlock",{x+edge*.94,3.46,z},{.2,.5,1.9},{34,36,41},"body",{noCollide=true})end
  end
 end
 local axles={-p.wheelbase*.5,p.wheelbase*.5}
 for i,z in ipairs({axles[1],0,axles[2]})do box("crossmember"..i,{0,2.1,z},{3.2,.5,.6})end
 local seatRelative={0,-2,-.1};local original=template("CarSeat")
 if original then local pp=original:FindFirstChild("PPart");local seat=original:FindFirstChildWhichIsA("VehicleSeat",true)
  if pp and seat then local v=pp.CFrame:ToObjectSpace(seat.CFrame).Position;seatRelative={v.X,v.Y,v.Z}end
 end
 local seatCentre={-1.03*scale,3.2,.4*scale}
 add("driver","CarSeat",{seatCentre[1]-seatRelative[1],seatCentre[2]-seatRelative[2],seatCentre[3]-seatRelative[3]},nil,black,"seat",{transparency=1,noCollide=true,skipPaint=true})
 local links={}
 for _,side in ipairs({-1,1})do for axle,z in ipairs(axles)do
  local id=side..":"..axle;local center={side*(width-.1*scale),wheelY,z}
  local basis={0,0,side,0,1,0,-side,0,0}
  local pp={center[1]-side*offset[3],center[2]-offset[2],center[3]+side*offset[1]}
  local carrierX=pp[1]-side*1.25
  box("mount"..id,{side*1.4,2.7,z},{.4,2.2,2},body,"body")
  box("carrier"..id,{carrierX,wheelY,z},{.5,2,1.6},body,"carrier",{noCollide=true,transparency=1})
  add("wheel"..id,axle==1 and "FrontWheel"or "BackWheel",pp,nil,black,"wheel",{basis=basis,previewSize={2,diameter,diameter},skipPaint=true,transparency=1,wheelCenter=center})
  local upper=wheelY+1+.5;local lower=wheelY-1-.5
  links[#links+1]={id="spring"..id,kind="Spring",pos={side*1.4,4.3,z},second={carrierX,upper,z},group="spring",noCollide=true,transparency=1}
  for level,yy in ipairs({1.1,4.3})do for _,dz in ipairs({-.6,.6})do
   links[#links+1]={id="arm"..id..":"..level..":"..dz,kind="Bar",pos={side*1.4,yy,z+dz},second={carrierX,level==1 and lower or upper,z+dz},group="link",noCollide=true,transparency=1}
  end end
  -- Custom rubber/metal geometry is collision-free and belongs to the rotor root.
  local wheelId="wheel"..id;local radius=diameter*.5-.035;local n=48
  local function visual(name,position,size,color,mat)
   return add("visual:"..id..":"..name,"PlasticBlock",position,size,color,"wheelSkin",{basis=mat,wheelId=wheelId,noCollide=true})
  end
  local function radial(name,r,angle,axleOffset,size,color)
   local c,s=math.cos(angle),math.sin(angle)
   -- X follows the axle; local Y is radial and Z is tangent.
   visual(name,{center[1]+side*axleOffset,center[2]+c*r,center[3]+s*r},size,color,{1,0,0,0,c,-s,0,s,c})
  end
  for j=1,n do
   local a=(j-.5)*math.pi*2/n;local tangent=2*radius*math.sin(math.pi/n)+.01
   radial("rubber:"..j,radius-.16,a,0,{1.9,.32,tangent},black)
   radial("sidewall:"..j,radius-.35,a,1.01,{.12,.5,tangent},{23,25,28})
   radial("rim:"..j,radius*.70,a,1.10,{.12,.14,2*radius*.70*math.sin(math.pi/n)+.008},{180,184,190})
  end
  visual("hub",{center[1]+side*1.085,center[2],center[3]},{.17,.65,.65},{64,69,77},{1,0,0,0,1,0,0,0,1})
  local spokes=({10,10,7,5,5,10,10,8,7,6})[C.selected]or 10
  for j=1,spokes do
   local a=j*math.pi*2/spokes+.1
   radial("spoke:"..j,radius*.39,a,1.10,{.16,radius*.67,.15},{146,151,159})
   radial("bolt:"..j,.24,a,1.20,{.08,.09,.09},{210,210,214})
  end
 end end
 for _,q in ipairs(links)do q.color=body;q.rot={0,0,0};output[#output+1]=q end
 p.parts=output;p.bill={};for _,q in ipairs(output)do p.bill[q.kind]=(p.bill[q.kind]or 0)+1 end
 p.driveNote="Невидимые игровые колёса и кресло; отдельная внешняя геометрия без коллизии. Подвеска использует 4 Spring и 16 Bar. Проверка езды отложена."
 D.materials(p);return p
end
function D.sit()
 assert(not N.job and C.last,"Сначала заверши сборку")
 if C.last.plan.tank then return C.Tank.sit()end
 local model;for _,entry in ipairs(C.last.models)do if entry.spec.id=="driver"then model=entry.model;break end end
 assert(model and model.Parent==C.last.folder,"Нет своего водительского кресла")
 local seat=assert(model:FindFirstChildWhichIsA("VehicleSeat",true),"Нет VehicleSeat")
 local h=assert(humOf(me),"Нет персонажа");h:UnequipTools();me.Character:PivotTo(seat.CFrame*CFrame.new(0,2.5,0));seat:Sit(h)
 A.status("Водительское место. W/S — газ и назад, A/D — поворот. Снятие закрепления — отдельной кнопкой после проверки связей.")
end
local rawPlan=C.plan
function C.plan(...)return D.prepare(rawPlan(...))end
end
