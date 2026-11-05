-- Original NEBULA BABFT garage. Included inside Control; no external loaders.
do
local C={selected=1,paint=1,suspension=2,anchor=nil,preview=nil,last=nil,turn=0}
N.Cars=C
-- Individually authored station profiles, dimensions in mm; no downloaded 3D assets.
-- Individually authored station profiles, dimensions in mm; no downloaded 3D assets.
-- Individually authored station profiles, dimensions in mm; no downloaded 3D assets.
C.catalog={
 {name="720S · Papaya",inspired="McLaren 720S",color={246,103,24},mm={4543,1930,1196,2670},roofTone="black",shape="720",wing="active"},
 {name="P1 · Volcano",inspired="McLaren P1",color={241,192,29},mm={4588,1946,1188,2670},roofTone="black",shape="p1",wing="p1"},
 {name="Senna · Track",inspired="McLaren Senna",color={230,89,27},mm={4744,1958,1229,2670},roofTone="black",shape="senna",wing="senna"},
 {name="488 GTB · Rosso",inspired="Ferrari 488 GTB",color={204,20,35},mm={4568,1952,1213,2650},roofTone="body",shape="488",wing="lip"},
 {name="SF90 · Stradale",inspired="Ferrari SF90 Stradale",color={225,26,38},mm={4710,1972,1186,2650},roofTone="black",shape="sf90",wing="active"},
 {name="Huracán EVO · Verde",inspired="Lamborghini Huracán EVO",color={125,200,40},mm={4520,1933,1165,2620},roofTone="body",shape="huracan",wing="lip"},
 {name="911 GT3 RS · Weissach",inspired="Porsche 911 GT3 RS (992)",color={213,216,214},mm={4572,1900,1322,2457},roofTone="black",shape="911",wing="swan"},
 {name="Chiron · Atlantic",inspired="Bugatti Chiron",color={42,151,221},mm={4544,2038,1212,2711},roofTone="body",shape="chiron",wing="active"},
 {name="Jesko Attack · Pearl",inspired="Koenigsegg Jesko Attack",color={222,225,218},mm={4626,2030,1210,2700},roofTone="body",shape="jesko",wing="jesko"},
 {name="GT-R R35 · Gunmetal",inspired="Nissan GT-R R35 (2017)",color={95,102,112},mm={4710,1895,1370,2780},roofTone="body",shape="gtr",wing="gtr"},
}
C.paints={{name="Заводской"},{name="Чёрный",rgb={22,23,27}},{name="Жемчуг",rgb={225,225,218}},{name="Фиолетовый",rgb={94,45,156}},{name="Серебро",rgb={143,154,163}}}
C.suspensions={{name="Мягкая",stiffness=12000,damping=700},{name="Спорт",stiffness=24000,damping=1200},{name="Трек",stiffness=40000,damping=1800}}
-- t, half-width / max half-width, centre deck / total height, outer shoulder / total height.
C.profiles={
 {{0,.68,.29,.28},{.07,.87,.37,.40},{.18,.99,.42,.61},{.28,1,.44,.62},{.4,.93,.43,.51},{.51,.91,.43,.50},{.65,.98,.46,.58},{.77,1,.50,.63},{.89,.96,.48,.56},{1,.85,.43,.44}},
 {{0,.59,.25,.28},{.08,.88,.36,.43},{.21,1,.43,.62},{.31,.98,.45,.62},{.44,.84,.42,.48},{.55,.86,.43,.51},{.67,.99,.48,.63},{.79,1,.52,.63},{.91,.90,.46,.52},{1,.71,.38,.39}},
 {{0,.87,.26,.29},{.08,.98,.34,.43},{.20,1,.43,.61},{.31,.98,.45,.61},{.43,.91,.41,.51},{.55,.93,.43,.53},{.68,1,.49,.62},{.80,1,.51,.60},{.91,.98,.47,.51},{1,.94,.41,.44}},
 {{0,.67,.31,.30},{.08,.87,.38,.44},{.20,.99,.45,.62},{.30,.98,.45,.62},{.42,.90,.43,.54},{.52,.88,.44,.52},{.66,.98,.48,.61},{.78,1,.52,.63},{.9,.96,.49,.55},{1,.83,.44,.45}},
 {{0,.79,.26,.28},{.08,.96,.34,.42},{.20,1,.42,.60},{.30,.99,.44,.61},{.41,.91,.42,.53},{.52,.9,.42,.52},{.65,.99,.46,.62},{.77,1,.49,.64},{.9,.96,.45,.53},{1,.89,.40,.43}},
 {{0,.83,.25,.28},{.09,.97,.31,.39},{.21,1,.40,.61},{.32,.98,.44,.59},{.44,.93,.44,.50},{.54,.94,.45,.51},{.67,1,.46,.61},{.79,1,.48,.61},{.92,.96,.42,.49},{1,.89,.39,.41}},
 {{0,.62,.29,.32},{.09,.83,.36,.47},{.21,.97,.42,.65},{.31,.98,.43,.65},{.43,.91,.42,.51},{.55,.91,.44,.51},{.68,.98,.46,.60},{.79,1,.48,.62},{.91,.95,.42,.52},{1,.79,.36,.40}},
 {{0,.72,.37,.38},{.09,.91,.43,.49},{.20,1,.49,.64},{.31,.99,.50,.64},{.43,.94,.48,.54},{.54,.96,.49,.54},{.66,1,.52,.61},{.78,.99,.54,.63},{.9,.96,.48,.55},{1,.89,.43,.46}},
 {{0,.59,.23,.26},{.08,.87,.31,.4},{.20,1,.40,.61},{.31,.97,.43,.61},{.42,.87,.40,.49},{.52,.88,.42,.50},{.65,.99,.45,.61},{.77,1,.48,.64},{.9,.96,.43,.53},{1,.8,.35,.40}},
 {{0,.83,.40,.41},{.08,.94,.48,.49},{.20,1,.51,.57},{.31,.98,.51,.57},{.43,.95,.50,.53},{.54,.95,.50,.53},{.66,.99,.50,.57},{.78,1,.51,.59},{.9,.99,.49,.55},{1,.92,.46,.49}},
}
-- Separate windscreen/roof/fastback station sets: t, half-width ratio, height ratio.
C.canopies={
 {{.285,.65,.46},{.34,.60,.72},{.41,.51,.96},{.48,.49,1},{.56,.48,.99},{.63,.44,.87},{.70,.37,.65},{.76,.29,.51}},
 {{.28,.60,.46},{.35,.54,.77},{.43,.45,.98},{.49,.44,1},{.56,.43,.97},{.62,.37,.83},{.68,.29,.62},{.73,.20,.51}},
 {{.29,.63,.46},{.36,.57,.78},{.43,.49,.99},{.50,.48,1},{.56,.47,.97},{.62,.43,.81},{.68,.36,.62},{.72,.28,.52}},
 {{.28,.66,.46},{.35,.60,.74},{.43,.52,.96},{.50,.52,1},{.57,.51,.99},{.64,.46,.86},{.71,.37,.65},{.76,.30,.53}},
 {{.27,.66,.44},{.34,.61,.74},{.42,.53,.97},{.49,.52,1},{.56,.52,.99},{.63,.47,.88},{.69,.36,.65},{.74,.25,.50}},
 {{.265,.68,.45},{.34,.61,.72},{.415,.53,.98},{.48,.52,1},{.555,.52,.98},{.63,.45,.80},{.70,.34,.58},{.76,.23,.49}},
 {{.305,.67,.45},{.37,.60,.73},{.44,.55,.94},{.51,.54,1},{.58,.53,.99},{.65,.49,.90},{.73,.42,.69},{.82,.28,.47}},
 {{.29,.68,.52},{.36,.63,.78},{.43,.55,.98},{.50,.54,1},{.57,.54,.99},{.64,.51,.91},{.71,.44,.72},{.77,.33,.56}},
 {{.27,.66,.43},{.34,.60,.77},{.41,.51,.98},{.48,.49,1},{.55,.49,.97},{.62,.46,.86},{.69,.36,.64},{.76,.24,.48}},
 {{.285,.76,.52},{.35,.69,.77},{.42,.60,.98},{.5,.59,1},{.58,.58,.98},{.65,.56,.87},{.73,.49,.65},{.81,.36,.52}},
}
function C.plan(which,paint)
 local selected=which or C.selected;local d=assert(C.catalog[selected],"Нет модели")
 local l,w,h,wb=d.mm[1]/220,d.mm[2]/440,d.mm[3]/220,d.mm[4]/220
 local p={name=d.name,inspired=d.inspired,parts={},bill={},length=l,width=w*2,height=h,wheelbase=wb,mm=d.mm,revision=2}
 local colors={body=(C.paints[paint or C.paint]or C.paints[1]).rgb or d.color,black={15,17,20},glass={26,36,44},metal={125,130,136},white={231,241,250},red={240,25,38},accent={205,42,39},darkBody={17,34,54},amber={245,161,34}}
 local ids={}
 local function add(id,kind,pos,size,tone,group,rot,second,basis)
  assert(not ids[id],"Duplicate car part: "..id);ids[id]=true
  local q={id=id,kind=kind,pos=pos,size=size,color=colors[tone or "body"],group=group or "body",rot=rot or {0,0,0},second=second,basis=basis}
  if q.size then for i=1,3 do q.size[i]=math.max(.1,q.size[i])end end
  p.parts[#p.parts+1]=q;p.bill[kind]=(p.bill[kind]or 0)+1;return q
 end
 local function V(a,b,c)return {a,b,c}end
 local function plus(a,b)return V(a[1]+b[1],a[2]+b[2],a[3]+b[3])end
 local function minus(a,b)return V(a[1]-b[1],a[2]-b[2],a[3]-b[3])end
 local function times(a,t)return V(a[1]*t,a[2]*t,a[3]*t)end
 local function dot(a,b)return a[1]*b[1]+a[2]*b[2]+a[3]*b[3]end
 local function cross(a,b)return V(a[2]*b[3]-a[3]*b[2],a[3]*b[1]-a[1]*b[3],a[1]*b[2]-a[2]*b[1])end
 local function norm(a)local n=math.sqrt(dot(a,a));assert(n>1e-8,"Collapsed panel");return times(a,1/n)end
 local function panel(id,a,b,c,e,tone,kind)
  local centre=times(plus(plus(a,b),plus(c,e)),.25)
  local x=norm(plus(minus(b,a),minus(c,e)));local z=norm(plus(minus(e,a),minus(c,b)));local y=norm(cross(z,x));z=norm(cross(x,y))
  local sx,sz,sy=0,0,0
  for _,point in ipairs({a,b,c,e})do local delta=minus(point,centre);sx=math.max(sx,math.abs(dot(delta,x))*2);sz=math.max(sz,math.abs(dot(delta,z))*2);sy=math.max(sy,math.abs(dot(delta,y))*2)end
  local basis={x[1],y[1],z[1],x[2],y[2],z[2],x[3],y[3],z[3]}
  return add(id,kind or "PlasticBlock",centre,V(sx+.025,math.max(.1,sy+.065),sz+.025),tone,"body",nil,nil,basis)
 end
 local function box(id,x,y,z,sx,sy,sz,tone,rx,ry,rz,kind)
  return add(id,kind or "PlasticBlock",V(x,y,z),V(sx,sy,sz),tone,"body",V(rx or 0,ry or 0,rz or 0))
 end
 local function beam(id,a,b,width,tone,depth,kind)
  local delta=minus(b,a);local x=norm(delta);local ref=math.abs(x[2])>.95 and V(0,0,1)or V(0,1,0);local z=norm(cross(x,ref));local y=norm(cross(z,x))
  return add(id,kind or "PlasticBlock",times(plus(a,b),.5),V(math.sqrt(dot(delta,delta))+.035,width,depth or width),tone,"body",nil,nil,{x[1],y[1],z[1],x[2],y[2],z[2],x[3],y[3],z[3]})
 end
 local function curve(id,points,width,tone,depth)
  for i=2,#points do beam(id..":"..i,points[i-1],points[i],width,tone,depth)end
 end
 local function lerpProfile(rows,t)
  for i=2,#rows do if t<=rows[i][1]then
   local a,b=rows[i-1],rows[i];local dt=b[1]-a[1];local f=math.clamp((t-a[1])/dt,0,1);local out={t}
   for k=2,#a do
    if selected==6 or selected==10 then out[k]=a[k]+(b[k]-a[k])*f
    else
     local prev,nextRow=rows[math.max(1,i-2)],rows[math.min(#rows,i+1)]
     local m0=(b[k]-prev[k])/(b[1]-prev[1]);local m1=(nextRow[k]-a[k])/(nextRow[1]-a[1])
     local f2,f3=f*f,f*f*f
     out[k]=math.clamp((2*f3-3*f2+1)*a[k]+(f3-2*f2+f)*dt*m0+(-2*f3+3*f2)*b[k]+(f3-f2)*dt*m1,math.min(a[k],b[k]),math.max(a[k],b[k]))
    end
   end
   return out
  end end
  return rows[#rows]
 end
 local function body(t,u)
  local v=lerpProfile(C.profiles[selected],t);local f=math.abs(u)
  local blend=f^1.7;local crown=math.sin(math.pi*f)*.055
  return V(w*v[2]*u,h*(v[3]+(v[4]-v[3])*blend+crown),l*(t-.5))
 end
 local front,rear=-wb/2,wb/2;local wheelY=1.58;local archR=1.74
 -- A connected ladder-frame. Skin is genuine scaled blocks, not local-only meshes.
 box("spine",0,1.3,0,2.4,.5,l*.84,"metal",nil,nil,nil,"MetalBlock")
 for i,z in ipairs({front,0,rear})do box("crossmember"..i,0,1.35,z,w*1.74,.4,.5,"metal",nil,nil,nil,"MetalBlock")end
 for _,s in ipairs({-1,1})do
  box("rail"..s,s*w*.73,1.25,0,.45,.65,l*.82,"metal",nil,nil,nil,"MetalBlock")
  box("sill"..s,s*w*.91,.8,0,.45,.5,l*.67,"black")
 end
 -- Curved double-curvature deck: authored shoulder and centre heights vary separately.
 local long,across=48,8
 for i=1,long do for j=1,across do
  local a,b=(i-1)/long,i/long;local u,v=-1+2*(j-1)/across,-1+2*j/across
  local tone=d.shape=="chiron"and a>.64 and "darkBody"or "body"
  panel("skin:deck:"..i..":"..j,body(a,u),body(a,v),body(b,v),body(b,u),tone)
 end end
 -- Lower flanks are clipped to circular wheel apertures, rather than covered by slabs.
 local function lowY(z)
  local low=.7
  for _,axle in ipairs({front,rear})do local delta=z-axle;if math.abs(delta)<archR then low=math.max(low,wheelY+math.sqrt(archR^2-delta^2))end end
  return low
 end
 for _,s in ipairs({-1,1})do for i=1,long do
  local ta,tb=(i-1)/long,i/long;local a,b=body(ta,s),body(tb,s);local ya,yb=lowY(a[3]),lowY(b[3])
  if ya<a[2]-.03 and yb<b[2]-.03 then
   local bottomA=V(a[1]*.94,ya,a[3]);local bottomB=V(b[1]*.94,yb,b[3]);local midA=V(a[1]*1.005,(ya+a[2])*.5,a[3]);local midB=V(b[1]*1.005,(yb+b[2])*.5,b[3])
   local tone=d.shape=="chiron"and ta>.6 and "darkBody"or "body"
   panel("skin:side:upper:"..s..":"..i,a,b,midB,midA,tone)
   panel("skin:side:lower:"..s..":"..i,midA,midB,bottomB,bottomA,tone)
  end
 end end
 -- Close both bumper faces with curved horizontal courses.
 for _,t in ipairs({0,1})do for j=1,12 do
  local u,v=-1+2*(j-1)/12,-1+2*j/12;local a,b=body(t,u),body(t,v)
  local ma,mb=V(a[1],.65,a[3]),V(b[1],.65,b[3])
  panel("skin:bumper:"..t..":"..j,a,b,mb,ma,d.shape=="chiron"and t==1 and "darkBody"or "body")
 end end
 -- Every canopy has its own longitudinal shape; transverse curvature removes the box roof.
 local canopy=C.canopies[selected];local start,finish=canopy[1][1],canopy[#canopy][1]
 local function canopyPoint(t,u)
  local row=lerpProfile(canopy,t);local base=body(t,u*.7)[2]-.05;local rounded=math.max(0,1-math.abs(u)^3.5)^.45
  return V(w*row[2]*u,base+(h*row[3]-base)*rounded,l*(t-.5))
 end
 local roofStart,roofEnd=start+(finish-start)*.31,start+(finish-start)*.68
 for i=1,28 do for j=1,10 do
  local ta=start+(finish-start)*(i-1)/28;local tb=start+(finish-start)*i/28;local u,v=-1+2*(j-1)/10,-1+2*j/10
  local centre=(u+v)*.5;local tm=(ta+tb)*.5;local isRoof=tm>roofStart and tm<roofEnd and math.abs(centre)<.61
  local isPillar=math.abs(centre)>.8 and (math.abs(tm-roofStart)<.012 or math.abs(tm-roofEnd)<.012)
  local tone=isRoof and d.roofTone or(isPillar and "body"or "glass")
  panel("canopy:"..i..":"..j,canopyPoint(ta,u),canopyPoint(ta,v),canopyPoint(tb,v),canopyPoint(tb,u),tone,tone=="glass"and "GlassBlock"or "PlasticBlock")
 end end
 -- Seals and roof rails follow the curved canopy rather than a generic rectangular window.
 for _,side in ipairs({-1,1})do
  local seal={};for i=0,28 do seal[#seal+1]=canopyPoint(start+(finish-start)*i/28,side*.99)end;curve("windowSeal"..side,seal,.105,"black")
  local roofRail={};for i=0,14 do roofRail[#roofRail+1]=canopyPoint(roofStart+(roofEnd-roofStart)*i/14,side*.65)end;curve("roofRail"..side,roofRail,.11,d.roofTone)
 end
 -- Common interior is below the independent exterior surfaces.
 add("driver","CarSeat",V(-1.03,1.85,l*.025),nil,"black","seat")
 box("floor",0,1.55,.2,4.6,.25,5.7,"black")
 box("dash",0,2.6,l*(start-.5)+.45,4.3,.35,.8,"black")
 box("console",0,2.1,.2,.5,.6,3.2,"black")
 for _,s in ipairs({-1,1})do
  box("seatPad"..s,s*1.05,1.95,.4,1.3,.3,1.6,"black")
  box("seatBack"..s,s*1.05,2.65,1.15,1.4,1.8,.35,"black",-12)
  local mirrorBase=body(.37,s*.8);local mirrorEnd=V(s*(w+.3),h*.66,l*(-.12))
  beam("mirrorArm"..s,mirrorBase,mirrorEnd,.14,"black");box("mirror"..s,mirrorEnd[1],mirrorEnd[2],mirrorEnd[3],.6,.24,.48,"body",0,s*15)
  local handle=body(.51,s);box("handle"..s,handle[1]+s*.035,handle[2]-.3,handle[3],.1,.1,.47,"metal")
 end
 -- Surface decals are made from scaled parts. Points are in each model's own body coordinates.
 local function topCurve(id,side,pts,width,tone,depth)
  local points={};for _,a in ipairs(pts)do local point=body(a[1],side*a[2]);point[2]=point[2]+(a[3]or .085);points[#points+1]=point end
  curve(id..side,points,width,tone,depth)
 end
 local function ring(id,centre,rx,ry,plane,tone,width,n)
  local points={};for j=0,n or 20 do local a=j/(n or 20)*math.pi*2
   points[#points+1]=plane=="side"and V(centre[1],centre[2]+math.sin(a)*ry,centre[3]+math.cos(a)*rx)or V(centre[1]+math.cos(a)*rx,centre[2]+math.sin(a)*ry,centre[3])
  end;curve(id,points,width,tone)
 end
 local noseZ,tailZ=-l/2-.055,l/2+.055
 local function frontVent(id,x,y,sx,sy)
  box(id,x,y,noseZ,sx,sy,.12,"black")
  for j=1,4 do box(id.."slat"..j,x-sx*.5+j*sx/5,y,noseZ-.08,.1,sy*.85,.1,"black")end
 end
 local function tailRing(id,x,y,r)
  box(id.."core",x,y,tailZ,.52,.52,.12,"black");ring(id,V(x,y,tailZ+.09),r,r,"front","red",.105,24)
 end
 local function sideScoop(id,side,z,y,rx,ry,shape)
  local x=side*w*.982
  local points={}
  for j=0,18 do local a=j/18*math.pi*2;local f=shape=="triangle"and (math.cos(a)>=0 and 1 or .65)or 1
   points[#points+1]=V(x,y+math.sin(a)*ry,z+math.cos(a)*rx*f)
  end
  -- Black infill is a set of narrow upright strips, not just a floating outline.
  for j=1,9 do local f=-1+2*(j-.5)/9;local span=math.sqrt(math.max(0,1-f*f))*ry
   box(id.."fill"..side..":"..j,x,y,z+rx*f,.13,span*2,rx*2/9+.025,"black")
  end
  curve(id.."rim"..side,points,.12,"body")
 end
 -- Ten different signatures, not a lamp/wing switch on one car.
 for _,s in ipairs({-1,1})do
  if d.shape=="720"then
   for row=1,5 do topCurve("eyeSocket"..row,s,{{.055,.52+row*.04},{.08,.70+row*.035},{.13,.88},{.19,.84}},.21,"black",.13)end
   topCurve("eyeLED",s,{{.059,.57},{.078,.73},{.112,.85},{.15,.88}},.105,"white")
   topCurve("bonnetRidge",s,{{.11,.3},{.2,.38},{.29,.46}},.12,"body")
   sideScoop("doubleSkin",s,l*.13,h*.39,1.65,.49,"oval")
   frontVent("frontOpening"..s,s*w*.48,h*.18,2.0,.55)
   curve("tailArc"..s,{V(s*w*.25,h*.43,tailZ),V(s*w*.64,h*.47,tailZ),V(s*w*.87,h*.42,tailZ)},.1,"red")
   ring("exhaust"..s,V(s*.62,h*.33,tailZ+.14),.23,.23,"front","metal",.11,16)
  elseif d.shape=="p1"then
   for row=1,4 do topCurve("p1Pocket"..row,s,{{.06,.5+row*.05},{.09,.79},{.16,.9},{.2,.86}},.23,"black")end
   topCurve("p1Boomerang",s,{{.075,.54},{.092,.8},{.16,.88},{.192,.82}},.11,"white")
   topCurve("bonnetNostril",s,{{.20,.16},{.25,.21},{.28,.22}},.25,"black",.4)
   sideScoop("deepIntake",s,l*.12,h*.40,1.75,.7,"oval")
   frontVent("frontOpening"..s,s*w*.5,h*.16,2.0,.62)
   curve("p1Tail"..s,{V(s*w*.15,h*.45,tailZ),V(s*w*.7,h*.48,tailZ),V(s*w*.86,h*.4,tailZ),V(s*w*.72,h*.29,tailZ)},.11,"red")
  elseif d.shape=="senna"then
   topCurve("sennaCarbon",s,{{.05,.3},{.10,.48},{.20,.48},{.28,.32}},.42,"black",.65)
   for row=1,3 do topCurve("sennaEye"..row,s,{{.07,.6+row*.05},{.12,.87},{.20,.91}},.19,"black")end
   topCurve("sennaLED",s,{{.095,.6},{.12,.8},{.17,.9}},.11,"white")
   sideScoop("sennaIntake",s,l*.17,h*.48,1.7,.91,"triangle")
   frontVent("sennaDuct"..s,s*w*.53,h*.17,1.7,.8)
   box("sennaBlade"..s,s*w*.83,.85,-l*.42,.15,.8,1.0,"black",0,s*12)
   box("sennaDoorGlass"..s,s*w*.90,h*.32,0,.13,.8,2.6,"glass",0,s*3,0,"GlassBlock")
   box("sennaTailLED"..s,s*w*.64,h*.43,tailZ,1.8,.11,.12,"red")
  elseif d.shape=="488"then
   for row=1,3 do topCurve("488Housing"..row,s,{{.06,.59+row*.035},{.12,.78},{.24,.91}},.19,"black")end
   topCurve("488VerticalLED",s,{{.065,.59},{.12,.76},{.23,.88}},.115,"white")
   sideScoop("488SplitDuct",s,l*.15,h*.44,1.3,.73,"triangle")
   beam("488DuctDivider"..s,V(s*w,h*.45,l*.08),V(s*w,h*.43,l*.21),.14,"body",.15)
   frontVent("488Front"..s,s*w*.5,h*.20,2.05,.75)
   tailRing("488RearLamp"..s,s*w*.68,h*.40,.31)
   ring("488Exhaust"..s,V(s*w*.46,h*.18,tailZ+.1),.25,.25,"front","metal",.11,16)
  elseif d.shape=="sf90"then
   for row=1,3 do topCurve("sfHousing"..row,s,{{.055,.48+row*.05},{.09,.82},{.16,.88}},.2,"black")end
   topCurve("sfCLED",s,{{.065,.5},{.08,.76},{.11,.85},{.16,.83}},.11,"white")
   sideScoop("sf90HighIntake",s,l*.17,h*.53,1.5,.5,"triangle")
   frontVent("sf90Front"..s,s*w*.49,h*.17,2.55,.65)
   for k=1,2 do
    local x=s*w*(.5+k*.16);curve("sfSquareTail"..s..":"..k,{V(x-.23,h*.44-.16,tailZ),V(x+.23,h*.44-.16,tailZ),V(x+.23,h*.44+.16,tailZ),V(x-.23,h*.44+.16,tailZ),V(x-.23,h*.44-.16,tailZ)},.11,"red")
   end
   ring("sfExhaust"..s,V(s*.75,h*.29,tailZ+.12),.28,.28,"front","metal",.11,16)
  elseif d.shape=="huracan"then
   for row=1,3 do topCurve("huracanEye"..row,s,{{.065,.51+row*.07},{.10,.77},{.19,.89}},.2,"black")end
   topCurve("huracanY1",s,{{.08,.58},{.115,.76},{.18,.85}},.11,"white")
   topCurve("huracanY2",s,{{.115,.76},{.14,.62}},.11,"white")
   sideScoop("huracanWedgeScoop",s,l*.13,h*.37,1.7,.53,"triangle")
   frontVent("huracanHex"..s,s*w*.55,h*.18,2.2,.64)
   topCurve("huracanBonnet",s,{{.06,.18},{.23,.48},{.29,.5}},.1,"body")
   curve("huracanRearY"..s,{V(s*w*.43,h*.42,tailZ),V(s*w*.68,h*.42,tailZ),V(s*w*.84,h*.35,tailZ)},.105,"red")
   ring("huracanHighExhaust"..s,V(s*.93,h*.30,tailZ+.1),.3,.3,"front","metal",.13,12)
  elseif d.shape=="911"then
   local centre=body(.13,s*.71);centre[2]=centre[2]+.18
   local loop={};for j=0,28 do local a=j/28*math.pi*2;local pt=body(.13+math.sin(a)*.035,s*(.71+math.cos(a)*.13));pt[2]=pt[2]+.15;loop[#loop+1]=pt end
   curve("911OvalPocket"..s,loop,.22,"black");curve("911OvalLED"..s,loop,.105,"white")
   topCurve("911HoodVent",s,{{.18,.16},{.26,.22},{.30,.25}},.38,"black",.65)
   for j=1,5 do topCurve("911FenderGill"..j,s,{{.21+j*.012,.70},{.21+j*.012,.95}},.11,"black")end
   frontVent("911FrontRadiator"..s,s*w*.54,h*.17,1.8,.75)
   box("911SideStrake"..s,s*w*.94,1.0,0,.24,.23,l*.25,"black")
   box("911RearLED"..s,s*w*.48,h*.37,tailZ,w*.95,.105,.12,"red")
   ring("911Exhaust"..s,V(s*.45,h*.13,tailZ+.15),.22,.22,"front","metal",.105,16)
  elseif d.shape=="chiron"then
   for k=1,4 do local x=s*w*(.40+k*.09)
    curve("chironQuad"..s..":"..k,{V(x-.12,h*.39-.10,noseZ-.08),V(x+.12,h*.39-.10,noseZ-.08),V(x+.12,h*.39+.10,noseZ-.08),V(x-.12,h*.39+.10,noseZ-.08),V(x-.12,h*.39-.10,noseZ-.08)},.10,"white")
   end
   frontVent("chironLower"..s,s*w*.57,h*.17,2.2,.48)
   sideScoop("chironIntake",s,l*.12,h*.43,1.6,1.05,"oval")
   local line={V(s*w*.52,h*.98,0),V(s*w*.70,h*.94,l*.06),V(s*w*.85,h*.85,l*.13),V(s*w*.98,h*.65,l*.19),V(s*w,h*.45,l*.19),V(s*w*.99,h*.22,l*.14),V(s*w*.96,h*.15,l*.04),V(s*w*.94,h*.18,-l*.08)}
   curve("chironCBar"..s,line,.15,"metal",.13)
  elseif d.shape=="jesko"then
   for row=1,3 do topCurve("jeskoEye"..row,s,{{.075,.62+row*.04},{.13,.82},{.22,.91}},.17,"black")end
   topCurve("jeskoLED",s,{{.075,.62},{.12,.8},{.21,.88}},.11,"white")
   sideScoop("jeskoScoop",s,l*.13,h*.35,1.8,.73,"oval")
   frontVent("jeskoMainDuct"..s,s*w*.49,h*.14,2.3,.7)
   topCurve("jeskoHoodDam",s,{{.19,.11},{.27,.18},{.30,.19}},.27,"black",.4)
   box("jeskoCanard"..s,s*w,.9,-l*.37,.8,.12,1.5,"black",-12,s*18)
   curve("jeskoRearHook"..s,{V(s*w*.28,h*.4,tailZ),V(s*w*.69,h*.43,tailZ),V(s*w*.79,h*.36,tailZ)},.11,"red")
  elseif d.shape=="gtr"then
   for row=1,3 do topCurve("gtrHousing"..row,s,{{.06,.54+row*.06},{.12,.83},{.22,.91}},.21,"black")end
   topCurve("gtrLightning",s,{{.065,.56},{.115,.82},{.18,.88},{.21,.84}},.11,"white")
   topCurve("gtrBonnetNostril",s,{{.20,.22},{.25,.24},{.28,.22}},.25,"black",.5)
   frontVent("gtrLowerBrake"..s,s*w*.75,h*.16,.9,.6)
   for k=1,2 do tailRing("gtrRoundTail"..s..":"..k,s*w*(.40+k*.19),h*.41,k==2 and .32 or .29)end
   for k=1,2 do ring("gtrExhaust"..s..":"..k,V(s*(w*.55+k*.19),h*.13,tailZ+.15),.19,.19,"front","metal",.11,16)end
  end
 end
 if d.shape=="p1"then ring("p1CentralExhaust",V(0,h*.34,tailZ+.15),.4,.3,"front","metal",.13,18)end
 if d.shape=="chiron"then
  local horse={};for j=0,24 do local a=math.pi*j/24;horse[#horse+1]=V(math.cos(a)*.65,h*.19+math.sin(a)*h*.25,noseZ-.12)end
  horse[#horse+1]=V(-.65,h*.11,noseZ-.12);horse[#horse+1]=V(.65,h*.11,noseZ-.12);horse[#horse+1]=horse[1]
  box("chironHorseCore",0,h*.23,noseZ,1.25,h*.32,.15,"black");curve("chironHorseshoe",horse,.14,"metal")
  box("chironContinuousRearLED",0,h*.43,tailZ,w*1.78,.105,.13,"red")
  local fin={};for i=0,20 do local t=.70+i*.29/20;local v=body(t,0);v[2]=v[2]+.13;fin[#fin+1]=v end;curve("chironSpine",fin,.11,"metal")
 elseif d.shape=="gtr"then
  frontVent("gtrCentralGrille",0,h*.28,3.4,1.25)
  curve("gtrVGrille",{V(-1.9,h*.43,noseZ-.13),V(-1.3,h*.18,noseZ-.13),V(1.3,h*.18,noseZ-.13),V(1.9,h*.43,noseZ-.13)},.14,"metal")
 end
 -- Model-specific rear aerodynamics: no identical spoiler across ten cars.
 local wingZ=l*.39
 if d.wing=="senna"or d.wing=="swan"or d.wing=="jesko"then
  local wingY=d.wing=="swan"and h*1.06 or d.wing=="senna"and h*.98 or h*.91
  local span=d.wing=="jesko"and w*2.1 or w*1.95
  for _,s in ipairs({-1,1})do
   local a=body(.79,s*.45);local b=V(s*w*.46,wingY+.3,wingZ-.45);local c=V(s*w*.46,wingY,wingZ+.1)
   curve("wingUpright"..s,{a,b,c},d.wing=="swan"and .16 or .23,"black",.3)
   box("wingEndplate"..s,s*span/2,wingY+.15,wingZ,.14,.65,d.wing=="jesko"and 2.1 or 1.5,"black",-9)
  end
  for j=1,16 do local u=-1+2*(j-.5)/16;local dihedral=math.abs(u)^2*.18
   box("wingMain"..j,u*span/2,wingY+dihedral,wingZ,span/16+.025,.15,d.wing=="jesko"and 1.65 or 1.2,"black",-8,0,u*4)
   if d.wing~="senna"then box("wingFlap"..j,u*span/2,wingY+.25+dihedral,wingZ+.67,span/16+.025,.13,.58,"black",-19)end
  end
 elseif d.wing=="gtr"then
  for _,s in ipairs({-1,1})do box("gtrWingStand"..s,s*2.0,h*.56,wingZ,.25,.9,.45,"body")end
  box("gtrSpoiler",0,h*.64,wingZ,w*1.62,.18,.8,"body",-6)
 elseif d.wing=="p1"then
  for _,s in ipairs({-1,1})do box("p1WingStand"..s,s*2,h*.51,wingZ,.23,.75,.45,"black")end
  box("p1DeployableWing",0,h*.59,wingZ,w*1.72,.16,1.0,"black",-7)
 else
  local points={};for j=0,20 do local v=body(.98,-.92+j*1.84/20);v[2]=v[2]+.13;points[#points+1]=v end;curve("integratedTailLip",points,.15,"body",.24)
 end
 -- Sliced splitters follow each nose's taper; rear diffuser includes actual vertical fins.
 for j=1,20 do
  local u=-.98+1.96*(j-.5)/20;local v=body(.015,u)
  box("frontSplitter"..j,v[1],.57,v[3]-.12,w*2/20+.04,.14,.72,"black",0,-u*14)
 end
 box("rearDiffuser",0,.65,l*.46,w*1.72,.16,1.4,"black",10)
 for j=-3,3 do box("diffuserFin"..j,j*.75,.75,l*.465,.12,.7,1.45,"black",8)end
 -- Wheels are game mechanisms. No fake rotating locally welded visual wheels.
 local links={}
 for _,s in ipairs({-1,1})do for axle,z in ipairs({front,rear})do
  local id=s..":"..axle;local carrier=s*(w-.95)
  add("carrier"..id,"MetalBlock",V(carrier,1.5,z),V(.65,1.45,1.65),"metal","carrier")
  local wheel=add("wheel"..id,axle==1 and "FrontWheel"or "BackWheel",V(s*(w-.1),wheelY,z),nil,"black","wheel",V(0,s==1 and 180 or 0,0));wheel.previewSize={1.0,3.16,3.16}
  links[#links+1]={"spring"..id,"Spring",V(s*w*.73,2.55,z),V(carrier,1.6,z),"spring"}
  for _,yy in ipairs({1.05,2.0})do for _,offset in ipairs({-.55,.55})do links[#links+1]={"arm"..id..":"..yy..":"..offset,"Bar",V(s*w*.73,yy,z+offset),V(carrier,yy,z+offset),"link"}end end
 end end
 for _,q in ipairs(links)do add(q[1],q[2],q[3],nil,"metal",q[5],nil,q[4])end
 return p
end

function C.cf(v,base,second)
 local pos=second and v.second or v.pos;local r=v.rot
 if not second and v.basis then return base*CFrame.new(pos[1],pos[2],pos[3],table.unpack(v.basis))end
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
  local cf=C.cf(q,base);local size=q.size and Vector3.new(table.unpack(q.size))or(q.previewSize and Vector3.new(table.unpack(q.previewSize))or(q.group=="wheel"and Vector3.new(1,3,3)or Vector3.new(1,0.5,1)))
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
