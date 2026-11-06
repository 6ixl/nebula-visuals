-- NEBULA BABFT Garage: Legacy profiles + New data assets. Included in Control.
do
local C={selected=1,paint=1,suspension=2,anchor=nil,preview=nil,last=nil,turn=0}
N.Cars=C
-- Legacy profiles are authored locally; credited New meshes load as validated JSON data.
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
C.livery=C.livery or 1;C.accent=C.accent or 1
C.liveries={"Акценты модели","Трековые полосы","Контрастный верх"}
C.accentPaints={{name="По модели"},{name="Красный",rgb={227,40,44}},{name="Лайм",rgb={167,222,43}},{name="Белый",rgb={224,230,232}},{name="Голубой",rgb={41,164,222}},{name="Золото",rgb={221,171,50}}}
C.modelAccents={{238,83,24},{225,47,40},{38,150,205},{229,201,93},{235,193,29},{141,222,40},{205,36,43},{171,197,214},{150,212,38},{206,39,48}}
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
function C.plan(which,paint,livery,accent)
 local selected=which or C.selected;local d=assert(C.catalog[selected],"Нет модели")
 local l,w,h,wb=d.mm[1]/220,d.mm[2]/440,d.mm[3]/220,d.mm[4]/220
 local style=livery or C.livery;assert(C.liveries[style],"Нет схемы окраски")
 local accentRGB=(C.accentPaints[accent or C.accent]or C.accentPaints[1]).rgb or C.modelAccents[selected]
 local p={name=d.name,inspired=d.inspired,parts={},bill={},length=l,width=w*2,height=h,wheelbase=wb,mm=d.mm,revision=3,livery=C.liveries[style]}
 local colors={body=(C.paints[paint or C.paint]or C.paints[1]).rgb or d.color,black={15,17,20},glass={26,36,44},metal={125,130,136},white={231,241,250},red={240,25,38},accent=accentRGB,darkBody={17,34,54},amber={245,161,34},display={40,135,164}}
 local ids={}
 local function add(id,kind,pos,size,tone,group,rot,second,basis)
  assert(not ids[id],"Duplicate car part: "..id);ids[id]=true
  local q={id=id,kind=kind,pos=pos,size=size,color=colors[tone or "body"],tone=tone or "body",group=group or "body",rot=rot or {0,0,0},second=second,basis=basis}
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
  -- Warping is represented by orientation, never by a thick bounding box.
  -- Including quad warp in thickness produced the visible saw-tooth canopy edges.
  return add(id,kind or "PlasticBlock",centre,V(sx+.004,.05,sz+.004),tone,"body",nil,nil,basis)
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
 for i,z in ipairs({front,0,rear})do box("crossmember"..i,0,1.35,z,math.min(w*1.74,(w-1.2)*2),.4,.5,"metal",nil,nil,nil,"MetalBlock")end
 for _,s in ipairs({-1,1})do
  box("rail"..s,s*w*.73,1.25,0,.45,.65,l*.82,"metal",nil,nil,nil,"MetalBlock")
  box("sill"..s,s*w*.91,.8,0,.45,.5,wb-3.8,"black")
  for k,z in ipairs({-wb*.22,0,wb*.22})do beam("outrigger"..s..":"..k,V(s*w*.73,1.1,z),V(s*w*.91,.9,z),.28,"metal",.28,"MetalBlock")end
  for k,z in ipairs({front,rear})do box("upperMount"..s..":"..k,s*w*.73,1.95,z,.35,1.4,1.6,"metal",nil,nil,nil,"MetalBlock")end
 end
 for k,z in ipairs({front,0,rear})do for _,s in ipairs({-1,1})do local top=body(z/l+.5,s*.4);beam("skinSupport"..s..":"..k,V(top[1],1.35,z),V(top[1],top[2]-.07,z),.25,"metal",.25,"MetalBlock")end end
 -- Curved double-curvature deck: authored shoulder and centre heights vary separately.
 local long,across=C.bank=="new"and 72 or 64,C.bank=="new"and 12 or 10
 local function skinTone(t,u,tone)
  local x=math.abs(u)
  if style==2 and x>.06 and x<.22 then return "accent"end
  if style==2 and x>=.22 and x<.34 then return "white"end
  if style==3 and t>.62 and x<.72 then return "black"end
  if (d.shape=="senna"or d.shape=="911")and t>.10 and t<.30 and x<.55 then return "black"end
  if d.shape=="jesko"and x<.13 and(t<.32 or t>.72)then return "black"end
  if d.shape=="jesko"and x>.13 and x<.34 and(t<.32 or t>.72)then return "accent"end
  if d.shape=="chiron"and t>.64 then return "darkBody"end
  return tone
 end
 for i=1,long do for j=1,across do
  local a,b=(i-1)/long,i/long;local u,v=-1+2*(j-1)/across,-1+2*j/across
  local tone=d.shape=="chiron"and a>.64 and "darkBody"or "body"
  panel("skin:deck:"..i..":"..j,body(a,u),body(a,v),body(b,v),body(b,u),skinTone((a+b)*.5,(u+v)*.5,tone))
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
 for i=1,36 do for j=1,12 do
  local ta=start+(finish-start)*(i-1)/36;local tb=start+(finish-start)*i/36;local u,v=-1+2*(j-1)/12,-1+2*j/12
  local centre=(u+v)*.5;local tm=(ta+tb)*.5;local isRoof=tm>roofStart and tm<roofEnd and math.abs(centre)<.61
  local isPillar=math.abs(centre)>.8 and (math.abs(tm-roofStart)<.012 or math.abs(tm-roofEnd)<.012)
  local roofTone=(style==3 or d.shape=="gtr")and "black"or d.roofTone
  local tone=isRoof and roofTone or(isPillar and "body"or "glass")
  if isRoof and style==2 and math.abs(centre)>.06 and math.abs(centre)<.22 then tone="accent"end
  if tone~="glass"then panel("canopy:"..i..":"..j,canopyPoint(ta,u),canopyPoint(ta,v),canopyPoint(tb,v),canopyPoint(tb,u),tone,"PlasticBlock")end
 end end
 -- Coherent panes replace hundreds of overlapping transparent rectangular tiles.
 for _,range in ipairs({{start,roofStart,"front"},{roofEnd,finish,"rear"}})do
  for j=1,4 do local u,v=-.78+1.56*(j-1)/4,-.78+1.56*j/4
   local q=panel("glass:"..range[3]..":"..j,canopyPoint(range[1],u),canopyPoint(range[1],v),canopyPoint(range[2],v),canopyPoint(range[2],u),"glass","GlassBlock");q.transparency=.5;q.noCollide=true
  end
 end
 for _,side in ipairs({-1,1})do for j=1,3 do
  local ta=roofStart+(roofEnd-roofStart)*(j-1)/3;local tb=roofStart+(roofEnd-roofStart)*j/3
  local q=panel("glass:side:"..side..":"..j,canopyPoint(ta,side*.64),canopyPoint(ta,side*.98),canopyPoint(tb,side*.98),canopyPoint(tb,side*.64),"glass","GlassBlock");q.transparency=.5;q.noCollide=true
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
 -- Fine trim follows exact surface coordinates; painting is per part, not whole-car tint.
 for _,s in ipairs({-1,1})do
  local shut,skirt={},{ }
  for j=0,18 do local t=.34+j*.29/18;local edge=body(t,s);shut[#shut+1]=V(edge[1]+s*.035,edge[2]-.35,edge[3]);skirt[#skirt+1]=V(edge[1]*.98,1.04,edge[3])end
  curve("doorShut"..s,shut,.1,"black");curve("accentSill"..s,skirt,.12,"accent",.13)
  for j=1,7 do local t=.785+j*.012;topCurve("engineLouvre"..j,s,{{t,.18},{t,.48}},.1,"black",.13)end
  local tip=body(.018,s*.75);beam("splitterAccent"..s,V(s*w*.15,.69,tip[3]-.23),V(tip[1],.69,tip[3]-.23),.11,"accent")
  box("seatInsert"..s,s*1.05,2.65,.94,.72,1.3,.13,"accent",-12)
 end
 ring("steeringRim",V(-1.03,2.75,l*(start-.5)+1.05),.39,.39,"front","black",.11,20)
 for _,s in ipairs({-1,1})do beam("steeringSpoke"..s,V(-1.03,2.75,l*(start-.5)+1.05),V(-1.03+s*.34,2.85,l*(start-.5)+1.05),.11,"metal")end
 box("instruments",-1.03,2.86,l*(start-.5)+.82,1.05,.38,.12,"display")
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
  local id=s..":"..axle;local carrier=s*(w-.45)
  add("carrier"..id,"MetalBlock",V(carrier,1.5,z),V(.65,1.45,1.65),"metal","carrier")
  local wheel=add("wheel"..id,axle==1 and "FrontWheel"or "BackWheel",V(s*(w-.1),wheelY,z),nil,"black","wheel",V(0,s==1 and 180 or 0,0));wheel.previewSize={1.0,3.16,3.16};wheel.skipPaint=true
  links[#links+1]={"spring"..id,"Spring",V(s*w*.73,2.55,z),V(carrier,1.6,z),"spring"}
  for _,yy in ipairs({1.05,2.0})do for _,offset in ipairs({-.55,.55})do links[#links+1]={"arm"..id..":"..yy..":"..offset,"Bar",V(s*w*.73,yy,z+offset),V(carrier,yy,z+offset),"link"}end end
 end end
 for _,q in ipairs(links)do add(q[1],q[2],q[3],nil,"metal",q[5],nil,q[4])end
 return p
end






-- BEGIN NEW GARAGE BANK
-- Two independent shape banks. Legacy geometry is preserved; New loads validated data only.
local oldPlan=C.plan
C.bank="legacy";C.bankSelections={legacy=1,new=1};C.newCache={};C.newLoadNonce=0
C.newCatalog={{id="mclaren-720s",name="720S · Papaya ? New",inspired="McLaren 720S",parts=3396,author="_shobh19",legacyBase=1},{id="mclaren-p1",name="P1 · Volcano ? New",inspired="McLaren P1",parts=7926,author="vecarz",legacyBase=2},{id="mclaren-senna",name="Senna · Track ? New",inspired="McLaren Senna",parts=12427,author="Black Snow",legacyBase=3},{id="ferrari-488",name="488 GTB · Rosso ? New",inspired="Ferrari 488 GTB",parts=5862,author="Dev365TH",legacyBase=4},{id="ferrari-sf90-xx",name="SF90 · Stradale ? New",inspired="Ferrari SF90 Stradale",parts=9089,author="Ddiaz Design",legacyBase=5},{id="huracan-evo-rebuilt",name="Huracán EVO · Verde ? New",inspired="Lamborghini Huracán EVO",parts=7912,author="Galaxy Car Showroom",legacyBase=6},{id="porsche-gt3-rs",name="911 GT3 RS · Weissach ? New",inspired="Porsche 911 GT3 RS (992)",parts=9990,author="Black Snow",legacyBase=7},{id="bugatti-chiron",name="Chiron · Atlantic ? New",inspired="Bugatti Chiron",parts=10499,author="DisneyCars",legacyBase=8},{id="koenigsegg-jesko",name="Jesko Attack · Pearl ? New",inspired="Koenigsegg Jesko Attack",parts=4996,author="Ddiaz Design",legacyBase=9},{id="nissan-custom-gtr",name="GT-R R35 · Gunmetal ? New",inspired="Nissan GT-R R35 (2017)",parts=9616,author="Socksthecat",legacyBase=10},{id="abrams-m1a2",name="Abrams · цельная броня / New",inspired="Abrams M1A2 SEPv3",parts=2518,author="6ixl / NEBULA",tank=true},{id="su57",name="Су-57 · New",inspired="Су-57 · оригинальная блоковая интерпретация",parts=4141,author="6ixl / NEBULA",aircraft=true}}
function C.currentCatalog()return C.bank=="new"and C.newCatalog or C.catalog end
function C.importNew(value,id)
 assert(type(value)=="table"and value.format=="nebula-vehicle-1"and value.id==id,"Неверный формат новой модели")
 assert(type(value.parts)=="table"and #value.parts>0 and #value.parts<=30000,"Неверное количество деталей")
 local allowed={Wedge=true,PlasticBlock=true,MetalBlock=true,GlassBlock=true,FrontWheel=true,BackWheel=true,Spring=true,Bar=true,CarSeat=true,Motor=true,Servo=true,Hinge=true,Cannon=true,PilotSeat=true,JetTurbine=true,Glue=true,SticksOfTNT=true,Delay=true}
 local groups={tankWheelSkin=true,body=true,carrier=true,wheel=true,seat=true,spring=true,link=true,track=true,drive=true,turret=true,gun=true,hatch=true,turretMount=true,gunMount=true,hatchMount=true,airframe=true,pilot=true,jet=true,flightMount=true,flightSurface=true,canopy=true,gear=true,landingWheel=true,airWheelSkin=true,bomb=true,bombMount=true};local ids,bill={},{}
 local function vector(t,count,lo,hi)
  assert(type(t)=="table"and #t==count,"Неверный вектор модели")
  for _,v in ipairs(t)do assert(finite(v)and v>=lo and v<=hi,"Координата/размер вне предела")end
 end
 for _,q in ipairs(value.parts)do
  assert(type(q.id)=="string"and #q.id<=100 and not ids[q.id]and allowed[q.kind]and groups[q.group],"Неверная деталь модели");ids[q.id]=true
  vector(q.pos,3,-100,100);vector(q.color,3,0,255);vector(q.rot,3,-360,360)
  if q.size then vector(q.size,3,.099999,100)end
  if q.second then vector(q.second,3,-100,100)end
  if q.basis then
   vector(q.basis,9,-1.001,1.001)
   for row=0,2 do local length=0;for col=1,3 do length=length+q.basis[row*3+col]^2 end;assert(math.abs(length-1)<.005,"Матрица не нормализована")end
   local m=q.basis
   assert(math.abs(m[1]*m[4]+m[2]*m[5]+m[3]*m[6])<.005 and math.abs(m[1]*m[7]+m[2]*m[8]+m[3]*m[9])<.005 and math.abs(m[4]*m[7]+m[5]*m[8]+m[6]*m[9])<.005,"Оси матрицы не перпендикулярны")
   local det=m[1]*(m[5]*m[9]-m[6]*m[8])-m[2]*(m[4]*m[9]-m[6]*m[7])+m[3]*(m[4]*m[8]-m[5]*m[7]);assert(math.abs(det-1)<.01,"Матрица отражена/вырождена")
  end
  assert((q.kind~="Spring"and q.kind~="Bar")or q.second,"Нет второй точки механизма")
  bill[q.kind]=(bill[q.kind]or 0)+1
 end
 assert(ids.spine and ids.driver,"Нет каркаса или водительского сиденья")
 if value.aircraft then assert(C.Fighter,"Модуль самолёта отсутствует");C.Fighter.validate(value)
 elseif value.tank then assert(C.Tank,"Модуль танка отсутствует");C.Tank.validate(value)else
  for _,q in ipairs(value.parts)do assert(q.kind~="Motor"and q.kind~="Servo"and q.kind~="Hinge"and q.kind~="Cannon"and q.kind~="PilotSeat"and q.kind~="JetTurbine"and q.kind~="Glue"and q.kind~="SticksOfTNT"and q.kind~="Delay","Механизм другой техники в автомобильной схеме")end
 end
 value.bill=bill;value.bank="new";value.disableSkinCollision=true
 C.newCache={[id]=value};return value
end
function C.plan(which,paint,livery,accent)
 if C.bank~="new"then return oldPlan(which,paint,livery,accent)end
 local entry=assert(C.newCatalog[which or C.selected],"Нет новой модели")
 if entry.legacyBase then
  local p=oldPlan(entry.legacyBase,paint,livery,accent);p.id=entry.id;p.bank="new";p.name=entry.name;p.revision=4
  p.inspired=C.catalog[entry.legacyBase].inspired;p.credit={author="6ixl / NEBULA",license="Original profile geometry"};p.qualityMode="refined-legacy-profiles"
  return p
 end
 local raw=assert(C.newCache[entry.id],"Сначала загрузи выбранную New-модель")
 local p={};for key,value in pairs(raw)do if key~="parts"then p[key]=value end end;p.parts={};p.livery=C.liveries[livery or C.livery]or "Исходная окраска"
 for i,q in ipairs(raw.parts)do
  local copy={};for key,value in pairs(q)do copy[key]=value end
  if q.tone=="body"then
   local body=(C.paints[paint or C.paint]or C.paints[1]).rgb
   if body then copy.color=body end
   if (livery or C.livery)==2 and math.abs(q.pos[1])<raw.width*.14 then copy.color=(C.accentPaints[accent or C.accent]or C.accentPaints[1]).rgb or {220,190,60}end
   if (livery or C.livery)==3 and q.pos[2]>raw.height*.65 then copy.color={20,23,29}end
  end
  p.parts[i]=copy
 end
 return p
end
function C.useBank(bank)
 assert(bank=="legacy"or bank=="new","Нет такой вкладки");assert(not N.job,"Останови текущую сборку")
 C.cancelNewLoad();C.bankSelections[C.bank]=C.selected;C.bank=bank;C.selected=C.bankSelections[bank]or 1;C.clearPreview();destroy(C.stage);C.stage=nil
 if C.updateBankUI then C.updateBankUI()end
 if C.refreshView then C.refreshView(false)end
 if bank=="new"then C.loadSelectedNew()elseif C.refreshView then C.refreshView(true)end
end
function C.cancelNewLoad()
 C.newLoadNonce=C.newLoadNonce+1;C.loading=false
 local pending=C.newTask;C.newTask=nil;if pending and task.cancel then pcall(task.cancel,pending)end
end
function C.loadSelectedNew()
 assert(C.bank=="new"and not N.job,"Выбери New и останови сборку")
 local entry=assert(C.newCatalog[C.selected],"Нет модели")
 if entry.legacyBase then C.cancelNewLoad();if C.refreshView then C.refreshView(true)end;return end
 if C.newCache[entry.id]then if C.refreshView then C.refreshView(true)end;return end
 C.cancelNewLoad();local nonce=C.newLoadNonce;C.loading=true
 A.status("Загрузка New: "..entry.name..". Это данные геометрии, не сторонний Lua.")
 C.newTask=task.spawn(function()
  local ok,result=pcall(function()
   local path="nebula/assets/new/"..entry.id..".json";local text
   if type(readfile)=="function"and type(isfile)=="function"and isfile(path)then text=readfile(path)
   else text=game:HttpGet("https://raw.githubusercontent.com/6ixl/nebula-visuals/v6.11-preview.2/assets/new/"..entry.id..".json")end
   assert(type(text)=="string"and #text<=16777216,"Файл модели больше 16 МиБ")
   assert(A.alive and C.bank=="new"and nonce==C.newLoadNonce,"Загрузка отменена")
   return game:GetService("HttpService"):JSONDecode(text)
  end)
  if not A.alive or C.bank~="new"or nonce~=C.newLoadNonce then return end
  C.loading=false;C.newTask=nil
  if ok then ok,result=pcall(C.importNew,result,entry.id)end
  if not ok then A.status("New: загрузка не завершена: "..tostring(result):sub(1,110));return end
  if C.refreshView then local drawn,err=pcall(C.refreshView,true);if not drawn then A.status("Данные загружены; превью недоступно: "..tostring(err):sub(1,90))end end
 end)
end

-- END NEW GARAGE BANK
-- BEGIN NEBULA GARAGE DETAIL
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
 if p.aircraft then C.Fighter.prepare(p);D.materials(p);return p end
 if p.tank then
  local seats={}
  for _,q in ipairs(p.parts)do
   if q.group=="track"and not q.id:match(":shoe$")then q.transparency=1 end
   if q.id:match("^skinSupport:")then q.transparency=1 end
   if q.kind=="Cannon"or q.group=="drive"then q.transparency=1 end
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
 if C.last.plan.aircraft then return C.Fighter.sit()end
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

-- Sequential native PropertiesTool operations. Never replaces server properties locally.
do
local X={};C.Properties=X;C.wheelSpeed=20;C.wheelTorque=10000000
local speedCycle={40,30,20,10,5,4,3,2,1,.5,50}
local torqueCycle={1000000,10000000,100000000,1000000000,10000000000}
local function alpha(model)
 local modifier=model:FindFirstChild("TransparencyModifier")
 if modifier and finite(modifier.Value)then return modifier.Value end
 local value=1
 for _,p in ipairs(model:GetDescendants())do if p:IsA("BasePart")then value=math.min(value,p.Transparency)end end
 return value
end
X.transparency=alpha
local function read(model,property)
 if property=="Transparency"then return alpha(model)
 elseif property=="Collision"then local p=model:FindFirstChild("PPart");return p and p.CanCollide
 elseif property=="Wheel speed"then local value=model:FindFirstChild("MaxSpeed");return value and value.Value
 elseif property=="Jet speed"then local value=model:FindFirstChild("MaxSpeed");return value and value.Value
 elseif property=="Jet force"then local value=model:FindFirstChild("MaxForce");return value and value.Value
 elseif property=="Delay time"then local value=model:FindFirstChild("WaitDuration");return value and value.Value
 elseif property=="Servo angle"then local value=model:FindFirstChild("TargetAngle");return value and value.Value
 elseif property=="Wheel torque"then local h=model:FindFirstChildWhichIsA("HingeConstraint",true);return h and h.MotorMaxTorque end
end
function X.queue(run)
 local queue={};local collisions,hidden,glass,wheels={},{},{},{}
 for _,entry in ipairs(run.models)do local q=entry.spec
  if q.noCollide then collisions[#collisions+1]=entry.model end
  if q.transparency==1 then hidden[#hidden+1]=entry.model elseif q.transparency==.5 then glass[#glass+1]=entry.model end
  if q.group=="wheel"then wheels[#wheels+1]=entry.model end
 end
 local function batches(models,property,goal)
  for first=1,#models,24 do local batch={};for i=first,math.min(#models,first+23)do batch[#batch+1]=models[i]end;queue[#queue+1]={models=batch,property=property,goal=goal,cycles=0}end
 end
 batches(collisions,"Collision",false);batches(hidden,"Transparency",1);batches(glass,"Transparency",.5)
 batches(wheels,"Wheel speed",run.wheelSpeed);batches(wheels,"Wheel torque",run.wheelTorque)
 for _,entry in ipairs(run.models)do local q=entry.spec
  if q.jetSpeed then batches({entry.model},"Jet speed",q.jetSpeed)end
  if q.jetForce then batches({entry.model},"Jet force",q.jetForce)end
  if q.servoAngle then batches({entry.model},"Servo angle",q.servoAngle)end
  if q.delaySeconds then batches({entry.model},"Delay time",q.delaySeconds)end
 end
 return queue
end
function X.step(run)
 if not run.propertyQueue then run.propertyQueue=X.queue(run);run.propertyIndex=1 end
 local item=run.propertyQueue[run.propertyIndex]
 if not item then run.phase="bind";run.phaseTime=0;return end
 local function advance()run.propertyIndex=run.propertyIndex+1;run.phase="properties";run.phaseTime=0 end
 if run.phase=="propertiesVerify"then
  for model,expected in pairs(item.expected)do
   local value=read(model,item.property)
   if type(expected)=="boolean"then if value~=expected then return end
   elseif not finite(value)or math.abs(value-expected)>.011 then return end
  end
  item.expected=nil;run.phase="properties";run.phaseTime=0;return
 end
 local batch={};item.expected={}
 for _,model in ipairs(item.models)do
  local current=read(model,item.property)
  assert(current~=nil,"Нет свойства "..item.property.." у "..model.Name)
  if current~=item.goal then
   batch[#batch+1]=model
   local expected=item.goal
   if item.property=="Transparency"then expected=current>=.99 and 0 or math.min(1,current+.25)
   elseif item.property=="Wheel speed"or item.property=="Wheel torque"or item.property=="Jet speed"or item.property=="Jet force"or item.property=="Servo angle"then
    local cycle=item.property=="Wheel speed"and speedCycle or item.property=="Wheel torque"and torqueCycle or item.property=="Jet speed"and {100,50,25,10,5}or item.property=="Jet force"and {100000,1000000,10000000,100000000,1000000000}or {45,20,5,90,75,60};local position
    for i,value in ipairs(cycle)do if math.abs(value-current)<.01 then position=i;break end end
    assert(position,"Неизвестная настройка колеса: "..tostring(current));expected=cycle[position%#cycle+1]
   end
   item.expected[model]=expected
  end
 end
 if #batch==0 then advance();return end
 item.cycles=item.cycles+1;assert(item.cycles<=12,"Свойство не достигло заданного значения: "..item.property)
 local args={item.property,batch}
 if item.property=="Collision"then args[3]=false elseif item.property=="Transparency"then args[3]=.25 elseif item.property=="Delay time"then args[3]=item.goal end
 H.invoke(run,run.tools.props,run.tools.propsRF,args,"propertiesVerify")
end
function X.audit(record)
 for _,entry in ipairs(record.models)do local q=entry.spec
  if q.noCollide then assert(read(entry.model,"Collision")==false,"Коллизия не отключена: "..q.id)end
  if q.transparency then local value=read(entry.model,"Transparency");assert(finite(value)and math.abs(value-q.transparency)<.011,"Не подтверждена прозрачность: "..q.id)end
  for name,property in pairs({jetSpeed="Jet speed",jetForce="Jet force",servoAngle="Servo angle",delaySeconds="Delay time"})do
   if q[name]then local current=read(entry.model,property);assert(finite(current)and math.abs(current-q[name])<.01,"Не подтверждено свойство "..property..": "..q.id)end
  end
  if q.group=="wheel"then
   assert(read(entry.model,"Wheel speed")==record.wheelSpeed and read(entry.model,"Wheel torque")==record.wheelTorque,"Не подтверждены скорость/момент колеса")
   local collider=entry.model:FindFirstChild("InvisPart",true)or entry.model:FindFirstChild("WheelCollider",true)
   assert(collider and collider.CanCollide,"У игрового колеса нет физической коллизии")
  end
 end
end
end

do
local B={};C.Build=B
local names={place="Размещение",identify="Ожидание блока",scale="Размер и угол",verifyScale="Подтверждение размера",paint="Окраска",verifyPaint="Подтверждение цвета",advance="Следующая деталь",properties="Скрытие механизмов и настройки",propertiesVerify="Подтверждение свойств",bind="Подключение управления",tankBind="Подключение танка",tankBindVerify="Подтверждение управления",tuneStiffness="Жёсткость пружин",tuneDamping="Демпфирование",tuneLength="Длина подвески",finish="Завершение"}
function B.duration(seconds)
 if not finite(seconds)then return "уточняется"end
 seconds=math.max(0,math.ceil(seconds))
 if seconds>=3600 then return string.format("%d ч %02d мин",math.floor(seconds/3600),math.floor(seconds/60)%60)
 elseif seconds>=60 then return string.format("%d мин %02d с",math.floor(seconds/60),seconds%60)end
 return seconds.." с"
end
function B.start(run)
 run.buildClock=0;run.buildRateClock=0;run.buildRateIndex=1;run.secondsPerPart=C.lastPartSeconds or(1.1+2/(run.speed or 1));run.progressClock=0
 C.progress={state="Сборка",done=0,total=#run.plan.parts,ratio=0,elapsed=0,eta=#run.plan.parts*run.secondsPerPart,phase="Подготовка",speed=run.speed,name=run.plan.name}
 if C.focusBuildUI then C.focusBuildUI()end
 if C.refreshBuildUI then C.refreshBuildUI()end
end
function B.tick(dt,run)
 if not run.paused then run.buildClock=(run.buildClock or 0)+dt end
 run.progressClock=(run.progressClock or 0)+dt;if run.progressClock<.1 then return end;run.progressClock=0
 local done=math.min(#run.plan.parts,math.max(0,run.index-1))
 if run.index>(run.buildRateIndex or 1)then
  local count=run.index-run.buildRateIndex;local seconds=(run.buildClock-run.buildRateClock)/count
  run.secondsPerPart=run.buildRateIndex==1 and seconds or(run.secondsPerPart*.75+seconds*.25)
  run.buildRateClock=run.buildClock;run.buildRateIndex=run.index;C.lastPartSeconds=run.secondsPerPart
 end
 local total=#run.plan.parts;local properties=run.propertyQueue and math.max(0,#run.propertyQueue-(run.propertyIndex or 1)+1)or 0
 local remote=run.remoteCalls and run.remoteCalls>0 and run.remoteSeconds/run.remoteCalls or .15
 local eta=(total-done)*run.secondsPerPart+properties*remote*2
 local fraction=({place=0,identify=.2,scale=.35,verifyScale=.5,paint=.65,verifyPaint=.85,advance=.95})[run.phase]or 0
 local ratio=math.min(.95,(done+fraction)/math.max(1,total)*.95)
 if done==total then ratio=.95+(run.propertyQueue and((run.propertyIndex or 1)-1)/math.max(1,#run.propertyQueue)*.035 or 0)end
 C.progress={state=run.paused and "Пауза"or "Сборка",done=done,total=total,ratio=math.min(.99,ratio),elapsed=run.buildClock,eta=eta,phase=names[run.phase]or "Настройка механики",speed=run.speed,name=run.plan.name}
 if C.refreshBuildUI then C.refreshBuildUI()end
end
function B.stopped(run,message)
 if not run or run.kind~="car"or not C.progress then return end
 C.progress.state=run.buildComplete and "Собрано · закреплено"or "Остановлено"
 C.progress.phase=run.buildComplete and "Проверь соединения перед снятием закрепления"or tostring(message or "Сборка остановлена")
 if run.buildComplete then C.progress.done=C.progress.total;C.progress.ratio=1;C.progress.eta=0 end
 if C.refreshBuildUI then C.refreshBuildUI()end
end
function B.pause()
 local run=N.job;assert(run and run.kind=="car","Нет текущей сборки")
 run.paused=not run.paused
 A.status(run.paused and "Сборка на паузе. Уже отправленный запрос может завершиться."or "Сборка продолжена")
 B.tick(.1,run)
end
function C.materialReport(plan)
 local lines={};local data=me:FindFirstChild("Data")
 for kind,objects in pairs(plan.bill)do
  local need=(plan.required or plan.bill)[kind];local value=data and data:FindFirstChild(kind);local have=value and value.Value or 0
  lines[#lines+1]={kind=kind,objects=objects,need=need,have=have,missing=math.max(0,need-have)}
 end
 table.sort(lines,function(a,b)return a.kind<b.kind end);return lines
end
end

-- END NEBULA GARAGE DETAIL
function C.cf(v,base,second)
 local pos=second and v.second or v.pos;local r=v.rot
 if not second and v.basis then return base*CFrame.new(pos[1],pos[2],pos[3],table.unpack(v.basis))end
 return base*CFrame.new(pos[1],pos[2],pos[3])*CFrame.Angles(math.rad(r[1]),math.rad(r[2]),math.rad(r[3]))
end
function C.clearPreview()destroy(C.preview);C.preview=nil end
function C.poseClose(actual,target)
 local a,b={actual:GetComponents()},{target:GetComponents()}
 for i=1,12 do if not finite(a[i])or math.abs(a[i]-b[i])>(i<=3 and .005 or .001)then return false end end
 return true
end
function C.acceptScaleReply(run,q,size,pose)
 if size==nil or size==true then return end -- Some tool versions replicate the result directly.
 assert(typeof(size)=="Vector3"and typeof(pose)=="CFrame","ScalingTool вернул неподдерживаемые данные")
 local wanted=Vector3.new(table.unpack(q.size))
 assert((size-wanted).Magnitude<=.005,"Рулетка округлила размер панели")
 assert(C.poseClose(pose,C.cf(q,run.base)),"Рулетка изменила точное положение/угол")
 assert(run.part and run.part.Parent,"Деталь исчезла")
 -- The game's own ScalingTool applies this server-authorized pair on the client.
 run.part.Size=size;run.part.CFrame=pose;run.scaleReplyAccepted=true
end
function C.setAnchor()
 assert(not N.job,"Останови текущую задачу");local r=rootOf(me);assert(r,"Персонаж не готов")
 local _,yaw=r.CFrame:ToOrientation();C.anchor=CFrame.new(r.Position+Vector3.new(0,1,0))*CFrame.Angles(0,yaw,0)*CFrame.new(0,0,-20)
 A.status("Центр машины указан впереди. Проверь, что весь кузов помещается на участке.")
end
function C.previewInto(parent,base)
 local plan=C.plan();local model=new("Model",{Name="NEBULA_CarPreview"},parent)
 local previewParts=plan.parts
 if plan.bank=="new"and #previewParts>4000 then
  previewParts={};for _,q in ipairs(plan.parts)do previewParts[#previewParts+1]=q end
  table.sort(previewParts,function(a,b)local sa=a.size and a.size[2]*a.size[3]or math.huge;local sb=b.size and b.size[2]*b.size[3]or math.huge;return sa>sb end)
  while #previewParts>4000 do table.remove(previewParts)end
 end
 for _,q in ipairs(previewParts)do
  local cf=C.cf(q,base);local size=q.size and Vector3.new(table.unpack(q.size))or(q.previewSize and Vector3.new(table.unpack(q.previewSize))or(q.group=="wheel"and Vector3.new(1,3,3)or Vector3.new(1,0.5,1)))
  if q.second then local endpoint=C.cf(q,base,true).Position;local start=cf.Position;size=Vector3.new(q.kind=="Spring"and 0.25 or 0.12,q.kind=="Spring"and 0.25 or 0.12,(endpoint-start).Magnitude);cf=CFrame.lookAt((start+endpoint)*0.5,endpoint)end
  local nativeDrawn=C.Tank and C.Tank.previewNative(q,cf,model)
  if not nativeDrawn then
   local part=new(q.kind=="Wedge"and "WedgePart"or "Part",{Name=q.id,Size=size,CFrame=cf,Color=Color3.fromRGB(table.unpack(q.color)),Material=Enum.Material.SmoothPlastic,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,CastShadow=false},model)
   if q.transparency then part.Transparency=q.transparency elseif q.kind=="GlassBlock"then part.Transparency=.5 end
   if q.group=="wheel"then part.Shape=Enum.PartType.Cylinder end
  end
 end
 return model
end
function C.previewWorld()
 assert(not N.job,"Останови текущую задачу");if not C.anchor then C.setAnchor()end;C.clearPreview();C.preview=C.previewInto(owned,C.anchor)
 A.status("Локальное превью; это не серверная машина. Сборка — отдельной кнопкой.")
end
function C.check()
 N.requireGame("boat");local plan=C.plan();if plan.aircraft then C.Fighter.checkTemplates(plan)end;local tools=H.buildTools()
 local bind=H.tool("BindTool");local props=H.tool("PropertiesTool")
 tools.bind=bind;tools.bindRF=bind and bind:FindFirstChild("RF");tools.props=props;tools.propsRF=props and props:FindFirstChild("SetPropertieRF")
 assert(tools.bindRF and tools.bindRF:IsA("RemoteFunction"),"Нужна отвёртка BindTool.RF")
 assert(tools.propsRF and tools.propsRF:IsA("RemoteFunction"),"Нужен PropertiesTool.SetPropertieRF")
 local data=me:FindFirstChild("Data");local missing={}
 for kind,count in pairs(plan.required or plan.bill)do local value=data and data:FindFirstChild(kind);if not value or type(value.Value)~="number"or value.Value<count then missing[#missing+1]=kind..": нужно "..count..", есть "..tostring(value and value.Value or 0)end end
 table.sort(missing);assert(#missing==0,"Не хватает блоков: "..table.concat(missing,"; "))
 local zone=H.findZone();assert(zone,"Зона команды не найдена")
 local blocks=workspace:FindFirstChild("Blocks");local folder=blocks and blocks:FindFirstChild(me.Name);assert(folder,"Собственная папка Blocks не загружена")
 return plan,tools,zone,folder,data
end


-- BEGIN NEBULA NATIVE TANK
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

-- END NEBULA NATIVE TANK
-- BEGIN NEBULA NATIVE FIGHTER
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
 assert(plan.aircraft==true and not plan.tank and plan.id=="su57"and plan.revision==1,"Неподдерживаемая схема самолёта")
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

-- END NEBULA NATIVE FIGHTER
function C.validatePlot(plan,base,zone)
 local function check(q,second)
  local localCF=zone.CFrame:ToObjectSpace(C.cf(q,base,second))
  local v={localCF:GetComponents()};local size=second and {2,1,2}or q.size or q.previewSize or(q.group=="seat"and {3,5,3}or {2,2,2})
  local halfX=(math.abs(v[4])*size[1]+math.abs(v[5])*size[2]+math.abs(v[6])*size[3])*.5
  local halfZ=(math.abs(v[10])*size[1]+math.abs(v[11])*size[2]+math.abs(v[12])*size[3])*.5
  assert(math.abs(v[1])+halfX<=zone.Size.X*.5-1 and math.abs(v[3])+halfZ<=zone.Size.Z*.5-1,"Машина выходит за границы своего участка. Укажи точку внутри строительной зоны, затем проверь превью.")
 end
 for _,q in ipairs(plan.parts)do check(q,false);if q.second then check(q,true)end end
end
function C.start()
 assert(not N.job,"Сначала останови текущую задачу");local plan,tools,zone,folder,data=C.check();if not C.anchor then C.setAnchor()end
 C.validatePlot(plan,C.anchor,zone)
 local run=N.prepare("car");run.plan=plan;run.tools=tools;run.zone=zone;run.folder=folder;run.data=data;run.base=C.anchor;run.speed=H.photoSpeed;run.interval=0.5/run.speed
 run.seen={};for _,m in ipairs(folder:GetChildren())do run.seen[m]=true end
 local preset=C.suspensions[C.suspension];run.tune={stiffness=preset.stiffness,damping=preset.damping}
 for _,q in ipairs(plan.parts)do if q.group=="spring"then local sum=0;for j=1,3 do sum=sum+(q.pos[j]-q.second[j])^2 end;run.tune.freeLength=math.sqrt(sum);break end end
 run.models={};run.phase="place";run.phaseTime=0;run.sendClock=0;C.last=nil;C.clearPreview();run.wheelSpeed=C.wheelSpeed;run.wheelTorque=C.wheelTorque;C.Build.start(run)
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
 assert(record and record.plan and record.models,"Нет завершённой сборки");C.Properties.audit(record)
 if record and record.plan and record.plan.aircraft then return C.Fighter.audit(record)end
 if record and record.plan and record.plan.tank then return C.Tank.audit(record)end
 assert(record and record.models and #record.models==#record.plan.parts,"Нет завершённой сборки")
 local allowed,parents,labels,carriers={},{},{},{};local wheels,springs,links=0,0,0;local seat;local spine
 local function root(v)if not parents[v]then parents[v]=v end;if parents[v]~=v then parents[v]=root(parents[v])end;return parents[v]end
 local function union(a,b)if a and b and allowed[a]and allowed[b]then parents[root(a)]=root(b)end end
 for _,entry in ipairs(record.models)do
  assert(entry.model.Parent==record.folder,"Деталь удалена или перемещена")
  for _,part in ipairs(entry.model:GetDescendants())do if part:IsA("BasePart")then allowed[part]=entry.spec.group end end
  if entry.spec.group=="seat"then seat=entry.model end
  if entry.spec.id=="spine"then spine=entry.model:FindFirstChild("PPart")end
  if entry.spec.group=="carrier"then carriers[entry.spec.id:sub(8)]=entry.model:FindFirstChild("PPart")end
 end
 assert(seat and seat:FindFirstChildWhichIsA("VehicleSeat",true),"Водительское сиденье не подтверждено")
 for _,entry in ipairs(record.models)do for _,joint in ipairs(entry.model:GetDescendants())do
  if joint:IsA("Weld")or joint:IsA("WeldConstraint")or joint:IsA("ManualWeld")or joint:IsA("Snap")then union(joint.Part0,joint.Part1)end
 end end
 for part,group in pairs(allowed)do local key=root(part);labels[key]=labels[key]or {};labels[key][group]=true end
 assert(spine,"Не найден силовой каркас")
 for part,group in pairs(allowed)do if group=="body"or group=="seat"then assert(root(part)==root(spine),"Неприсоединённая деталь кузова/сиденья: "..part.Parent.Name)end end
 for _,groups in pairs(labels)do assert(not(groups.body and groups.carrier),"Колесо жёстко сварено с кузовом: подвеска заблокирована")end
 for _,entry in ipairs(record.models)do
  local group=entry.spec.group
  if group=="wheel"then
   local carrier=carriers[entry.spec.id:sub(6)];assert(carrier,"Нет носителя нужного колеса")
   local bound=false
   for _,beam in ipairs(seat:GetChildren())do if beam:IsA("Beam")and beam.Attachment1 and beam.Attachment1.Parent and beam.Attachment1.Parent:IsDescendantOf(entry.model)then bound=true end end
   assert(bound,"Связь сиденья и колеса не подтверждена: "..entry.spec.id)
   local mounted=false;local hinged=false
   for _,part in ipairs(entry.model:GetDescendants())do
    if part:IsA("BasePart")and root(part)==root(carrier)then mounted=true end
    if part:IsA("HingeConstraint")and part.Enabled~=false and part.ActuatorType==Enum.ActuatorType.Motor and finite(part.MotorMaxTorque)and part.MotorMaxTorque>0 and part.Attachment0 and part.Attachment1 and allowed[part.Attachment0.Parent]and allowed[part.Attachment1.Parent]and root(part.Attachment0.Parent)~=root(part.Attachment1.Parent)then hinged=true end
   end
   assert(mounted and hinged,"Крепление/шарнир колеса не подтверждены: "..entry.spec.id);wheels=wheels+1
  elseif group=="spring"or group=="link"then
   local key=entry.spec.id:match("^spring(.+)$")or entry.spec.id:match("^arm([^:]+:[^:]+):")
   local carrier=carriers[key];assert(carrier,"Нет носителя нужного угла подвески")
   local valid=false
   for _,constraint in ipairs(entry.model:GetDescendants())do if constraint:IsA("Constraint")and constraint.Enabled~=false and constraint.Attachment0 and constraint.Attachment1 then
    local a,b=constraint.Attachment0.Parent,constraint.Attachment1.Parent
    if a and b and a~=b and allowed[a]and allowed[b]and root(a)~=root(b)then
     local left,right=labels[root(a)],labels[root(b)]
     if (left.body and root(b)==root(carrier))or(root(a)==root(carrier)and right.body)then
      if group=="spring"and constraint:IsA("SpringConstraint")then
       assert(record.tune and type(constraint.Stiffness)=="number"and type(constraint.Damping)=="number"and type(constraint.FreeLength)=="number"and math.abs(constraint.Stiffness-record.tune.stiffness)<0.01 and math.abs(constraint.Damping-record.tune.damping)<0.01 and math.abs(constraint.FreeLength-record.tune.freeLength)<0.01,"Настройки/длина пружины не подтверждены")
       valid=true
      elseif group=="link"and constraint:IsA("RodConstraint")then valid=true end
     end
    end
   end end
   assert(valid,"Концы подвески не подтверждены: "..entry.spec.id)
   if group=="spring"then springs=springs+1 else links=links+1 end
  end
 end
 local rotors={}
 for _,entry in ipairs(record.models)do if entry.spec.group=="wheel"then local hinge=entry.model:FindFirstChildWhichIsA("HingeConstraint",true);assert(hinge and hinge.Attachment1,"Нет ротора колеса");rotors[entry.spec.id]=root(hinge.Attachment1.Parent)end end
 for _,entry in ipairs(record.models)do if entry.spec.group=="wheelSkin"then
  local rotor=rotors[entry.spec.wheelId];assert(rotor,"Нет своего игрового колеса")
  for _,part in ipairs(entry.model:GetDescendants())do if part:IsA("BasePart")then assert(root(part)==rotor,"Колёсный декор не соединён с ротором: "..entry.spec.id)end end
 end end
 assert(wheels==4 and springs==4 and links==16,"Неполная ходовая часть")
 return record.plan.name..": 4 связи колёс, 4 пружины и 16 рычагов. Езда не проверена."
end
function C.step(dt,run)
 C.Build.tick(dt,run);if run.paused then return end
 run.phaseTime=run.phaseTime+dt;run.sendClock=run.sendClock+dt
 if run.phaseTime>8 then N.stop("Гараж: нет подтверждения 8 секунд. Уже построенные детали сохранены.");return end
 if run.awaiting then return end
 assert(run.zone.Parent and run.folder.Parent,"Участок выгружен")
 if run.sendClock<(run.interval or 0.5)then return end;run.sendClock=0
 local q=run.plan.parts[run.index]
 if not q then
  if run.plan.aircraft and(run.phase=="bind"or run.phase=="flightBind"or run.phase=="flightBindVerify")then C.Fighter.step(run);return end
  if run.phase=="properties"or run.phase=="propertiesVerify"then C.Properties.step(run);return end
  if run.plan.tank and(run.phase=="bind"or run.phase=="tankBind"or run.phase=="tankBindVerify")then C.Tank.step(run);return end
  if run.phase=="skinCollision"then
   run.skinCursor=run.skinCursor or 1;local batch={}
   while run.skinCursor<=#run.models and #batch<32 do local entry=run.models[run.skinCursor];if entry.spec.noCollide then batch[#batch+1]=entry.model end;run.skinCursor=run.skinCursor+1 end
   if #batch==0 then run.phase="bind";run.phaseTime=0;return end
   run.skinBatch=batch;H.invoke(run,run.tools.props,run.tools.propsRF,{"Collision",batch,false},"verifySkinCollision");return
  elseif run.phase=="verifySkinCollision"then
   for _,m in ipairs(run.skinBatch)do local pp=m:FindFirstChild("PPart");if not pp or pp.CanCollide~=false then return end end
   run.phase="skinCollision";run.phaseTime=0;return
  elseif run.phase=="bind"then
   C.last={plan=run.plan,models=run.models,folder=run.folder,tune=run.tune,base=run.base,wheelSpeed=run.wheelSpeed,wheelTorque=run.wheelTorque}
   local groups=C.bindingGroups(run.models);local seat
   for _,entry in ipairs(run.models)do if entry.spec.group=="seat"then seat=entry.model end end
   assert(seat,"Сиденье не найдено")
   -- Live BABFT BindLocalScript uses a controller array, even for one seat.
   H.invoke(run,run.tools.bind,run.tools.bindRF,{groups,{seat},{},false,false},"tuneStiffness");return
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
   run.phase=stiffness and "tuneDamping"or "tuneLength";run.phaseTime=0;return
  elseif run.phase=="tuneLength"then
   local measuredSpring
   for _,entry in ipairs(run.models)do if entry.spec.group=="spring"then measuredSpring=entry.model:FindFirstChildWhichIsA("SpringConstraint",true);break end end
   assert(measuredSpring and measuredSpring.Attachment0 and measuredSpring.Attachment1,"Нет концов пружины")
   run.tune.freeLength=(measuredSpring.Attachment0.WorldPosition-measuredSpring.Attachment1.WorldPosition).Magnitude
   assert(finite(run.tune.freeLength)and run.tune.freeLength>.05,"Неверная длина подвески")
   local measuredSpring
   for _,entry in ipairs(run.models)do if entry.spec.group=="spring"then measuredSpring=entry.model:FindFirstChildWhichIsA("SpringConstraint",true);break end end
   assert(measuredSpring and measuredSpring.Attachment0 and measuredSpring.Attachment1,"Нет концов пружины")
   run.tune.freeLength=(measuredSpring.Attachment0.WorldPosition-measuredSpring.Attachment1.WorldPosition).Magnitude
   assert(finite(run.tune.freeLength)and run.tune.freeLength>.05,"Неверная длина подвески")
   local measuredSpring
   for _,entry in ipairs(run.models)do if entry.spec.group=="spring"then measuredSpring=entry.model:FindFirstChildWhichIsA("SpringConstraint",true);break end end
   assert(measuredSpring and measuredSpring.Attachment0 and measuredSpring.Attachment1,"Нет концов пружины")
   run.tune.freeLength=(measuredSpring.Attachment0.WorldPosition-measuredSpring.Attachment1.WorldPosition).Magnitude
   assert(finite(run.tune.freeLength)and run.tune.freeLength>.05,"Неверная длина подвески")
   local measuredSpring
   for _,entry in ipairs(run.models)do if entry.spec.group=="spring"then measuredSpring=entry.model:FindFirstChildWhichIsA("SpringConstraint",true);break end end
   assert(measuredSpring and measuredSpring.Attachment0 and measuredSpring.Attachment1,"Нет концов пружины")
   run.tune.freeLength=(measuredSpring.Attachment0.WorldPosition-measuredSpring.Attachment1.WorldPosition).Magnitude
   assert(finite(run.tune.freeLength)and run.tune.freeLength>.05,"Неверная длина подвески")
   local measuredSpring
   for _,entry in ipairs(run.models)do if entry.spec.group=="spring"then measuredSpring=entry.model:FindFirstChildWhichIsA("SpringConstraint",true);break end end
   assert(measuredSpring and measuredSpring.Attachment0 and measuredSpring.Attachment1,"Нет концов пружины")
   run.tune.freeLength=(measuredSpring.Attachment0.WorldPosition-measuredSpring.Attachment1.WorldPosition).Magnitude
   assert(finite(run.tune.freeLength)and run.tune.freeLength>.05,"Неверная длина подвески")
   local springs={};for _,entry in ipairs(run.models)do if entry.spec.group=="spring"then springs[#springs+1]=entry.model end end
   H.invoke(run,run.tools.props,run.tools.propsRF,{"Target lenght",springs,run.tune.freeLength},"verifyLength");return
  elseif run.phase=="verifyLength"then
   for _,entry in ipairs(run.models)do if entry.spec.group=="spring"then local spring=entry.model:FindFirstChildWhichIsA("SpringConstraint",true);if not spring or not finite(spring.FreeLength)or math.abs(spring.FreeLength-run.tune.freeLength)>.01 then return end end end
   run.phase="finish";run.phaseTime=0;return
  elseif run.phase=="finish"then
   run.buildComplete=true
   C.last={plan=run.plan,models=run.models,folder=run.folder,tune=run.tune,base=run.base,wheelSpeed=run.wheelSpeed,wheelTorque=run.wheelTorque};N.stop("Кузов и механика размещены. Машина закреплена; проверь связи и ходовую перед запуском.");return
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
    run.seen[model]=true;run.model=model;run.part=part;run.models[#run.models+1]={model=model,spec=q};run.afterIdentify=q.size and "scale"or(q.skipPaint and "advance"or "paint");run.earlyHideAttempts=0;run.phase=q.transparency==1 and not q.size and "earlyTransparency"or run.afterIdentify;run.phaseTime=0;break
   end
  end end
 elseif run.phase=="earlyTransparency"then
  local opacity=C.Properties.transparency(run.model)
  if opacity>=.99 then run.phase=run.afterIdentify;run.phaseTime=0;return end
  run.earlyHideAttempts=run.earlyHideAttempts+1;assert(run.earlyHideAttempts<=4,"Прозрачность механизма не подтверждена")
  run.alphaExpected=math.min(1,opacity+.25)
  H.invoke(run,run.tools.props,run.tools.propsRF,{"Transparency",{run.model},.25},"verifyEarlyTransparency")
 elseif run.phase=="verifyEarlyTransparency"then
  if C.Properties.transparency(run.model)>=run.alphaExpected-.01 then run.phase="earlyTransparency";run.phaseTime=0 end
 elseif run.phase=="scale"then H.invoke(run,run.tools.scale,run.tools.scaleRF,{run.model,Vector3.new(table.unpack(q.size)),cf},"verifyScale",function(size,pose)C.acceptScaleReply(run,q,size,pose)end)
 elseif run.phase=="verifyScale"then
  assert(run.part.Parent,"Деталь удалена");if (run.part.Size-Vector3.new(table.unpack(q.size))).Magnitude<=.005 and C.poseClose(run.part.CFrame,cf)then run.phase="paint";run.phaseTime=0 end
 elseif run.phase=="paint"then H.invoke(run,run.tools.paint,run.tools.paintRF,{{{run.model,color}}},"verifyPaint")
 elseif run.phase=="advance"then
  run.index=run.index+1;run.phase=run.index>#run.plan.parts and "properties"or "place";run.phaseTime=0
 elseif run.phase=="verifyPaint"then
  assert(run.part.Parent,"Деталь удалена");local c=run.part.Color
  if math.abs(c.R-color.R)+math.abs(c.G-color.G)+math.abs(c.B-color.B)<0.04 then
   run.index=run.index+1;run.phase=run.index>#run.plan.parts and "properties"or "place";run.phaseTime=0
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
function C.startAlign()
 assert(not N.job,"Сначала останови задачу");assert(C.last and C.last.base,"Нет завершённой схемы с точкой")
 local tool=H.tool("TrowelTool");local rf=tool and tool:FindFirstChild("OperationRF");assert(rf and rf:IsA("RemoteFunction"),"Нужен совок TrowelTool.OperationRF")
 local models={};for _,entry in ipairs(C.last.models)do if entry.spec.group=="body"then local pp=entry.model:FindFirstChild("PPart");assert(entry.model.Parent==C.last.folder and pp and pp.Anchored,"Выравнивание возможно только для своих закреплённых панелей");models[#models+1]=entry end end
 local run=N.prepare("carAlign");run.models=models;run.base=C.last.base;run.tool=tool;run.remote=rf;run.phase="align";run.phaseTime=0;run.speed=H.photoSpeed
 A.status("Совок: проверка и точное выравнивание закреплённых панелей, без округления углов")
end
function C.stepAlign(dt,run)
 run.phaseTime=run.phaseTime+dt;if run.phaseTime>8 then N.stop("Совок: точное перемещение не подтверждено за 8 секунд");return end
 if run.awaiting then return end
 local entry=run.models[run.index];if not entry then N.stop("Совок: положение всех панелей подтверждено; сварки проверь отдельно");return end
 local pp=entry.model:FindFirstChild("PPart");assert(pp and pp.Anchored,"Деталь удалена или снята с закрепления")
 local target=C.cf(entry.spec,run.base)
 if C.poseClose(pp.CFrame,target)then run.index=run.index+1;run.phase="align";run.phaseTime=0;return end
 if run.phase=="align"then H.invoke(run,run.tool,run.remote,{{entry.model},pp.CFrame,target,"Move"},"verifyAlign")end
end
function C.startDriveProbe()
 if C.last and C.last.plan.aircraft then A.status(C.Fighter.summary(C.last).." · измерение полёта доступно через HUD при посадке");return end
 if C.last and C.last.plan.tank then return C.Tank.startProbe()end
 assert(not N.job,"Сначала останови задачу");C.audit(C.last)
 local seat,spine
 for _,entry in ipairs(C.last.models)do if entry.spec.group=="seat"then seat=entry.model:FindFirstChildWhichIsA("VehicleSeat",true)end;if entry.spec.id=="spine"then spine=entry.model:FindFirstChild("PPart")end end
 assert(spine and not spine.Anchored,"Сначала сними закрепление после аудита")
 assert(seat and seat.Occupant==humOf(me),"Сядь в водительское сиденье своей машины")
 C.lastDriveReport=nil;C.probe={record=C.last,seat=seat,spine=spine,character=me.Character,origin=spine.Position,yaw=math.atan2(-spine.CFrame.LookVector.X,-spine.CFrame.LookVector.Z),elapsed=0,distance=0,turn=0,spinning={},throttle=false,steer=false}
 A.status("12 секунд: сам проедь вперёд и поверни. Проверка только измеряет, не управляет персонажем.")
end
function C.stepProbe(dt)
 if C.Fighter then C.Fighter.update(dt)end
 if C.probe and C.probe.tank then return C.Tank.stepProbe(dt)end
 local p=C.probe;if not p then return end
 if not A.alive or N.job or p.character~=me.Character or not p.spine.Parent or p.seat.Occupant~=humOf(me)then C.probe=nil;A.status("Проверка езды отменена: изменилось сиденье/персонаж/задача");return end
 p.elapsed=p.elapsed+dt;local delta=p.spine.Position-p.origin
 p.distance=math.max(p.distance,math.sqrt(delta.X*delta.X+delta.Z*delta.Z))
 local yaw=math.atan2(-p.spine.CFrame.LookVector.X,-p.spine.CFrame.LookVector.Z)-p.yaw;p.turn=math.max(p.turn,math.abs(math.atan2(math.sin(yaw),math.cos(yaw))))
 p.throttle=p.throttle or math.abs(p.seat.ThrottleFloat or p.seat.Throttle or 0)>.1;p.steer=p.steer or math.abs(p.seat.SteerFloat or p.seat.Steer or 0)>.1
 for _,entry in ipairs(p.record.models)do if entry.spec.group=="wheel"then for _,part in ipairs(entry.model:GetDescendants())do if part:IsA("BasePart")and part.AssemblyAngularVelocity.Magnitude>1 then p.spinning[entry.spec.id]=true end end end end
 if p.elapsed>=12 then
  local count=0;for _ in pairs(p.spinning)do count=count+1 end
  C.lastDriveReport={seconds=p.elapsed,horizontalStuds=p.distance,yawDegrees=math.deg(p.turn),spinningWheels=count,throttleSeen=p.throttle,steerSeen=p.steer,driveObserved=p.throttle and p.distance>2 and count>=2,steeringObserved=p.steer and p.turn>math.rad(8)}
  local report=C.lastDriveReport;C.probe=nil
  A.status(string.format("Замер: %.1f studs; поворот %.1f°. Движение: %s; поворот: %s. Это наблюдение, не гарантия устойчивости.",report.horizontalStuds,report.yawDegrees,report.driveObserved and "видно"or "не подтверждено",report.steeringObserved and "видно"or "не подтверждено"))
 end
end
function C.cleanup()if C.Fighter then C.Fighter.cleanup()end;C.cancelNewLoad();C.newCache={};C.probe=nil;C.lastDriveReport=nil;C.clearPreview();C.anchor=nil;C.last=nil;destroy(C.stage);C.stage=nil end
end
