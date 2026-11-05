-- Original NEBULA BABFT garage. Included inside Control; no external loaders.
do
local C={selected=1,paint=1,suspension=2,anchor=nil,preview=nil,last=nil,turn=0}
N.Cars=C
C.catalog={
 {name="720 · Papaya",inspired="McLaren 720S",color={255,112,24},length=19.4,width=8.4,nose=0.56,cabin=0.1,roof=4.35,tail=3.4,wing=0,lamps="sweep",intake="blade"},
 {name="P1 · Volcano",inspired="McLaren P1",color={246,170,30},length=19.8,width=8.5,nose=0.48,cabin=0.7,roof=4.5,tail=3.5,wing=1,lamps="arc",intake="scoop"},
 {name="Senna · Track",inspired="McLaren Senna",color={72,143,180},length=20.6,width=8.7,nose=0.65,cabin=0.2,roof=4.4,tail=3.65,wing=2,lamps="slit",intake="blade"},
 {name="488 · Rosso",inspired="Ferrari 488",color={207,28,42},length=19.2,width=8.3,nose=0.70,cabin=0.3,roof=4.65,tail=3.7,wing=0,lamps="sweep",intake="scoop",roundRear=true},
 {name="SF90 · Stradale",inspired="Ferrari SF90",color={240,192,32},length=20,width=8.6,nose=0.72,cabin=0.3,roof=4.5,tail=3.55,wing=1,lamps="split",intake="blade"},
 {name="Huracán · Verde",inspired="Lamborghini Huracán",color={115,204,38},length=19.3,width=8.7,nose=0.75,cabin=-0.3,roof=4.25,tail=3.45,wing=1,lamps="fork",intake="blade"},
 {name="911 · Weissach",inspired="Porsche 911 GT3 RS",color={206,211,214},length=18.9,width=8.1,nose=0.67,cabin=-0.1,roof=5.0,tail=3.65,wing=2,lamps="round",intake="louvre",roundRear=true},
 {name="Chiron · Atlantic",inspired="Bugatti Chiron",color={28,91,184},length=20.5,width=8.9,nose=0.83,cabin=0.5,roof=4.95,tail=3.85,wing=1,lamps="quad",intake="arc"},
 {name="Jesko · Attack",inspired="Koenigsegg Jesko",color={220,226,219},length=21.3,width=8.9,nose=0.58,cabin=0.4,roof=4.3,tail=3.4,wing=2,lamps="sweep",intake="scoop"},
 {name="R35 · Midnight",inspired="Nissan GT-R",color={90,83,132},length=20.3,width=8.4,nose=0.87,cabin=-0.2,roof=5.25,tail=4.0,wing=1,lamps="split",intake="louvre",roundRear=true},
}
C.paints={{name="Заводской"},{name="Чёрный",rgb={20,20,24}},{name="Жемчуг",rgb={228,228,222}},{name="Фиолетовый",rgb={103,50,180}},{name="Серебро",rgb={146,157,167}}}
C.suspensions={{name="Мягкая",stiffness=12000,damping=700},{name="Спорт",stiffness=24000,damping=1200},{name="Трек",stiffness=40000,damping=1800}}
C.profiles={
 {{0,.56,2.7},{.12,.9,3.15},{.25,1,3.7},{.45,.9,3.3},{.68,1,3.7},{.88,.97,3.55},{1,.75,3.25}},
 {{0,.48,2.6},{.16,.95,3.35},{.29,1,3.75},{.48,.87,3.4},{.7,1,3.8},{.9,.88,3.55},{1,.69,3.1}},
 {{0,.68,2.65},{.12,.97,3.05},{.28,1,3.6},{.48,.91,3.25},{.72,1,3.75},{.92,1,3.6},{1,.85,3.45}},
 {{0,.67,2.9},{.15,.93,3.5},{.29,1,3.85},{.48,.88,3.55},{.7,1,3.9},{.9,.96,3.75},{1,.81,3.5}},
 {{0,.74,2.8},{.14,.98,3.15},{.26,1,3.65},{.48,.9,3.5},{.7,1,3.8},{.9,.95,3.55},{1,.81,3.4}},
 {{0,.77,2.55},{.15,.96,3.0},{.28,1,3.4},{.48,.96,3.45},{.72,1,3.65},{.9,.98,3.5},{1,.86,3.2}},
 {{0,.62,3.05},{.13,.86,3.55},{.28,.96,4.0},{.48,.9,3.8},{.7,1,4.0},{.88,.99,3.8},{1,.79,3.5}},
 {{0,.78,3.1},{.16,.98,3.7},{.29,1,4.05},{.48,.91,3.85},{.7,1,4.0},{.9,.96,3.9},{1,.78,3.65}},
 {{0,.58,2.55},{.14,.94,3.0},{.28,1,3.6},{.46,.86,3.4},{.69,1,3.6},{.87,.94,3.45},{1,.68,3.1}},
 {{0,.85,3.2},{.14,.96,3.65},{.28,1,3.85},{.48,.95,3.75},{.7,1,3.9},{.9,.98,4.0},{1,.89,3.8}},
}
function C.plan(which,paint)
 local selected=which or C.selected;local d=assert(C.catalog[selected],"Нет модели");local p={name=d.name,inspired=d.inspired,parts={},bill={},length=d.length,width=d.width}
 local colors={body=(C.paints[paint or C.paint]or C.paints[1]).rgb or d.color,black={19,20,24},glass={42,58,65},metal={84,89,95},white={221,239,255},red={244,35,53},accent={116,70,222}}
 local function add(id,kind,x,y,z,sx,sy,sz,tone,rx,ry,rz,second,group)
  assert(not p.ids or not p.ids[id],"Duplicate car part")
  p.ids=p.ids or {};p.ids[id]=true
  local q={id=id,kind=kind,pos={x,y,z},size=sx and {sx,sy,sz}or nil,color=colors[tone or "body"],rot={rx or 0,ry or 0,rz or 0},second=second,group=group or "body"}
  p.parts[#p.parts+1]=q;p.bill[kind]=(p.bill[kind]or 0)+1;return q
 end
 local w,l=d.width/2,d.length;local front=-l*0.30;local rear=l*0.29
 add("spine","MetalBlock",0,2.25,0,2.6,0.65,l*0.81,"metal")
 for i,z in ipairs({front,0,rear})do add("crossmember"..i,"MetalBlock",0,2.3,z,w*1.85,0.55,0.6,"metal")end
 for _,s in ipairs({-1,1})do
  add("rail"..s,"MetalBlock",s*2.3,2.3,0,1,0.6,l*0.78,"metal")
  add("sill"..s,"PlasticBlock",s*(w-0.4),2.55,0,0.65,0.75,l*0.78)
 end
 -- Narrow longitudinal panels describe the body contour and leave real wheel openings.
 local profile=C.profiles[selected]
 local function contour(t)
  for i=2,#profile do if t<=profile[i][1]then local a,b=profile[i-1],profile[i];local f=(t-a[1])/(b[1]-a[1]);return a[2]+(b[2]-a[2])*f,a[3]+(b[3]-a[3])*f end end
  return profile[#profile][2],profile[#profile][3]
 end
 local slices=40;local dz=l/slices
 for i=1,slices do
  local z=-l/2+(i-0.5)*dz;local t=(z+l/2)/l
  local taper,y=contour(t);local half=w*taper
  local _,before=contour(math.max(0,t-0.005));local _,after=contour(math.min(1,t+0.005));local slope=-math.deg(math.atan((after-before)/(l*0.01)))
  local nearWheel=math.abs(z-front)<1.65 or math.abs(z-rear)<1.65
  add("deck"..i,"PlasticBlock",0,y,z,(nearWheel and half*1.32 or half*1.85),0.24,dz+0.04,"body",slope)
  for _,s in ipairs({-1,1})do
   if nearWheel then
    local centre=math.abs(z-front)<1.65 and front or rear
    local archY=1.7+math.sqrt(math.max(0,1.85^2-(z-centre)^2))
    add("arch"..i..":"..s,"PlasticBlock",s*(half-0.28),archY,z,0.55,0.23,dz+0.04)
    local dx=half*0.36-0.28;local dy=archY-y
    add("shoulder"..i..":"..s,"PlasticBlock",s*(half*.82-.14),(y+archY)/2,z,math.sqrt(dx*dx+dy*dy)+.15,.18,dz+.04,"body",0,0,s*math.deg(math.atan(dy/dx)))
   else
    add("flank"..i..":"..s,"PlasticBlock",s*(half-0.25),(y+2.45)/2,z,0.5,math.max(0.45,y-2.45),dz+0.04)
   end
  end
 end
 -- Sloping roof/glazing, seats, dashboard and engine cover.
 local cabin=d.cabin;local roof=d.roof+0.65
 add("roof","PlasticBlock",0,roof,cabin,4.35,0.24,3.4)
 add("windscreen","GlassBlock",0,(roof+3.35)/2,cabin-2.45,4.2,0.15,2.1,"glass",-31)
 add("rearGlass","GlassBlock",0,(roof+3.55)/2,cabin+2.45,3.9,0.15,2.0,"glass",28)
 for _,s in ipairs({-1,1})do
  add("window"..s,"GlassBlock",s*2.27,(roof+3.25)/2,cabin,0.14,roof-3.25,3.6,"glass",0,0,s*10)
  add("pillarA"..s,"PlasticBlock",s*2.12,(roof+3.35)/2,cabin-2.3,0.23,0.22,2.3,"body",-31)
  add("pillarC"..s,"PlasticBlock",s*2.1,(roof+3.55)/2,cabin+2.25,0.3,0.24,2.3,"body",28)
  add("mirrorArm"..s,"PlasticBlock",s*2.95,3.95,cabin-1.7,1,0.18,0.2,"black")
  add("mirror"..s,"PlasticBlock",s*3.45,4.0,cabin-1.7,0.65,0.32,0.8)
  add("handle"..s,"MetalBlock",s*(w+0.025),3.4,cabin+0.25,0.1,0.12,0.55,"metal")
  add("intake"..s,"PlasticBlock",s*(w-0.12),2.95,2.4,d.intake=="scoop"and 0.4 or 0.16,0.65,d.intake=="blade"and 2.9 or 1.9,"black",0,s*12)
  add("doorline"..s,"PlasticBlock",s*(w+0.015),3.0,0,0.07,0.075,3.5,"black")
  add("seatback"..s,"PlasticBlock",s*1.1,3.65,cabin+0.75,1.25,1.6,0.4,"black",-8)
 end
 add("driver","CarSeat",-1.05,3.0,cabin-0.15,nil,nil,nil,"black",0,0,0,nil,"seat")
 add("passenger","PlasticBlock",1.05,2.95,cabin-0.15,1.3,0.3,1.45,"black")
 add("dash","PlasticBlock",0,3.65,cabin-1.45,4.0,0.4,0.55,"black")
 add("console","PlasticBlock",0,3.15,cabin,0.5,0.6,2.0,"black")
 add("splitter","PlasticBlock",0,2.3,-l/2+0.25,w*1.8,0.16,0.8,"black")
 add("diffuser","PlasticBlock",0,2.35,l/2-0.3,w*1.75,0.2,1.2,"black")
 add("grille","PlasticBlock",0,2.95,-l/2+0.08,selected==8 and 1.3 or w*1.2,selected==8 and 1.05 or 0.36,0.12,"black")
 for _,side in ipairs({-1,1})do
  add("frontIntake"..side,"PlasticBlock",side*w*.72,2.85,-l/2+.2,1.1,0.4,0.13,"black")
  if selected==8 then
   for j=0,12 do local a=-math.pi*.65+j*math.pi*1.3/12
    add("cLine"..side..":"..j,"MetalBlock",side*(w+.025),3.85+math.cos(a)*1.05,cabin+1.2+math.sin(a)*1.8,0.12,0.28,0.4,"metal",math.deg(a))
   end
  elseif selected==7 then
   for j=1,5 do add("fenderVent"..side..":"..j,"PlasticBlock",side*w*.78,4.07,front-.65+j*.22,0.65,0.07,0.08,"black")end
  elseif selected==10 then
   add("bonnetVent"..side,"PlasticBlock",side*1.3,3.83,-l*.27,0.55,.09,1.1,"black")
  elseif selected==3 or selected==9 then
   add("canard"..side,"PlasticBlock",side*(w+.1),2.8,-l*.38,.85,.1,1.4,"black",-12,side*15)
  end
 end
 for i=-2,2 do
  add("diffuserFin"..i,"PlasticBlock",i*0.9,2.55,l/2-0.3,0.12,0.55,1.1,"black")
  add("engineVent"..i,"PlasticBlock",i*0.65,3.83,l*0.28,0.17,0.09,1.85,"black")
 end
 for _,s in ipairs({-1,1})do
  if d.lamps=="round"then
   for j=0,9 do local a=j*math.pi/5;add("head"..s..":"..j,"PlasticBlock",s*w*0.65+math.cos(a)*0.49,3.55+math.sin(a)*0.4,-l/2+0.65,0.28,0.19,0.16,"white",0,0,math.deg(a))end
  else
   local segments=d.lamps=="quad"and 4 or(d.lamps=="fork"and 3 or 2)
   for j=1,segments do add("head"..s..":"..j,"PlasticBlock",s*(w*0.51+j*0.3),3.36+j*0.08,-l/2+0.5+j*0.17,0.5,0.13,0.16,"white",0,s*14,s*-12)end
  end
  if d.roundRear then
   for k=1,2 do for j=0,7 do local a=j*math.pi/4;add("tail"..s..":"..k..":"..j,"PlasticBlock",s*(w*0.45+k*0.6)+math.cos(a)*0.22,3.4+math.sin(a)*0.22,l/2-0.1,0.18,0.13,0.14,"red",0,0,math.deg(a))end end
  else add("tail"..s,"PlasticBlock",s*w*0.56,3.4,l/2-0.12,w*0.7,0.12,0.13,"red")end
  add("exhaust"..s,"MetalBlock",s*1.0,2.8,l/2+0.08,0.45,0.35,0.4,"black")
 end
 if d.wing>0 then
  local h=d.wing==2 and 5.2 or 4.05
  for _,s in ipairs({-1,1})do add("wingStand"..s,"PlasticBlock",s*2.0,(h+d.tail)/2,l*0.38,0.2,h-d.tail,0.35,"black")end
  add("wing","PlasticBlock",0,h,l*0.39,w*1.95,0.17,d.wing==2 and 1.7 or 0.8,"black",-7)
  for _,s in ipairs({-1,1})do add("wingEnd"..s,"PlasticBlock",s*w*0.97,h+0.15,l*0.39,0.13,0.6,1.7,"black")end
 end
 -- Separate unsprung carriers. Springs/parallel links are placed LAST, after both anchors exist.
 local links={}
 for _,s in ipairs({-1,1})do for axle,z in ipairs({front,rear})do
  local id=s..":"..axle;local wx=s*(w-0.1);local carrier=s*(w-1.0)
  add("carrier"..id,"MetalBlock",carrier,1.75,z,0.75,1.6,1.7,"metal",0,0,0,nil,"carrier")
  add("wheel"..id,axle==1 and "FrontWheel"or "BackWheel",wx,1.7,z,nil,nil,nil,"black",0,s==1 and 180 or 0,0,nil,"wheel")
  links[#links+1]={id="spring"..id,kind="Spring",a={s*2.3,3.05,z},b={carrier,1.85,z},group="spring"}
  for _,height in ipairs({1.25,2.25})do for _,offset in ipairs({-0.55,0.55})do
   links[#links+1]={id="arm"..id..":"..height..":"..offset,kind="Bar",a={s*2.3,height,z+offset},b={carrier,height,z+offset},group="link"}
  end end
 end end
 for _,v in ipairs(links)do add(v.id,v.kind,v.a[1],v.a[2],v.a[3],nil,nil,nil,"metal",0,0,0,v.b,v.group)end
 return p
end
function C.cf(v,base,second)
 local pos=second and v.second or v.pos;local r=v.rot
 return base*CFrame.new(pos[1],pos[2],pos[3])*CFrame.Angles(math.rad(r[1]),math.rad(r[2]),math.rad(r[3]))
end
function C.clearPreview()destroy(C.preview);C.preview=nil end
function C.setAnchor()
 assert(not N.job,"Останови текущую задачу");local r=rootOf(me);assert(r,"Персонаж не готов")
 local _,yaw=r.CFrame:ToOrientation();C.anchor=CFrame.new(r.Position+Vector3.new(0,1,0))*CFrame.Angles(0,yaw,0)*CFrame.new(0,0,-20)
 A.status("Центр машины указан впереди. Проверь, что весь кузов помещается на участке.")
end
function C.previewInto(parent,base)
 local plan=C.plan();local model=new("Model",{Name="NEBULA_CarPreview"},parent)
 for _,q in ipairs(plan.parts)do
  local cf=C.cf(q,base);local size=q.size and Vector3.new(table.unpack(q.size))or(q.group=="wheel"and Vector3.new(1,3,3)or Vector3.new(1,0.5,1))
  if q.second then local endpoint=C.cf(q,base,true).Position;local start=cf.Position;size=Vector3.new(q.kind=="Spring"and 0.25 or 0.12,q.kind=="Spring"and 0.25 or 0.12,(endpoint-start).Magnitude);cf=CFrame.lookAt((start+endpoint)*0.5,endpoint)end
  local part=new("Part",{Name=q.id,Size=size,CFrame=cf,Color=Color3.fromRGB(table.unpack(q.color)),Material=Enum.Material.SmoothPlastic,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,CastShadow=false},model)
  if q.kind=="GlassBlock"then part.Transparency=0.32 end
  if q.group=="wheel"then part.Shape=Enum.PartType.Cylinder end
 end
 return model
end
function C.previewWorld()
 assert(not N.job,"Останови текущую задачу");if not C.anchor then C.setAnchor()end;C.clearPreview();C.preview=C.previewInto(owned,C.anchor)
 A.status("Локальное превью; это не серверная машина. Сборка — отдельной кнопкой.")
end
function C.check()
 N.requireGame("boat");local plan=C.plan();local tools=H.buildTools()
 local bind=H.tool("BindTool");local props=H.tool("PropertiesTool")
 tools.bind=bind;tools.bindRF=bind and bind:FindFirstChild("RF");tools.props=props;tools.propsRF=props and props:FindFirstChild("SetPropertieRF")
 assert(tools.bindRF and tools.bindRF:IsA("RemoteFunction"),"Нужна отвёртка BindTool.RF")
 assert(tools.propsRF and tools.propsRF:IsA("RemoteFunction"),"Нужен PropertiesTool.SetPropertieRF")
 local data=me:FindFirstChild("Data");local missing={}
 for kind,count in pairs(plan.bill)do local value=data and data:FindFirstChild(kind);if not value or type(value.Value)~="number"or value.Value<count then missing[#missing+1]=kind..": нужно "..count..", есть "..tostring(value and value.Value or 0)end end
 table.sort(missing);assert(#missing==0,"Не хватает блоков: "..table.concat(missing,"; "))
 local zone=H.findZone();assert(zone,"Зона команды не найдена")
 local blocks=workspace:FindFirstChild("Blocks");local folder=blocks and blocks:FindFirstChild(me.Name);assert(folder,"Собственная папка Blocks не загружена")
 return plan,tools,zone,folder,data
end
function C.start()
 assert(not N.job,"Сначала останови текущую задачу");local plan,tools,zone,folder,data=C.check();if not C.anchor then C.setAnchor()end
 local run=N.prepare("car");run.plan=plan;run.tools=tools;run.zone=zone;run.folder=folder;run.data=data;run.base=C.anchor;run.speed=H.photoSpeed;run.interval=0.5/run.speed
 run.seen={};for _,m in ipairs(folder:GetChildren())do run.seen[m]=true end
 run.models={};run.tune=C.suspensions[C.suspension];run.phase="place";run.phaseTime=0;run.sendClock=0;C.last=nil;C.clearPreview()
 A.status("Гараж: экспериментальная сборка "..plan.name.." · "..#plan.parts.." деталей. Детали останутся закреплёнными.")
end
function C.bindingGroups(models)
 local groups={};local count=0
 for _,entry in ipairs(models)do if entry.spec.group=="wheel"then
  local found=0
  for _,value in ipairs(entry.model:GetChildren())do
   local actionName=value:FindFirstChild("ActionName")
   if value.Name:sub(1,4)=="Bind"and value.Name~="BindingSB"and actionName and type(actionName.Value)=="string"then
    groups[actionName.Value]=groups[actionName.Value]or {};table.insert(groups[actionName.Value],value);count=count+1;found=found+1
   end
  end
  assert(found>0,"У колеса нет поддерживаемых Bind/ActionName. Привяжи вручную отвёрткой.")
 end end
 assert(count>=4,"Не обнаружены привязки всех колёс");return groups
end
function C.audit(record)
 assert(record and record.models and #record.models==#record.plan.parts,"Нет завершённой сборки")
 local allowed,parents,labels={},{},{};local wheels,springs,links=0,0,0;local seat;local spine
 local function root(v)if not parents[v]then parents[v]=v end;if parents[v]~=v then parents[v]=root(parents[v])end;return parents[v]end
 local function union(a,b)if a and b and allowed[a]and allowed[b]then parents[root(a)]=root(b)end end
 for _,entry in ipairs(record.models)do
  assert(entry.model.Parent==record.folder,"Деталь удалена или перемещена")
  for _,part in ipairs(entry.model:GetDescendants())do if part:IsA("BasePart")then allowed[part]=entry.spec.group end end
  if entry.spec.group=="seat"then seat=entry.model end
  if entry.spec.id=="spine"then spine=entry.model:FindFirstChild("PPart")end
 end
 assert(seat and seat:FindFirstChildWhichIsA("VehicleSeat",true),"Водительское сиденье не подтверждено")
 for _,entry in ipairs(record.models)do for _,joint in ipairs(entry.model:GetDescendants())do
  if joint:IsA("Weld")or joint:IsA("WeldConstraint")or joint:IsA("ManualWeld")then union(joint.Part0,joint.Part1)end
 end end
 for part,group in pairs(allowed)do local key=root(part);labels[key]=labels[key]or {};labels[key][group]=true end
 assert(spine,"Не найден силовой каркас")
 for part,group in pairs(allowed)do if group=="body"or group=="seat"then assert(root(part)==root(spine),"Неприсоединённая деталь кузова/сиденья: "..part.Parent.Name)end end
 for _,groups in pairs(labels)do assert(not(groups.body and groups.carrier),"Колесо жёстко сварено с кузовом: подвеска заблокирована")end
 for _,entry in ipairs(record.models)do
  local group=entry.spec.group
  if group=="wheel"then
   local bound=false
   for _,beam in ipairs(seat:GetChildren())do if beam:IsA("Beam")and beam.Attachment1 and beam.Attachment1.Parent and beam.Attachment1.Parent:IsDescendantOf(entry.model)then bound=true end end
   assert(bound,"Связь сиденья и колеса не подтверждена: "..entry.spec.id)
   local mounted=false;local hinged=false
   for _,part in ipairs(entry.model:GetDescendants())do
    if part:IsA("BasePart")and labels[root(part)].carrier then mounted=true end
    if part:IsA("HingeConstraint")and part.Enabled~=false and part.Attachment0 and part.Attachment1 and allowed[part.Attachment0.Parent]and allowed[part.Attachment1.Parent]and root(part.Attachment0.Parent)~=root(part.Attachment1.Parent)then hinged=true end
   end
   assert(mounted and hinged,"Крепление/шарнир колеса не подтверждены: "..entry.spec.id);wheels=wheels+1
  elseif group=="spring"or group=="link"then
   local valid=false
   for _,constraint in ipairs(entry.model:GetDescendants())do if constraint:IsA("Constraint")and constraint.Enabled~=false and constraint.Attachment0 and constraint.Attachment1 then
    local a,b=constraint.Attachment0.Parent,constraint.Attachment1.Parent
    if a and b and a~=b and allowed[a]and allowed[b]and root(a)~=root(b)then
     local left,right=labels[root(a)],labels[root(b)]
     if (left.body and right.carrier)or(left.carrier and right.body)then
      if group=="spring"and constraint:IsA("SpringConstraint")then
       assert(record.tune and type(constraint.Stiffness)=="number"and type(constraint.Damping)=="number"and math.abs(constraint.Stiffness-record.tune.stiffness)<0.01 and math.abs(constraint.Damping-record.tune.damping)<0.01,"Настройки пружины не подтверждены")
       valid=true
      elseif group=="link"and constraint:IsA("RodConstraint")then valid=true end
     end
    end
   end end
   assert(valid,"Концы подвески не подтверждены: "..entry.spec.id)
   if group=="spring"then springs=springs+1 else links=links+1 end
  end
 end
 assert(wheels==4 and springs==4 and links==16,"Неполная ходовая часть")
 return record.plan.name..": 4 связи колёс, 4 пружины и 16 рычагов. Езда не проверена."
end
function C.step(dt,run)
 run.phaseTime=run.phaseTime+dt;run.sendClock=run.sendClock+dt
 if run.phaseTime>8 then N.stop("Гараж: нет подтверждения 8 секунд. Уже построенные детали сохранены.");return end
 if run.awaiting then return end
 assert(run.zone.Parent and run.folder.Parent,"Участок выгружен")
 if run.sendClock<(run.interval or 0.5)then return end;run.sendClock=0
 local q=run.plan.parts[run.index]
 if not q then
  if run.phase=="bind"then
   C.last={plan=run.plan,models=run.models,folder=run.folder,tune=run.tune}
   local groups=C.bindingGroups(run.models);local seat
   for _,entry in ipairs(run.models)do if entry.spec.group=="seat"then seat=entry.model end end
   assert(seat,"Сиденье не найдено")
   -- Current tool schema: action groups, controller, explicit keys, disconnect, switch mode.
   H.invoke(run,run.tools.bind,run.tools.bindRF,{groups,seat,{},false,false},"tuneStiffness");return
  elseif run.phase=="tuneStiffness"or run.phase=="tuneDamping"then
   local springs={};for _,entry in ipairs(run.models)do if entry.spec.group=="spring"then springs[#springs+1]=entry.model end end
   local stiffness=run.phase=="tuneStiffness"
   H.invoke(run,run.tools.props,run.tools.propsRF,{stiffness and "Stiffness"or "Damping",springs,stiffness and run.tune.stiffness or run.tune.damping},stiffness and "verifyStiffness"or "verifyDamping");return
  elseif run.phase=="verifyStiffness"or run.phase=="verifyDamping"then
   local stiffness=run.phase=="verifyStiffness";local property=stiffness and "Stiffness"or "Damping";local value=stiffness and run.tune.stiffness or run.tune.damping
   for _,entry in ipairs(run.models)do if entry.spec.group=="spring"then
    local spring=entry.model:FindFirstChildWhichIsA("SpringConstraint",true)
    if not spring or type(spring[property])~="number"or math.abs(spring[property]-value)>0.01 then return end
   end end
   run.phase=stiffness and "tuneDamping"or "finish";run.phaseTime=0;return
  elseif run.phase=="finish"then
   C.last={plan=run.plan,models=run.models,folder=run.folder,tune=run.tune};N.stop("Кузов и механика размещены. Машина закреплена; проверь связи и ходовую перед запуском.");return
  end
 end
 assert(q,"Неизвестная стадия сборки")
 local cf=C.cf(q,run.base);local color=Color3.fromRGB(table.unpack(q.color))
 if run.phase=="place"then
  local inventory=run.data:FindFirstChild(q.kind);assert(inventory and inventory.Value>0,"Закончились "..q.kind)
  local args={q.kind,inventory.Value,run.zone,run.zone.CFrame:ToObjectSpace(cf),true,cf,q.second and C.cf(q,run.base,true)or false}
  H.invoke(run,run.tools.build,run.tools.buildRF,args,"identify")
 elseif run.phase=="identify"then
  for _,model in ipairs(run.folder:GetChildren())do if not run.seen[model]and model.Name==q.kind then local part=model:FindFirstChild("PPart")
   if part and part:IsA("BasePart")and (part.Position-cf.Position).Magnitude<0.6 then
    run.seen[model]=true;run.model=model;run.part=part;run.models[#run.models+1]={model=model,spec=q};run.phase=q.size and "scale"or "paint";run.phaseTime=0;break
   end
  end end
 elseif run.phase=="scale"then H.invoke(run,run.tools.scale,run.tools.scaleRF,{run.model,Vector3.new(table.unpack(q.size)),cf},"verifyScale")
 elseif run.phase=="verifyScale"then
  assert(run.part.Parent,"Деталь удалена");if (run.part.Size-Vector3.new(table.unpack(q.size))).Magnitude<0.15 then run.phase="paint";run.phaseTime=0 end
 elseif run.phase=="paint"then H.invoke(run,run.tools.paint,run.tools.paintRF,{{{run.model,color}}},"verifyPaint")
 elseif run.phase=="verifyPaint"then
  assert(run.part.Parent,"Деталь удалена");local c=run.part.Color
  if math.abs(c.R-color.R)+math.abs(c.G-color.G)+math.abs(c.B-color.B)<0.04 then
   run.index=run.index+1;run.phase=run.index>#run.plan.parts and "bind"or "place";run.phaseTime=0
   A.status("Гараж · "..run.plan.name.." · "..(run.index-1).." / "..#run.plan.parts)
  end
 end
end
function C.release()
 assert(not N.job,"Останови текущую задачу");C.audit(C.last)
 local props=H.tool("PropertiesTool");local rf=props and props:FindFirstChild("SetPropertieRF");assert(rf and rf:IsA("RemoteFunction"),"Нужен PropertiesTool")
 local run=N.prepare("carRelease");run.models=C.last.models;run.phaseTime=0;run.awaiting=true
 run.task=task.spawn(function()
  local ok,err=pcall(function()
   local models={};for _,entry in ipairs(run.models)do models[#models+1]=entry.model end
   humOf(me):EquipTool(props);task.wait(0.15);if not A.alive or N.job~=run then return end
   assert(rf:InvokeServer("Anchored",models,false)~=false,"Сервер отказал")
   if not A.alive or N.job~=run then return end
   task.wait(0.5);if not A.alive or N.job~=run then return end
   for _,entry in ipairs(run.models)do for _,part in ipairs(entry.model:GetDescendants())do if part:IsA("BasePart")then assert(not part.Anchored,"Не все детали сняты с якоря")end end end
  end)
  if A.alive and N.job==run then run.task=nil;N.stop(ok and "Закрепление снято. Проверь езду вручную в игре."or("Запуск не подтверждён: "..tostring(err)))end
 end)
end
function C.cleanup()C.clearPreview();C.anchor=nil;C.last=nil;destroy(C.stage);C.stage=nil end
end
