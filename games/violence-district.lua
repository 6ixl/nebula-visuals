-- NEBULA standalone Control 1.13. No automatic construction or driving.
do
-- NEBULA CONTROL 1.13 | independent client tools | no remote loaders
-- RightAlt: menu; F6: fly; F7: noclip; F8: ESP. All modules start disabled.
local P=game:GetService("Players")
local R=game:GetService("RunService")
local U=game:GetService("UserInputService")
local T=game:GetService("TweenService")
local L=game:GetService("Lighting")
local me=P.LocalPlayer
assert(me,"NEBULA Control requires a client")
local env=(getgenv and getgenv())or _G
if env.__NEBULA_CONTROL and env.__NEBULA_CONTROL.Unload then pcall(env.__NEBULA_CONTROL.Unload)end
local A={Version="1.13",alive=true,connections={},characterConnections={},playerConnections={},props={},esp={},widgets={},pages={},indexed={},commands={},aliases={},history={},waypoints={},selected=nil}
env.__NEBULA_CONTROL=A
local S={esp=false,names=true,health=true,distance=true,boxes=false,tracers=false,throughWalls=true,teamColors=true,teamFilter=false,visibleOnly=false,selectedOnly=false,
    espRange=1500,espSize=13,espHue=0.76,boxMode=1,espThickness=1,offscreen=false,
    photoBuildSpeed=1,silent=false,invisible=false,underground=false,hideDepth=80,neonBody=false,blackBody=false,glassBody=false,outlineSelf=false,bodyLight=false,bodyTrail=false,hideTag=false,hideAccessories=false,autoRotateOff=false,
    orbit=false,headstand=false,ragdoll=false,bhop=false,ghost=false,rainbowBody=false,respawnPoint=false,
    orbitRadius=5,orbitSpeed=1.2,flingPower=120,flingDuration=0.8,spawnTimeout=60,
    speed=false,speedValue=32,jump=false,jumpValue=70,sprint=false,sprintValue=50,infJump=false,noclip=false,fly=false,hover=false,flySpeed=55,
    follow=false,freeze=false,sit=false,autoWalk=false,spin=false,spinSpeed=1,
    clickTP=false,tpOffset=4,tpTime=1, spectate=false,fov=false,fovValue=85,zoom=false,zoomValue=500,
    fullbright=false,noFog=false,noPost=false,xray=false,xrayAlpha=0.65,stats=false,reduced=false,key=Enum.KeyCode.RightAlt}
A.State=S
local white=Color3.fromRGB(237,237,237)
local function new(class,props,parent)local o=Instance.new(class);for k,v in pairs(props or {})do o[k]=v end;o.Parent=parent;return o end
local function destroy(o)if o then pcall(function()o:Destroy()end)end end
local function on(signal,fn,list)local c=signal:Connect(fn);table.insert(list or A.connections,c);return c end
local function disconnect(list)for _,c in ipairs(list)do c:Disconnect()end;table.clear(list)end
local function vectorUnit(v)local m=v.Magnitude;return m>0.0001 and v*(1/m)or Vector3.new()end
local function finite(n)return type(n)=="number"and n==n and math.abs(n)<10000000 end
local owned
function A.mapAllowed(obj)
    local a=obj
    while a and a~=workspace do
        if a==owned or a.Name=="NEBULA_ControlObjects"or a.Name=="NEBULA_LocalVisuals"or a:IsA("Tool")or a:IsA("Accessory")then return false end
        if a:IsA("Model")and a:FindFirstChildOfClass("Humanoid")then return false end
        a=a.Parent
    end
    return true
end
local function rootOf(pl)local c=pl and pl.Character;return c and c:FindFirstChild("HumanoidRootPart")end
local function humOf(pl)local c=pl and pl.Character;return c and c:FindFirstChildOfClass("Humanoid")end
local function fold(s)
    local out={};for _,c in utf8.codes(tostring(s))do if c>=65 and c<=90 or c>=1040 and c<=1071 then c=c+32 elseif c==1025 then c=1105 end;out[#out+1]=utf8.char(c)end
    return table.concat(out)
end
function A.ownProp(obj,key,value)
    if not obj then return end
    local captured=A.props[obj];if not captured then captured={};A.props[obj]=captured end
    if not captured[key]then captured[key]={before=obj[key]}end
    obj[key]=value;captured[key].last=value
end
function A.release(obj,key)
    local captured=A.props[obj];local item=captured and captured[key]
    if item then pcall(function()if obj[key]==item.last then obj[key]=item.before end end);captured[key]=nil;if next(captured)==nil then A.props[obj]=nil end end
end
function A.restoreAll()local objects={};for obj in pairs(A.props)do objects[#objects+1]=obj end;for _,obj in ipairs(objects)do local keys={};for key in pairs(A.props[obj])do keys[#keys+1]=key end;for _,key in ipairs(keys)do A.release(obj,key)end end end
local gui=new("ScreenGui",{Name="NEBULA_Control",ResetOnSpawn=false,IgnoreGuiInset=true,DisplayOrder=95,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},me:WaitForChild("PlayerGui"))
owned=new("Folder",{Name="NEBULA_ControlObjects"},workspace)
local function round(o,r)new("UICorner",{CornerRadius=UDim.new(0,r or 6)},o)end
local function text(parent,value,pos,size,font,color)
    return new("TextLabel",{Text=value,Position=pos or UDim2.new(),Size=size or UDim2.new(1,0,0,24),Font=font or Enum.Font.Gotham,
        TextSize=12,TextColor3=color or white,BackgroundTransparency=1,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd},parent)
end
local function tween(o,props,duration)local tw=T:Create(o,TweenInfo.new(S.reduced and 0 or duration or 0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),props);tw:Play();return tw end
local function button(parent,value,pos,size)
    local b=new("TextButton",{Text=value,Position=pos or UDim2.new(),Size=size or UDim2.new(1,0,0,34),Font=Enum.Font.GothamMedium,TextSize=12,
        TextColor3=white,BackgroundColor3=Color3.fromRGB(12,12,12),BorderSizePixel=0,AutoButtonColor=false},parent);round(b)
    local stroke=new("UIStroke",{Color=Color3.fromRGB(43,43,43),Transparency=0.3,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},b)
    on(b.MouseEnter,function()tween(stroke,{Transparency=0})end);on(b.MouseLeave,function()tween(stroke,{Transparency=0.3})end)
    return b
end
local panel=new("CanvasGroup",{Name="ControlWindow",AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(930,650),
    BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0,GroupColor3=Color3.new(1,1,1),GroupTransparency=0,BorderSizePixel=0},gui);round(panel,10)
new("UIStroke",{Color=Color3.fromRGB(42,42,42)},panel)
local scale=new("UIScale",{Scale=1},panel)
A.windowWidth=930;A.windowHeight=650
new("Frame",{Position=UDim2.fromOffset(191,0),Size=UDim2.new(0,1,1,0),BackgroundColor3=Color3.fromRGB(30,30,30),BorderSizePixel=0},panel)
local header=new("Frame",{BackgroundTransparency=1,Size=UDim2.new(1,-220,0,54),Active=true},panel)
text(header,"nebula control",UDim2.fromOffset(20,17),UDim2.fromOffset(170,28),Enum.Font.GothamBold).TextSize=20
text(panel,"Клиентские инструменты",UDim2.fromOffset(216,19),UDim2.fromOffset(300,24),nil,Color3.fromRGB(145,145,145))
local hide=button(panel,"—",UDim2.new(1,-82,0,14),UDim2.fromOffset(28,28))
local kill=button(panel,"KILL",UDim2.new(1,-146,0,14),UDim2.fromOffset(55,28))
local close=button(panel,"×",UDim2.new(1,-45,0,14),UDim2.fromOffset(28,28))
local resizeGrip=button(panel,"⋰",UDim2.new(1,-21,1,-21),UDim2.fromOffset(17,17));resizeGrip.Name="ControlResizeGrip";resizeGrip.BackgroundTransparency=1
local nav=new("ScrollingFrame",{Name="ControlNavigation",Position=UDim2.fromOffset(10,91),Size=UDim2.new(0,171,1,-140),BackgroundTransparency=1,BorderSizePixel=0,
    AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(),ScrollBarThickness=2},panel)
new("UIListLayout",{Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder},nav)
local search=new("TextBox",{Name="ControlSearch",Text="",PlaceholderText="Поиск: видеть сквозь стены, полёт, телепорт…",ClearTextOnFocus=false,
    Position=UDim2.fromOffset(215,65),Size=UDim2.new(1,-238,0,34),Font=Enum.Font.Gotham,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,
    BackgroundColor3=Color3.fromRGB(10,10,10),TextColor3=white,PlaceholderColor3=Color3.fromRGB(116,116,116),BorderSizePixel=0},panel);round(search)
new("UIPadding",{PaddingLeft=UDim.new(0,10)},search)
local host=new("Frame",{Position=UDim2.fromOffset(215,114),Size=UDim2.new(1,-238,1,-205),BackgroundTransparency=1,ClipsDescendants=true},panel)
local footer=text(panel,"Готово. Все модули выключены.",UDim2.new(0,215,1,-35),UDim2.new(1,-240,0,21),nil,Color3.fromRGB(146,146,146));footer.TextSize=11
local launcher=button(gui,"NC",UDim2.new(0,16,0.5,30),UDim2.fromOffset(44,38));launcher.Visible=false
local panic=button(gui,"KILL NC",UDim2.new(0,66,0.5,30),UDim2.fromOffset(75,38));panic.Visible=false
local overlay=new("Frame",{Name="ESPOverlay",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Visible=true},gui)
panel.ZIndex=5;launcher.ZIndex=6;panic.ZIndex=6
local stats=text(gui,"",UDim2.fromOffset(20,100),UDim2.fromOffset(300,65),Enum.Font.Code);stats.Visible=false;stats.TextSize=12
local commandBox=new("TextBox",{Name="CommandBar",Text="",PlaceholderText="Команда: esp on / goto имя / help",ClearTextOnFocus=false,
    Position=UDim2.new(0,215,1,-75),Size=UDim2.new(1,-238,0,30),Font=Enum.Font.Code,TextSize=12,TextColor3=white,
    TextXAlignment=Enum.TextXAlignment.Left,BackgroundColor3=Color3.fromRGB(12,12,12),BorderSizePixel=0},panel);round(commandBox)
new("UIPadding",{PaddingLeft=UDim.new(0,10)},commandBox)
-- Silent is a reversible local presentation mode, not executor concealment.
function A.setSilent(value)
    S.silent=value
    if value then
        A.silentGuis=A.silentGuis or {}
        for _,obj in ipairs(gui.Parent:GetChildren())do
            if obj==gui or obj.Name=="NEBULA_Visuals"then
                if A.silentGuis[obj]==nil then A.silentGuis[obj]=obj.Enabled end
                obj.Enabled=false
            end
        end
    else
        for obj,before in pairs(A.silentGuis or {})do pcall(function()obj.Enabled=before end)end
        A.silentGuis={}
    end
    if A.widgets.silent then A.widgets.silent()end
end
function A.clearSelfFX()
    destroy(A.selfLight);A.selfLight=nil;destroy(A.selfFX);A.selfFX=nil;destroy(A.selfTrailA);destroy(A.selfTrailB);A.selfTrailA=nil;A.selfTrailB=nil
end
function A.selfStep(r,h)
    if S.hideTag then A.ownProp(h,"DisplayDistanceType",Enum.HumanoidDisplayDistanceType.None)else A.release(h,"DisplayDistanceType")end
    if not A.selfFX or A.selfRoot~=r then
        A.clearSelfFX();A.selfRoot=r;A.selfFX=new("Folder",{Name="SelfEffects"},owned)
        A.selfOutline=new("Highlight",{Adornee=me.Character,FillTransparency=1,OutlineColor=Color3.fromRGB(167,90,255),DepthMode=Enum.HighlightDepthMode.Occluded,Enabled=false},A.selfFX)
        A.selfLight=new("PointLight",{Color=Color3.fromRGB(167,90,255),Brightness=1.2,Range=14,Enabled=false},r)
        -- Light belongs to root, so explicitly tracked for respawn and KILL.
        A.selfTrailA=new("Attachment",{Position=Vector3.new(-0.8,0.5,0)},r)
        A.selfTrailB=new("Attachment",{Position=Vector3.new(0.8,0.5,0)},r)
        A.selfTrail=new("Trail",{Attachment0=A.selfTrailA,Attachment1=A.selfTrailB,Lifetime=0.65,MinLength=0.05,FaceCamera=true,Color=ColorSequence.new(Color3.fromRGB(167,90,255)),Transparency=NumberSequence.new(0.2,1),Enabled=false},A.selfFX)
    end
    A.selfOutline.Enabled=S.outlineSelf;A.selfLight.Enabled=S.bodyLight;A.selfTrail.Enabled=S.bodyTrail
end
function A.saveReturn()
    local r=rootOf(me);assert(r,"Персонаж не готов");A.returnPoint=r.CFrame;A.status("Позиция возврата сохранена")
end
function A.returnSaved()assert(A.returnPoint,"Сначала сохрани позицию");A.Teleport(A.returnPoint)end
function A.rescue()
    A.stopScenario(true);A.stopFling(true)
    for _,k in ipairs({"fly","hover","headstand","ragdoll","freeze","orbit","spin","autoWalk","follow","autoRotateOff"})do A.Set(k,false)end
    local r,h=rootOf(me),humOf(me);assert(r and h,"Персонаж не готов")
    r.AssemblyLinearVelocity=Vector3.new();r.AssemblyAngularVelocity=Vector3.new()
    A.release(h,"PlatformStand");A.release(h,"AutoRotate");h:ChangeState(Enum.HumanoidStateType.GettingUp)
    local cam=workspace.CurrentCamera;if cam then A.Set("spectate",false);cam.CameraType=Enum.CameraType.Custom;cam.CameraSubject=h end
    A.status("Движение остановлено, камера возвращена к себе")
end
function A.status(s)if A.alive then footer.Text=tostring(s)end end
function A.show(open)
    if S.silent then A.setSilent(false)end
    A.open=open;A.visibility=(A.visibility or 0)+1;local token=A.visibility
    launcher.Visible=not open;panic.Visible=not open
    if open then panel.Visible=true;tween(panel,{GroupTransparency=0},0.17)
    else tween(panel,{GroupTransparency=1},0.12);if S.reduced then panel.Visible=false else task.delay(0.13,function()if A.alive and A.visibility==token then panel.Visible=false end end)end end
end
A.open=true
local function page(name,description)
    local group=new("CanvasGroup",{Name="ControlPageTransition_"..name,Size=UDim2.fromScale(1,1),BackgroundTransparency=1,GroupColor3=Color3.new(1,1,1),GroupTransparency=0,Visible=false},host)
    local p=new("ScrollingFrame",{Name="Page_"..name,Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,
        AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(),Visible=false},group)
    new("UIListLayout",{Padding=UDim.new(0,7),SortOrder=Enum.SortOrder.LayoutOrder},p)
    new("UIPadding",{PaddingRight=UDim.new(0,7),PaddingBottom=UDim.new(0,12)},p)
    local heading=text(p,name,nil,UDim2.new(1,0,0,30),Enum.Font.GothamBold);heading.TextSize=22;heading.LayoutOrder=-1000
    local d=text(p,description,nil,UDim2.new(1,-10,0,38),nil,Color3.fromRGB(135,135,135));d.TextWrapped=true;d.TextSize=11;d.LayoutOrder=-999
    local b=button(nav,"",nil,UDim2.new(1,0,0,34));b.Name="ControlTab_"..name
    local dot=new("Frame",{Name="NavDot",Position=UDim2.fromOffset(13,14),Size=UDim2.fromOffset(5,5),BackgroundColor3=Color3.fromRGB(77,77,77),BorderSizePixel=0},b);round(dot,3)
    local title=text(b,name,UDim2.fromOffset(30,0),UDim2.new(1,-35,1,0))
    A.pages[name]={frame=p,group=group,button=b,dot=dot,title=title}
    on(b.Activated,function()A.switchPage(name)end)
    return p
end
local results=new("ScrollingFrame",{Name="ControlResults",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,
    AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(),Visible=false},host)
new("UIListLayout",{Padding=UDim.new(0,7),SortOrder=Enum.SortOrder.LayoutOrder},results)
function A.clearSearch()
    for _,e in ipairs(A.indexed)do e.control.Parent=e.home end
    results.Visible=false;search.Text=""
end
function A.switchPage(name)
    A.clearSearch();A.page=name
    for key,e in pairs(A.pages)do
        e.group.Visible=key==name;e.frame.Visible=key==name;e.dot.BackgroundColor3=key==name and white or Color3.fromRGB(77,77,77);e.title.TextColor3=key==name and white or Color3.fromRGB(145,145,145);e.button.BackgroundColor3=key==name and Color3.fromRGB(22,22,22)or Color3.new(0,0,0)
        if key==name then e.group.GroupTransparency=S.reduced and 0 or 1;e.frame.Position=UDim2.fromOffset(S.reduced and 0 or 12,0);tween(e.group,{GroupTransparency=0},0.18);tween(e.frame,{Position=UDim2.new()},0.18)end
    end
end
function A.place(p,o)A.layout=A.layout or {};A.layout[p]=(A.layout[p]or 0)+1;o.LayoutOrder=A.layout[p]end
local function index(control,p,title,description,aliases)
    A.indexed[#A.indexed+1]={control=control,home=p,find=fold(title.." "..(description or "").." "..(aliases or ""))}
end
local function row(p,height)
    local f=new("Frame",{Size=UDim2.new(1,0,0,height),BackgroundTransparency=1,BorderSizePixel=0},p)
    A.place(p,f)
    new("Frame",{Position=UDim2.new(0,10,1,-1),Size=UDim2.new(1,-20,0,1),BackgroundColor3=Color3.fromRGB(30,30,30),BorderSizePixel=0},f);return f
end
local function action(p,title,fn,desc,aliases)
    local b=button(p,title);A.place(p,b);on(b.Activated,function()local ok,err=pcall(fn);if not ok then A.status("Ошибка: "..tostring(err):sub(1,150))end end);index(b,p,title,desc,aliases);return b
end
local function toggle(p,key,title,desc,aliases)
    local f=row(p,62);f.Name="Row_"..key
    text(f,title,UDim2.fromOffset(10,8),UDim2.new(1,-90,0,21),Enum.Font.GothamMedium)
    local d=text(f,desc,UDim2.fromOffset(10,30),UDim2.new(1,-85,0,26),nil,Color3.fromRGB(133,133,133));d.TextSize=10;d.TextWrapped=true
    local b=button(f,"",UDim2.new(1,-57,0,19),UDim2.fromOffset(42,22));b.Name="Toggle_"..key;round(b,12)
    local knob=new("Frame",{Position=UDim2.fromOffset(3,3),Size=UDim2.fromOffset(16,16),BackgroundColor3=white,BorderSizePixel=0},b);round(knob,8)
    A.widgets[key]=function()tween(b,{BackgroundColor3=S[key]and white or Color3.fromRGB(43,43,43)});tween(knob,{Position=UDim2.fromOffset(S[key]and 23 or 3,3),BackgroundColor3=S[key]and Color3.new(0,0,0)or Color3.fromRGB(160,160,160)})end
    A.widgets[key]();on(b.Activated,function()local ok,err=pcall(A.Set,key,not S[key]);if not ok then A.status(tostring(err))end end);index(f,p,title,desc,aliases)
end
local ranges={photoBuildSpeed={1,10},hideDepth={20,250},espThickness={1,4},orbitRadius={2,20},orbitSpeed={0.2,4},flingPower={30,240},flingDuration={0.2,2},spawnTimeout={10,300},espRange={50,5000},espSize={10,22},espHue={0,1},speedValue={8,200},jumpValue={10,200},sprintValue={16,200},flySpeed={5,250},spinSpeed={0.1,5},tpOffset={1,30},tpTime={0.1,8},fovValue={40,120},zoomValue={20,1000},xrayAlpha={0.1,0.95}}
local function slider(p,key,title,step)
    local lo,hi=ranges[key][1],ranges[key][2]
    local f=row(p,61);text(f,title,UDim2.fromOffset(10,6),UDim2.new(1,-100,0,22))
    local value=text(f,"",UDim2.new(1,-83,0,6),UDim2.fromOffset(70,22),Enum.Font.Code);value.TextXAlignment=Enum.TextXAlignment.Right
    local hit=button(f,"",UDim2.fromOffset(11,31),UDim2.new(1,-27,0,22));hit.BackgroundTransparency=1
    local rail=new("Frame",{Position=UDim2.new(0,0,0.5,-1),Size=UDim2.new(1,0,0,2),BackgroundColor3=Color3.fromRGB(45,45,45),BorderSizePixel=0},hit)
    local fill=new("Frame",{Size=UDim2.new(),BackgroundColor3=white,BorderSizePixel=0},rail)
    local dot=new("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Size=UDim2.fromOffset(10,10),BackgroundColor3=white,BorderSizePixel=0},rail);round(dot,5)
    A.widgets[key]=function()local t=(S[key]-lo)/(hi-lo);fill.Size=UDim2.fromScale(t,1);dot.Position=UDim2.fromScale(t,0.5);value.Text=string.format(step<1 and "%.2f"or"%.0f",S[key])end
    local function update(x)local t=math.clamp((x-hit.AbsolutePosition.X)/math.max(1,hit.AbsoluteSize.X),0,1);A.Set(key,math.clamp(lo+math.floor(t*(hi-lo)/step+0.5)*step,lo,hi))end
    on(hit.InputBegan,function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then A.dragSlider={input=i,update=update};update(i.Position.X)end end)
    A.widgets[key]();index(f,p,title,"",key)
end
local function input(p,name,placeholder)
    local b=new("TextBox",{Name=name,Text="",PlaceholderText=placeholder,ClearTextOnFocus=false,Font=Enum.Font.Gotham,TextSize=12,TextColor3=white,
        PlaceholderColor3=Color3.fromRGB(120,120,120),TextXAlignment=Enum.TextXAlignment.Left,Size=UDim2.new(1,0,0,34),BackgroundColor3=Color3.fromRGB(12,12,12),BorderSizePixel=0},p)
    round(b);new("UIPadding",{PaddingLeft=UDim.new(0,10)},b);A.place(p,b);return b
end
function A.findPlayer(query)
    query=fold(query or "");local choices={};local players=P:GetPlayers()
    if query=="me"then return me end
    if query=="random"or query=="nearest"then
        for _,pl in ipairs(players)do if pl~=me and rootOf(pl)then choices[#choices+1]=pl end end
        if #choices==0 then return nil,"Других персонажей нет"end
        if query=="random"then return choices[math.random(1,#choices)]end
        local root=rootOf(me);if not root then return nil,"Твой персонаж не готов"end
        table.sort(choices,function(a,b)return (rootOf(a).Position-root.Position).Magnitude<(rootOf(b).Position-root.Position).Magnitude end);return choices[1]
    end
    if query==""then return A.selected,A.selected and nil or "Сначала выбери игрока"end
    for _,pl in ipairs(players)do if fold(pl.Name)==query or tostring(pl.UserId)==query then return pl end end
    for _,pl in ipairs(players)do if fold(pl.Name):find(query,1,true)or fold(pl.DisplayName):find(query,1,true)then choices[#choices+1]=pl end end
    if #choices==1 then return choices[1]end
    return nil,#choices>1 and "Найдено несколько игроков — введи точное имя"or"Игрок не найден"
end
function A.SelectPlayer(pl)
    if pl and pl.Parent~=P then return false,"Игрок уже вышел"end
    A.selected=pl;if A.refreshPlayers then A.refreshPlayers()end
    A.status(pl and "Выбран: "..pl.Name or "Выбор снят");return true
end
function A.target(query)local pl,err=A.findPlayer(query);assert(pl,err);local r=rootOf(pl);assert(r,"Персонаж игрока не готов");return pl,r end
function A.Teleport(cf,smooth)
    if A.Native and A.Native.job then A.Native.stop("Свой модуль отменён другим действием")end
    if A.Games and A.Games.runner then A.Games.stopRoute("Маршрут отменён другим действием")end
    if A.hidden then A.hideStop(true,true)end
    if A.scenario then A.stopScenario(true,"Сценарий остановлен ручным TP")end
    if A.fling then A.stopFling(true)end
    local r=rootOf(me);assert(r,"Твой персонаж не готов")
    if A.tpTween then A.tpTween:Cancel();A.tpTween=nil end
    A.back=r.CFrame;S.follow=false;if A.widgets.follow then A.widgets.follow()end
    r.AssemblyLinearVelocity=Vector3.new();r.AssemblyAngularVelocity=Vector3.new()
    if smooth then A.tpTween=T:Create(r,TweenInfo.new(S.tpTime,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut),{CFrame=cf});A.tpTween:Play()
    else me.Character:PivotTo(cf*r.CFrame:ToObjectSpace(me.Character:GetPivot()))end
    A.status(smooth and "Плавное перемещение начато"or"Перемещение выполнено на клиенте")
end
function A.gotoPlayer(query,mode)
    local pl,r=A.target(query);assert(pl~=me,"Уже выбран твой персонаж")
    local offset=mode=="above"and CFrame.new(0,S.tpOffset,0)or CFrame.new(0,0,S.tpOffset)
    A.Teleport(r.CFrame*offset,mode=="smooth")
end
function A.xyz(value)
    local nums={};for token in tostring(value):gmatch("[^,%s]+")do local n=tonumber(token);assert(finite(n),"Нужны только конечные числа X Y Z");nums[#nums+1]=n end
    assert(#nums==3 and finite(nums[1])and finite(nums[2])and finite(nums[3]),"Нужны три числа: X Y Z")
    A.Teleport(CFrame.new(nums[1],nums[2],nums[3]))
end
function A.savePoint(name)
    local r=rootOf(me);assert(r,"Персонаж не готов");name=tostring(name or ""):sub(1,40);assert(name~="","Введи имя точки")
    A.waypoints[fold(name)]={name=name,cf=r.CFrame};A.status("Точка сохранена: "..name)
end
function A.goPoint(name)local item=A.waypoints[fold(name or "")];assert(item,"Точка не найдена");A.Teleport(item.cf)end
function A.copy(value)
    local fn=setclipboard or toclipboard
    if type(fn)=="function"then fn(tostring(value));A.status("Скопировано в буфер")else A.status(tostring(value))end
end
function A.destroyMotion()
    destroy(A.flyVelocity);destroy(A.flyOrientation);destroy(A.flyAttachment);A.flyVelocity=nil;A.flyOrientation=nil;A.flyAttachment=nil
    destroy(A.spinVelocity);destroy(A.spinAttachment);A.spinVelocity=nil;A.spinAttachment=nil
end
-- Extra modules share the same ownership and cancellation lifecycle.
A.plan={{kind="walk",seconds=3},{kind="die"}}
A.stepNames={walk="Идти вперёд",wait="Подождать",jump="Прыгнуть",point="Вернуться в точку",die="Умереть"}
A.movementKeys={"speed","jump","sprint","infJump","noclip","fly","hover","follow","freeze","sit","autoWalk","spin","headstand","ragdoll","orbit","bhop"}
function A.suspendMovement()
    local saved={};for _,key in ipairs(A.movementKeys)do saved[key]=S[key];S[key]=false end
    A.destroyMotion();if A.clearTrollRig then A.clearTrollRig()end;A.motion(0)
    for key in pairs(saved)do if A.widgets[key]then A.widgets[key]()end end
    return saved
end
function A.resumeMovement(saved)
    for key,value in pairs(saved or {})do S[key]=value;if A.widgets[key]then A.widgets[key]()end end
    if A.alive then A.motion(0)end
end
function A.placeCharacter(cf)
    local r=rootOf(me);assert(r,"Персонаж не готов")
    r.AssemblyLinearVelocity=Vector3.new();r.AssemblyAngularVelocity=Vector3.new()
    me.Character:PivotTo(cf*r.CFrame:ToObjectSpace(me.Character:GetPivot()))
end
function A.hideStop(returnPosition,resume)
    local session=A.hidden;A.hidden=nil;S.underground=false
    if A.widgets.underground then A.widgets.underground()end
    if not session then return end
    local h,r=humOf(me),rootOf(me)
    if me.Character==session.character and r and h and h.Health>0 then
        for _,part in ipairs(me.Character:GetDescendants())do if part:IsA("BasePart")then A.release(part,"CanCollide")end end
        if returnPosition then A.placeCharacter(session.origin)end
        A.release(h,"AutoRotate")
    end
    if resume then A.resumeMovement(session.saved)end
end
function A.hideStart()
    if A.Native and A.Native.job then A.Native.stop("Свой модуль отменён другим действием")end
    if A.Games and A.Games.runner then A.Games.stopRoute("Маршрут отменён другим действием")end
    if A.hidden then return end
    local r,h=rootOf(me),humOf(me);assert(r and h and h.Health>0,"Персонаж не готов")
    local floor=workspace.FallenPartsDestroyHeight
    assert(type(floor)=="number"and floor==floor,"Не удалось определить границу уничтожения карты")
    local depth=S.hideDepth;local y=math.max(r.Position.Y-depth,floor+35)
    assert(y<=r.Position.Y-20,"Недостаточно места над границей уничтожения: режим не включён")
    local origin=r.CFrame;local destination=CFrame.new(0,y-r.Position.Y,0)*origin
    A.stopScenario(true);A.stopFling(true)
    if A.tpTween then A.tpTween:Cancel();A.tpTween=nil end
    local saved=A.suspendMovement()
    A.hidden={origin=origin,point=destination,character=me.Character,saved=saved};S.underground=true
    A.hideStep();A.status("Персонаж перемещён вниз. Серверное принятие TP и видимость другим не проверены.")
end
function A.hideStep()
    local session=A.hidden;if not session then return end
    local r,h=rootOf(me),humOf(me)
    if me.Character~=session.character or not r or not h or h.Health<=0 then A.hideStop(false,false);return end
    local floor=workspace.FallenPartsDestroyHeight
    if type(floor)~="number"or session.point.Position.Y<=floor+15 then A.hideStop(true,true);A.status("Граница карты изменилась: выполнен возврат");return end
    for _,part in ipairs(me.Character:GetDescendants())do if part:IsA("BasePart")then A.ownProp(part,"CanCollide",false)end end
    h:Move(Vector3.new(),false);A.ownProp(h,"AutoRotate",false);A.placeCharacter(session.point)
end
function A.clearTrollRig()
    destroy(A.trollOrientation);destroy(A.trollAttachment);A.trollOrientation=nil;A.trollAttachment=nil
end
function A.stopFling(restore)
    local f=A.fling;if not f then return end;A.fling=nil
    destroy(f.angular);destroy(f.attachment)
    pcall(function()
        f.root.CanCollide=f.collide;f.hum.AutoRotate=f.rotate;f.hum.PlatformStand=f.platform;f.hum.Sit=f.sit
        f.root.AssemblyLinearVelocity=Vector3.new();f.root.AssemblyAngularVelocity=Vector3.new()
        if me.Character==f.character and f.root.Parent and f.hum.Health>0 then A.placeCharacter(f.returnCF)end
    end)
    if restore then A.resumeMovement(f.saved)end
    A.status("Fling остановлен; свой персонаж восстановлен")
end
function A.startFling(query)
    if A.Native and A.Native.job then A.Native.stop("Свой модуль отменён другим действием")end
    if A.Games and A.Games.runner then A.Games.stopRoute("Маршрут отменён другим действием")end
    if A.hidden then A.hideStop(true,true)end
    local target,tr=A.target(query);assert(target~=me,"Выбери другого игрока")
    local r,h=rootOf(me),humOf(me);assert(r and h and h.Health>0,"Персонаж не готов")
    if A.scenario then A.stopScenario(true,"Сценарий остановлен перед fling")end
    A.stopFling(true)
    local saved=A.suspendMovement()
    local f={target=target,root=r,hum=h,character=me.Character,returnCF=r.CFrame,elapsed=0,saved=saved,collide=r.CanCollide,rotate=h.AutoRotate,platform=h.PlatformStand,sit=h.Sit}
    A.fling=f
    local ok,err=pcall(function()
        assert(not r.Anchored,"Персонаж закреплён игрой")
        h.AutoRotate=false;h.PlatformStand=true;h.Sit=false;r.CanCollide=true
        f.attachment=new("Attachment",{Name="NEBULA_Fling"},r)
        f.angular=new("AngularVelocity",{Attachment0=f.attachment,RelativeTo=Enum.ActuatorRelativeTo.World,MaxTorque=100000000,AngularVelocity=Vector3.new(0,S.flingPower,0)},r)
    end)
    if not ok then A.stopFling(true);error(err)end
    A.status("Кратковременная попытка fling: "..target.Name)
end
function A.flingStep(dt)
    local f=A.fling;if not f then return end
    f.elapsed=f.elapsed+dt
    local target=rootOf(f.target)
    if f.elapsed>=S.flingDuration or not target or f.target.Parent~=P or me.Character~=f.character or f.hum.Health<=0 then A.stopFling(true);return end
    local a=f.elapsed*22
    f.root.CFrame=CFrame.new(target.Position+Vector3.new(math.cos(a)*1.15,0.35,math.sin(a)*1.15),target.Position)
    f.root.AssemblyLinearVelocity=Vector3.new(math.cos(a)*22,4,math.sin(a)*22)
end
function A.trollStep(dt,r,h)
    A.selfStep(r,h)
    if S.headstand then
        if not A.trollAttachment or A.trollAttachment.Parent~=r then
            A.clearTrollRig();A.trollAttachment=new("Attachment",{Name="NEBULA_Headstand"},r)
            A.trollOrientation=new("AlignOrientation",{Attachment0=A.trollAttachment,Mode=Enum.OrientationAlignmentMode.OneAttachment,MaxTorque=100000000,Responsiveness=15},r)
        end
        A.ownProp(h,"AutoRotate",false);A.ownProp(h,"PlatformStand",true)
        A.trollOrientation.CFrame=CFrame.Angles(0,0,math.pi)
    else
        A.clearTrollRig()
        if S.ragdoll then A.ownProp(h,"PlatformStand",true);A.ownProp(h,"AutoRotate",false)
        else A.release(h,"PlatformStand");if not S.fly and not S.hover and not S.spin then A.release(h,"AutoRotate")end end
    end
    if S.orbit then
        local target=rootOf(A.selected)
        if target then A.orbitClock=(A.orbitClock or 0)+dt*S.orbitSpeed;local a=A.orbitClock
            local pos=target.Position+Vector3.new(math.cos(a)*S.orbitRadius,0,math.sin(a)*S.orbitRadius)
            A.placeCharacter(CFrame.new(pos,target.Position))
        else S.orbit=false;if A.widgets.orbit then A.widgets.orbit()end end
    end
    if S.bhop and h.FloorMaterial~=Enum.Material.Air then h:ChangeState(Enum.HumanoidStateType.Jumping)end
    for _,part in ipairs(me.Character:GetDescendants())do if part:IsA("BasePart")then
        local accessory=part:FindFirstAncestorOfClass("Accessory")
        if S.invisible or (S.hideAccessories and accessory)then A.ownProp(part,"LocalTransparencyModifier",1)
        elseif S.ghost then A.ownProp(part,"LocalTransparencyModifier",0.8)else A.release(part,"LocalTransparencyModifier")end
        if S.neonBody then A.ownProp(part,"Material",Enum.Material.Neon)
        elseif S.glassBody then A.ownProp(part,"Material",Enum.Material.Glass)
        else A.release(part,"Material")end
        if S.blackBody then A.ownProp(part,"Color",Color3.new(0,0,0))elseif S.rainbowBody then A.ownProp(part,"Color",Color3.fromHSV(((A.trollTime or 0)*0.15)%1,0.6,0.85))else A.release(part,"Color")end
    end end
    if S.autoRotateOff then A.ownProp(h,"AutoRotate",false)end
    A.trollTime=(A.trollTime or 0)+dt
end
function A.saveSpawnPoint()
    local r=rootOf(me);assert(r,"Персонаж не готов");A.spawnPoint=r.CFrame;S.respawnPoint=true
    if A.widgets.respawnPoint then A.widgets.respawnPoint()end
    A.status("Точка возрождения записана: "..string.format("%.1f %.1f %.1f",r.Position.X,r.Position.Y,r.Position.Z))
    if A.updateScenarioUI then A.updateScenarioUI()end
end
function A.processSpawnPoint(dt)
    local pending=A.pendingSpawn;if not pending then return end
    pending.elapsed=pending.elapsed+dt
    if not S.respawnPoint or not A.spawnPoint or pending.character~=me.Character or pending.elapsed>S.spawnTimeout then A.pendingSpawn=nil;return end
    local r,h=rootOf(me),humOf(me)
    if r and r.Parent and h and h.Health>0 and me.Character~=A.departing then A.placeCharacter(A.spawnPoint);A.pendingSpawn=nil end
end
function A.stopScenario(restore,message)
    local run=A.scenario;if not run then return end
    A.scenario=nil;A.lastScenario={completed=run.completed,limit=run.limit,message=message or"Сценарий остановлен"}
    local h=humOf(me);if h then h:Move(Vector3.new(),false)end
    if A.scenarioStop then A.scenarioStop.Visible=false end
    if A.scenarioHUD then A.scenarioHUD.Visible=false end
    if restore then A.resumeMovement(run.saved)end
    A.status(message or"Сценарий остановлен")
    if A.updateScenarioUI then A.updateScenarioUI()end
end
function A.parseRepeats(value)
    local v=fold(tostring(value or""))
    if v=="∞"or v=="inf"or v=="infinite"or v=="бесконечно"then return 0 end
    local n=tonumber(v);assert(type(n)=="number"and n==n and n<math.huge and n>=0 and n==math.floor(n),"Повторы: целое число или «бесконечно»")
    return n
end
function A.startScenario(repeats)
    if A.Native and A.Native.job then A.Native.stop("Свой модуль отменён другим действием")end
    if A.Games and A.Games.runner then A.Games.stopRoute("Маршрут отменён другим действием")end
    if A.hidden then A.hideStop(true,true)end
    assert(#A.plan>0,"Добавь шаги сценария")
    assert(A.spawnPoint,"Сначала нажми «Указать точку здесь»")
    local limit=A.parseRepeats(repeats)
    local plan={}
    for _,step in ipairs(A.plan)do
        assert(A.stepNames[step.kind],"Неизвестный шаг")
        local seconds=step.seconds or 0
        if step.kind=="walk"or step.kind=="wait"then assert(finite(seconds)and seconds>=0.05 and seconds<=3600,"Длительность шага: 0.05–3600 секунд")end
        plan[#plan+1]={kind=step.kind,seconds=seconds}
    end
    A.stopScenario(true);A.stopFling(true)
    local saved=A.suspendMovement()
    A.scenario={plan=plan,index=1,completed=0,limit=limit,saved=saved,wait=0,newLoop=true,point=A.spawnPoint}
    if A.tpTween then A.tpTween:Cancel();A.tpTween=nil end
    if A.scenarioStop then A.scenarioStop.Visible=true end
    if A.scenarioHUD then A.scenarioHUD.Visible=true end
    A.status(limit==0 and "Сценарий запущен: бесконечный повтор"or "Сценарий запущен: "..limit.." повторов")
    if A.updateScenarioUI then A.updateScenarioUI()end
end
function A.advanceScenario(run)
    run.index=run.index+1;run.remaining=nil;run.direction=nil
    if run.index>#run.plan then
        run.completed=run.completed+1
        if run.limit>0 and run.completed>=run.limit then A.stopScenario(true,"Сценарий завершён: "..run.completed.." кругов");return end
        run.index=1;run.newLoop=true
    end
end
function A.scenarioStep(dt)
    local run=A.scenario;if not run then return end
    local r,h=rootOf(me),humOf(me)
    local sameLife=run.expectingRespawn and run.character==me.Character and run.generation==(A.spawnSerial or 0)
    if not r or not r.Parent or not h or h.Health<=0 or me.Character==A.departing or sameLife then
        run.wait=run.wait+dt
        if A.scenarioHUD then A.scenarioHUD.Text="Сценарий · ожидание возрождения\nКругов завершено: "..run.completed end
        if run.wait>S.spawnTimeout then A.stopScenario(true,"Сценарий остановлен: игра не возродила персонажа")end
        return
    end
    if run.character~=me.Character or run.generation~=(A.spawnSerial or 0)then
        if run.character and not run.expectingRespawn then run.index=1;run.remaining=nil end
        run.character=me.Character;run.generation=A.spawnSerial or 0;run.wait=0;run.expectingRespawn=false;run.newLoop=true
    end
    if run.newLoop then A.placeCharacter(run.point);run.newLoop=false end
    local step=run.plan[run.index]
    if A.scenarioHUD then A.scenarioHUD.Text="Сценарий · круг "..(run.completed+1).." / "..(run.limit==0 and "∞"or run.limit).."\n"..run.index..". "..A.stepNames[step.kind]..(run.remaining and string.format(" · %.1f сек",run.remaining)or"")end
    if step.kind=="walk"or step.kind=="wait"then
        if run.remaining==nil then run.remaining=step.seconds;local v=r.CFrame.LookVector;run.direction=vectorUnit(Vector3.new(v.X,0,v.Z))end
        if step.kind=="walk"then h:Move(run.direction,false)else h:Move(Vector3.new(),false)end
        run.remaining=run.remaining-dt
        if run.remaining<=0 then h:Move(Vector3.new(),false);A.advanceScenario(run)end
    elseif step.kind=="point"then A.placeCharacter(run.point);A.advanceScenario(run)
    elseif step.kind=="jump"then h:ChangeState(Enum.HumanoidStateType.Jumping);A.advanceScenario(run)
    elseif step.kind=="die"then run.expectingRespawn=true;h.Health=0;A.advanceScenario(run)end
end

function A.motion(dt)
    if A.Native and A.Native.job then local r,h=rootOf(me),humOf(me);if r and h and h.Health>0 then A.trollStep(dt,r,h)end;return end
    if A.Games and A.Games.runner then local r,h=rootOf(me),humOf(me);if r and h and h.Health>0 then A.trollStep(dt,r,h)end;return end
    if A.hidden then A.hideStep();return end
    if A.fling then A.flingStep(dt);return end
    if A.scenario then local r,h=rootOf(me),humOf(me);if r and h and h.Health>0 and me.Character~=A.departing then A.trollStep(dt,r,h)end;return end
    local r,h=rootOf(me),humOf(me);if not r or not h or h.Health<=0 or me.Character==A.departing then return end
    local typing=U:GetFocusedTextBox()~=nil
    local shift=not typing and U:IsKeyDown(Enum.KeyCode.LeftShift)
    if S.speed or S.sprint and shift then A.ownProp(h,"WalkSpeed",S.sprint and shift and S.sprintValue or S.speedValue)else A.release(h,"WalkSpeed")end
    if S.jump then
        if h.UseJumpPower then A.ownProp(h,"JumpPower",S.jumpValue);A.release(h,"JumpHeight")
        else A.ownProp(h,"JumpHeight",S.jumpValue*S.jumpValue/(2*math.max(1,workspace.Gravity)));A.release(h,"JumpPower")end
    else A.release(h,"JumpPower");A.release(h,"JumpHeight")end
    if S.freeze then A.ownProp(r,"Anchored",true)else A.release(r,"Anchored")end
    if S.sit then A.ownProp(h,"Sit",true)else A.release(h,"Sit")end
    if S.noclip then for _,p in ipairs(me.Character:GetDescendants())do if p:IsA("BasePart")then A.ownProp(p,"CanCollide",false)end end
    elseif A.hadNoclip then for obj,props in pairs(A.props)do if props.CanCollide then A.release(obj,"CanCollide")end end end
    A.hadNoclip=S.noclip
    if S.fly or S.hover then
        if not A.flyAttachment or A.flyAttachment.Parent~=r or not A.flyVelocity or not A.flyVelocity.Parent or not A.flyOrientation or not A.flyOrientation.Parent then
            A.destroyMotion();A.flyAttachment=new("Attachment",{Name="NEBULA_ControlFlight"},r)
            A.flyVelocity=new("LinearVelocity",{Attachment0=A.flyAttachment,RelativeTo=Enum.ActuatorRelativeTo.World,ForceLimitsEnabled=false,MaxForce=100000000,VectorVelocity=Vector3.new()},r)
            A.flyOrientation=new("AlignOrientation",{Attachment0=A.flyAttachment,Mode=Enum.OrientationAlignmentMode.OneAttachment,MaxTorque=100000000,Responsiveness=18},r)
        end
        A.ownProp(h,"AutoRotate",false)
        local move=Vector3.new();local cam=workspace.CurrentCamera
        if S.fly and cam and not typing then
            if U:IsKeyDown(Enum.KeyCode.W)then move=move+cam.CFrame.LookVector end;if U:IsKeyDown(Enum.KeyCode.S)then move=move-cam.CFrame.LookVector end
            if U:IsKeyDown(Enum.KeyCode.D)then move=move+cam.CFrame.RightVector end;if U:IsKeyDown(Enum.KeyCode.A)then move=move-cam.CFrame.RightVector end
            if U:IsKeyDown(Enum.KeyCode.Space)then move=move+Vector3.new(0,1,0)end
            if U:IsKeyDown(Enum.KeyCode.LeftControl)then move=move-Vector3.new(0,1,0)end
        end
        A.flyVelocity.VectorVelocity=vectorUnit(move)*S.flySpeed
        if cam then A.flyOrientation.CFrame=CFrame.new(r.Position,r.Position+cam.CFrame.LookVector)end
    else
        if A.flyAttachment then A.destroyMotion();r.AssemblyLinearVelocity=Vector3.new()end
        A.release(h,"AutoRotate")
    end
    if S.spin then
        A.ownProp(h,"AutoRotate",false)
        if not A.spinAttachment or A.spinAttachment.Parent~=r then A.spinAttachment=new("Attachment",{Name="NEBULA_ControlSpin"},r);A.spinVelocity=new("AngularVelocity",{Attachment0=A.spinAttachment,RelativeTo=Enum.ActuatorRelativeTo.World,MaxTorque=100000000},r)end
        A.spinVelocity.AngularVelocity=Vector3.new(0,S.spinSpeed*math.pi*2,0)
    elseif A.spinAttachment then destroy(A.spinVelocity);destroy(A.spinAttachment);A.spinAttachment=nil;A.spinVelocity=nil end
    if S.autoWalk and not typing then h:Move(Vector3.new(0,0,-1),true)elseif A.hadAutoWalk then h:Move(Vector3.new(),true)end
    A.hadAutoWalk=S.autoWalk
    A.trollStep(dt,r,h)
    A.followClock=(A.followClock or 0)+dt
    if S.follow and A.followClock>0.4 then A.followClock=0;local target=rootOf(A.selected);if target then h:MoveTo(target.Position)else A.Set("follow",false);A.status("Цель слежения недоступна")end end
end
function A.worldStep()
    if S.fullbright then
        A.ownProp(L,"Brightness",3);A.ownProp(L,"Ambient",Color3.fromRGB(170,170,170));A.ownProp(L,"OutdoorAmbient",Color3.fromRGB(170,170,170));A.ownProp(L,"GlobalShadows",false)
    else for _,key in ipairs({"Brightness","Ambient","OutdoorAmbient","GlobalShadows"})do A.release(L,key)end end
    if S.noFog then A.ownProp(L,"FogEnd",100000);A.ownProp(L,"FogStart",100000)else A.release(L,"FogEnd");A.release(L,"FogStart")end
    for _,obj in ipairs(L:GetChildren())do
        if obj:IsA("Atmosphere")then if S.noFog then A.ownProp(obj,"Density",0);A.ownProp(obj,"Haze",0)else A.release(obj,"Density");A.release(obj,"Haze")end end
        if obj:IsA("PostEffect")or obj:IsA("BloomEffect")or obj:IsA("BlurEffect")or obj:IsA("ColorCorrectionEffect")or obj:IsA("DepthOfFieldEffect")or obj:IsA("SunRaysEffect")then if S.noPost then A.ownProp(obj,"Enabled",false)else A.release(obj,"Enabled")end end
    end
    if S.xray then
        for n=1,100 do
            local obj=table.remove(A.xrayQueue);if not obj then break end
            if A.mapAllowed(obj)and not A.xraySeen[obj]then
                A.xraySeen[obj]=true
                local char=obj:IsA("Model")and obj:FindFirstChildOfClass("Humanoid")
                if not char and not obj:IsA("Tool")and not obj:IsA("Accessory")then
                    for _,child in ipairs(obj:GetChildren())do A.xrayQueue[#A.xrayQueue+1]=child end
                    if obj:IsA("BasePart")and obj.Anchored then A.ownProp(obj,"LocalTransparencyModifier",S.xrayAlpha)end
                end
            end
        end
    end
end
function A.cameraStep()
    local cam=workspace.CurrentCamera;if not cam then return end
    if A.camera and A.camera~=cam then A.release(A.camera,"FieldOfView");A.release(A.camera,"CameraSubject");A.release(A.camera,"CameraType")end
    A.camera=cam
    if S.fov then A.ownProp(cam,"FieldOfView",S.fovValue)else A.release(cam,"FieldOfView")end
    if S.zoom then A.ownProp(me,"CameraMaxZoomDistance",S.zoomValue)else A.release(me,"CameraMaxZoomDistance")end
    if S.spectate then
        local h=humOf(A.selected)
        if h then A.ownProp(cam,"CameraType",Enum.CameraType.Custom);A.ownProp(cam,"CameraSubject",h);A.wasSpectating=true
        else A.Set("spectate",false);A.status("Цель наблюдения недоступна")end
    else
        A.release(cam,"CameraSubject");A.release(cam,"CameraType")
        if A.wasSpectating then
            local subject=cam.CameraSubject
            if not subject or not subject:IsDescendantOf(workspace)then local h=humOf(me);if h then cam.CameraSubject=h end end
            A.wasSpectating=false
        end
    end
end
-- Game profiles are explicit tools; discovery is name-based, not hidden server data.
local G={profiles={
    {id="boat",name="Build a Boat",place=537413528,universe=210851291,filters={{"Сундуки","chest,treasure"},{"Этапы","stage,checkpoint"},{"Спавны","spawn"}}},
    {id="mm2",name="MM2",place=142823291,universe=66654135,filters={{"Выпавшее оружие","gundrop,droppedgun"},{"Монеты","coin"},{"Лобби / спавны","spawn,lobby"}}},
    {id="vd",name="Violence District",place=93978595733734,universe=6739698191,filters={{"Генераторы","generator"},{"Выходы","exit,escape,gate"},{"Лечение","medkit,healthkit"}}},
    {id="doors",name="DOORS",place=6516141723,filters={{"Ключи","keyobtain,key"},{"Двери","door"},{"Шкафы","wardrobe,closet"}}},
    {id="evade",name="Evade",place=9872472334,filters={{"Боты","nextbot"},{"Лечение","medkit,healthkit"},{"Спавны","spawn"}}},
    {id="arsenal",name="Arsenal",place=286090429,universe=111958650,filters={{"Спавны","spawn"},{"Лечение","healthkit,medkit"},{"Боеприпасы","ammobox,ammo"}}},
    {id="custom",name="Своя игра",filters={{"Спавны","spawn"},{"Выходы","exit"},{"Цели","objective,checkpoint"}}}
},sessions={},selected="custom",markers={},results={},crosshair=false,toolTags=false,routeTimeout=20,routeDelay=1,routeLoops=1,routeMode="walk"}
A.Games=G
for _,profile in ipairs(G.profiles)do G.sessions[profile.id]={points={},route={}}end
function G.profile(id)for _,profile in ipairs(G.profiles)do if profile.id==(id or G.selected)then return profile end end;error("Профиль не найден")end
function G.detect()
    for _,profile in ipairs(G.profiles)do
        if profile.place and (game.PlaceId==profile.place or profile.universe and game.GameId==profile.universe)then return profile.id end
    end
    return "custom"
end
function G.clearMarkers()
    for _,entry in ipairs(G.markers)do destroy(entry.label);destroy(entry.highlight)end
    G.markers={}
end
function G.stopRoute(message,resume)
    local run=G.runner;G.runner=nil
    if not run then return end
    local h=humOf(me);if h then h:Move(Vector3.new(),false);local r=rootOf(me);if r then h:MoveTo(r.Position)end end
    if resume~=false then A.resumeMovement(run.saved)end
    A.status(message or "Маршрут остановлен")
end
function G.cancelScan()G.scan=nil end
function G.select(id)
    G.profile(id);G.stopRoute();G.cancelScan();G.clearMarkers();G.results={};G.selected=id
    if G.refresh then G.refresh()end
end
function G.savePoint(name)
    local r=rootOf(me);assert(r,"Персонаж не готов");name=tostring(name or ""):sub(1,48);assert(name~="","Укажи имя точки")
    G.sessions[G.selected].points[fold(name)]={name=name,cf=r.CFrame}
    A.status("Точка сохранена в профиле "..G.profile().name..": "..name)
end
function G.goPoint(name)
    local point=G.sessions[G.selected].points[fold(name or "")];assert(point,"Точка в этом профиле не найдена")
    A.Teleport(point.cf)
end
function G.recordRoute()
    assert(not G.runner,"Сначала останови маршрут");local r=rootOf(me);assert(r,"Персонаж не готов")
    local route=G.sessions[G.selected].route;assert(#route<200,"Максимум 200 точек")
    route[#route+1]=r.CFrame;if G.refresh then G.refresh()end;A.status("Точка маршрута записана: "..#route)
end
function G.startRoute()
    if A.Native and A.Native.job then A.Native.stop("Свой модуль отменён запуском маршрута")end
    local points=G.sessions[G.selected].route;assert(#points>0,"Сначала запиши точки маршрута")
    local h,r=humOf(me),rootOf(me);assert(h and r and h.Health>0,"Персонаж не готов")
    G.stopRoute();if A.hidden then A.hideStop(true,true)end;A.stopScenario(true);A.stopFling(true)
    local snapshot={};for i,cf in ipairs(points)do snapshot[i]=cf end
    local saved=A.suspendMovement()
    G.runner={points=snapshot,index=1,completed=0,limit=G.routeLoops,mode=G.routeMode,delay=G.routeDelay,timeout=G.routeTimeout,character=me.Character,saved=saved,elapsed=0}
    A.status("Маршрут запущен: "..G.profile().name)
end
function G.routeStep(dt)
    local run=G.runner;if not run then return end
    local r,h=rootOf(me),humOf(me)
    if not r or not h or h.Health<=0 or run.character~=me.Character then G.stopRoute("Маршрут остановлен: персонаж сменился или погиб");return end
    run.elapsed=run.elapsed+dt
    local goal=run.points[run.index]
    if run.mode=="tp"then if not run.placed then A.placeCharacter(goal);run.placed=true end
    elseif not run.issued or run.elapsed-(run.lastMove or 0)>=2 then h:MoveTo(goal.Position);run.issued=true;run.lastMove=run.elapsed end
    local arrived=run.mode=="tp"and run.elapsed>=run.delay and (r.Position-goal.Position).Magnitude<=5 or run.mode=="walk"and (r.Position-goal.Position).Magnitude<=3
    if arrived then
        run.index=run.index+1;run.elapsed=0;run.placed=nil;run.issued=nil;run.lastMove=nil
        if run.index>#run.points then
            run.completed=run.completed+1
            if run.limit>0 and run.completed>=run.limit then G.stopRoute("Маршрут завершён: "..run.completed.." повторов");return end
            run.index=1
        end
    elseif run.elapsed>run.timeout then G.stopRoute("Маршрут остановлен: точка недоступна / сервер отклонил перемещение")end
end
function G.objectPart(obj)
    if obj:IsA("BasePart")then return obj end
    if obj:IsA("Model")or obj:IsA("Tool")then
        if obj:IsA("Model")and obj.PrimaryPart then return obj.PrimaryPart end
        local queue={obj};local index=1
        while index<=#queue and index<=60 do
            local node=queue[index];index=index+1
            for _,child in ipairs(node:GetChildren())do if child:IsA("BasePart")then return child end;if #queue<60 then queue[#queue+1]=child end end
        end
    end
end
function G.scanStart(query)
    G.cancelScan();G.clearMarkers();G.results={}
    local tokens={};for raw in string.gmatch(fold(query or ""),"[^,]+")do local token=raw:match("^%s*(.-)%s*$");if #token>0 then tokens[#tokens+1]=token end end
    assert(#tokens>0,"Укажи названия через запятую")
    G.scan={queue={workspace},index=1,visited=0,tokens=tokens,seen={},limit=12000,maxResults=100}
    A.status("Поиск загруженных объектов по названию…")
end
function G.scanStep()
    local scan=G.scan;if not scan then return end
    for _=1,100 do
        local obj=scan.queue[scan.index]
        if not obj or scan.visited>=scan.limit or #G.results>=scan.maxResults then
            G.scan=nil;if G.refreshResults then G.refreshResults()end
            A.status("Найдено: "..#G.results.."; проверено: "..scan.visited..". Только загруженные объекты, совпадения по имени.");return
        end
        scan.queue[scan.index]=false;scan.index=scan.index+1;scan.visited=scan.visited+1
        local skip=obj==owned or obj.Name=="NEBULA_LocalVisuals"
        for _,pl in ipairs(P:GetPlayers())do if obj==pl.Character then skip=true;break end end
        if not skip and (obj.Parent~=nil or obj==workspace)then
            if not skip then
                local name=fold(obj.Name);local match=false
                for _,token in ipairs(scan.tokens)do if name:find(token,1,true)then match=true;break end end
                if match then local part=G.objectPart(obj)
                    if part and not scan.seen[part]then scan.seen[part]=true;G.results[#G.results+1]={object=obj,part=part,name=obj.Name}end
                end
                for _,child in ipairs(obj:GetChildren())do if #scan.queue<scan.limit then scan.queue[#scan.queue+1]=child end end
            end
        end
    end
end
function G.closest()
    local r=rootOf(me);assert(r,"Персонаж не готов");local best,distance
    for _,entry in ipairs(G.results)do if entry.part.Parent then local d=(entry.part.Position-r.Position).Magnitude;if not distance or d<distance then best=entry;distance=d end end end
    assert(best,"Нет доступных результатов; сначала выполни поиск");return best
end
function G.gotoResult(entry)
    assert(entry and entry.part.Parent,"Объект выгружен или удалён")
    A.Teleport(CFrame.new(entry.part.Position+Vector3.new(0,4,0)))
end
function G.showMarkers()
    G.clearMarkers();assert(#G.results>0,"Сначала выполни поиск")
    for i,entry in ipairs(G.results)do if i<=64 and entry.part.Parent then
        local label=text(overlay,entry.name,nil,UDim2.fromOffset(220,32),Enum.Font.GothamMedium,Color3.fromRGB(189,151,255));label.TextXAlignment=Enum.TextXAlignment.Center
        local highlight=new("Highlight",{Adornee=entry.part,FillTransparency=1,OutlineColor=Color3.fromRGB(189,151,255),Enabled=false},owned)
        G.markers[#G.markers+1]={entry=entry,label=label,highlight=highlight}
    end end
    A.status("Маркеры включены: "..#G.markers)
end
function G.toolInfo(pl)
    local found={};local seen={}
    local containers={};if pl.Character then containers[#containers+1]=pl.Character end;local backpack=pl:FindFirstChild("Backpack");if backpack then containers[#containers+1]=backpack end
    for _,container in ipairs(containers)do if container then
        for _,obj in ipairs(container:GetChildren())do if obj:IsA("Tool")and not seen[obj.Name]then seen[obj.Name]=true;found[#found+1]=obj.Name end end
    end end
    table.sort(found);return table.concat(found,", ")
end
function G.toolSummary()
    local result={}
    for _,pl in ipairs(P:GetPlayers())do local tools=G.toolInfo(pl);if #tools>0 then result[#result+1]=pl.Name..": "..tools end end
    A.status(#result>0 and table.concat(result," | ")or "Доступные инструменты не обнаружены. Скрытые роли не определяются.")
end
function G.render()
    local cam=workspace.CurrentCamera;local r=rootOf(me)
    for _,marker in ipairs(G.markers)do
        local part=marker.entry.part;local enabled=not S.silent and part.Parent~=nil and cam~=nil
        marker.highlight.Enabled=enabled
        marker.label.Visible=false
        if enabled then local point,visible=cam:WorldToViewportPoint(part.Position)
            if visible and point.Z>0 then marker.label.Visible=true;marker.label.Position=UDim2.fromOffset(point.X-110,point.Y-22)
                marker.label.Text=marker.entry.name..(r and string.format(" · %.0fm",(part.Position-r.Position).Magnitude*0.28)or "")
            end
        end
    end
    if G.cross then G.cross.Visible=G.crosshair and not S.silent end
end
function G.cleanup()
    G.stopRoute(nil,false);G.cancelScan();G.clearMarkers();G.results={};G.crosshair=false;G.toolTags=false
    if G.resultConnections then disconnect(G.resultConnections)end
    if G.refreshResults then G.refreshResults()end
    if G.cross then G.cross.Visible=false end
end

-- NEBULA Native: original game-specific modules; no HTTP or external code.
local N={selected="boat",flags={boatMarkers=false,mm2Roles=false,mm2Gun=false,vdGenerators=false,vdGates=false,vdPlayers=false},objects={},markers={},clock=0,delay=1.5,loops=1,timeout=60}
A.Native=N
N.games={boat={name="NEBULA Boat",place=537413528,universe=210851291},mm2={name="NEBULA MM2",place=142823291,universe=66654135},vd={name="NEBULA District",place=93978595733734,universe=6739698191}}
function N.match(id)local g=N.games[id];return g and (game.PlaceId==g.place or game.GameId==g.universe)end
function N.requireGame(id)assert(N.match(id),"Этот модуль предназначен для "..N.games[id].name.."; текущая игра отличается")end
function N.attr(obj,key)if not obj then return nil end;local ok,value=pcall(function()return obj:GetAttribute(key)end);return ok and value or nil end
function N.clearMarkers()for _,m in ipairs(N.markers)do destroy(m.label);destroy(m.highlight)end;N.markers={}end
function N.stop(message,resume)
    local run=N.job;if N.Spray then N.Spray.stop(run)end;if N.Helper then N.Helper.cancel(run)end;N.job=nil
    if run then
        local r,h=rootOf(me),humOf(me);if h then h:Move(Vector3.new(),false)end
        if r then r.AssemblyLinearVelocity=Vector3.new();r.AssemblyAngularVelocity=Vector3.new()end
        if resume~=false then A.resumeMovement(run.saved)end
        A.status(message or "Свой модуль остановлен")
    end
end
function N.prepare(kind)
    N.stop();G.stopRoute();A.stopScenario(true);A.stopFling(true);if A.hidden then A.hideStop(true,true)end
    local r,h=rootOf(me),humOf(me);assert(r and h and h.Health>0,"Персонаж не готов")
    local saved=A.suspendMovement();local run={kind=kind,character=me.Character,saved=saved,elapsed=0,index=1,completed=0,limit=N.loops,delay=N.delay,timeout=N.timeout}
    N.job=run;return run
end
function N.boatTargets()
    local root=workspace:FindFirstChild("BoatStages");local stages=root and root:FindFirstChild("NormalStages");assert(stages,"BoatStages/NormalStages не загружены")
    local list={}
    for _,stage in ipairs(stages:GetChildren())do
        local number=tonumber(stage.Name:match("^CaveStage(%d+)$"));local target=stage:FindFirstChild("DarknessPart",true)
        if number and target and target:IsA("BasePart")then list[#list+1]={order=number,object=target,part=target,name="Этап "..number,category="boat"}end
    end
    table.sort(list,function(a,b)return a.order<b.order end)
    local ending=stages:FindFirstChild("TheEnd");local chest=ending and ending:FindFirstChild("GoldenChest",true);local trigger=chest and chest:FindFirstChild("Trigger",true)
    assert(#list>0 and trigger and trigger:IsA("BasePart"),"Этапы или GoldenChest/Trigger не найдены: структура карты отличается")
    list[#list+1]={object=trigger,part=trigger,name="Сундук · триггер",category="boat"};return list
end
function N.startBoat()
    N.requireGame("boat");local targets=N.boatTargets();local run=N.prepare("boat");run.targets=targets
    A.status("NEBULA Boat: проход найденных этапов. Награда подтверждается только самой игрой.")
end
function N.mm2Map()
    for _,obj in ipairs(workspace:GetChildren())do local coins=obj:FindFirstChild("CoinContainer");if coins then return obj,coins end end
end
function N.gunDrop()
    local map=N.mm2Map();local gun=map and map:FindFirstChild("GunDrop",true);local part=gun and G.objectPart(gun);return gun,part
end
function N.weaponOwner(weapon)
    for _,pl in ipairs(P:GetPlayers())do
        local c=pl.Character;local b=pl:FindFirstChild("Backpack")
        if c and c:FindFirstChild(weapon)or b and b:FindFirstChild(weapon)then return pl end
    end
end
function N.playerIntel(pl)
    local items={};local c=pl.Character;local b=pl:FindFirstChild("Backpack")
    if N.flags.mm2Roles and N.match("mm2")then
        for _,name in ipairs({"Knife","Gun"})do if c and c:FindFirstChild(name)or b and b:FindFirstChild(name)then items[#items+1]=name.." обнаружен"end end
    end
    if N.flags.vdPlayers and N.match("vd")then
        if pl.Team then items[#items+1]="Team: "..pl.Team.Name end
        if N.attr(c,"Knocked")then items[#items+1]="Лежит"end
        if N.attr(c,"IsHooked")then items[#items+1]="На крюке"end
        local equipped=N.attr(pl,"EquippedItem");if equipped then items[#items+1]=tostring(equipped)end
    end
    return table.concat(items," · ")
end
function N.startCoins()
    N.requireGame("mm2");local map,coins=N.mm2Map();assert(map and coins,"Карта с CoinContainer не загружена")
    local run=N.prepare("coins");run.map=map;run.container=coins;run.visited={};run.attempts=0;run.elapsed=run.delay
    A.status("NEBULA MM2: посещение загруженных Coin_Server. Серверный сбор не гарантируется.")
end
function N.goWeapon(name)
    N.requireGame("mm2")
    if name=="drop"then local gun,part=N.gunDrop();assert(gun and part,"Выпавший GunDrop не найден");A.Teleport(CFrame.new(part.Position+Vector3.new(0,3,0)))
    else local pl=N.weaponOwner(name);assert(pl,"Владелец "..name.." не обнаружен на клиенте");A.gotoPlayer(pl.Name)end
end
function N.addMarker(entry)
    if #N.markers>=64 or not entry.part or not entry.part.Parent then return end
    local label=text(overlay,entry.name,nil,UDim2.fromOffset(260,35),Enum.Font.GothamMedium,Color3.fromRGB(180,144,255));label.TextXAlignment=Enum.TextXAlignment.Center
    local highlight=new("Highlight",{Adornee=entry.part,Enabled=false,FillTransparency=0.85,OutlineColor=Color3.fromRGB(180,144,255)},owned)
    N.markers[#N.markers+1]={entry=entry,label=label,highlight=highlight}
end
function N.rebuildMarkers()
    N.clearMarkers()
    for _,entry in ipairs(N.objects)do
        if entry.category=="boat"and N.flags.boatMarkers or entry.category=="generator"and N.flags.vdGenerators or entry.category=="gate"and N.flags.vdGates then N.addMarker(entry)end
    end
    if N.flags.mm2Gun and N.match("mm2")then local gun,part=N.gunDrop();if gun and part then N.addMarker({object=gun,part=part,name="GunDrop",category="gun"})end end
end
function N.scanDistrict()
    N.requireGame("vd");N.scan={queue={workspace:FindFirstChild("Map")or workspace},index=1,count=0,found={},seen={}}
    A.status("NEBULA District: поиск загруженных генераторов и выходов…")
end
function N.scanStep()
    local scan=N.scan;if not scan then return end
    for _=1,100 do
        local obj=scan.queue[scan.index]
        if not obj or scan.count>=12000 then N.scan=nil;N.objects=scan.found;N.rebuildMarkers();A.status("District: найдено объектов "..#N.objects);return end
        scan.queue[scan.index]=false;scan.index=scan.index+1;scan.count=scan.count+1
        local skip=obj==owned or obj.Name=="NEBULA_LocalVisuals"
        for _,pl in ipairs(P:GetPlayers())do if obj==pl.Character then skip=true;break end end
        if not skip then
            if obj:IsA("Model")then
                local progress=N.attr(obj,"RepairProgress");local name=string.lower(obj.Name)
                local category=type(progress)=="number"and "generator"or (name:find("gate",1,true)or name:find("exitlever",1,true))and "gate"or nil
                if category then local part=G.objectPart(obj);if part and not scan.seen[part]and #scan.found<100 then scan.seen[part]=true;scan.found[#scan.found+1]={object=obj,part=part,name=category=="generator"and "Генератор"or obj.Name,category=category}end end
            end
            for _,child in ipairs(obj:GetChildren())do if #scan.queue<12000 then scan.queue[#scan.queue+1]=child end end
        end
    end
end
function N.closestGenerator()
    N.requireGame("vd");local r=rootOf(me);assert(r,"Персонаж не готов");local best,d
    for _,entry in ipairs(N.objects)do if entry.category=="generator"and entry.part:IsDescendantOf(workspace)then
        local progress=N.attr(entry.object,"RepairProgress")
        if type(progress)=="number"and progress<100 then local distance=(entry.part.Position-r.Position).Magnitude;if not d or distance<d then d=distance;best=entry end end
    end end
    assert(best,"Незавершённые генераторы не найдены: обнови список");A.Teleport(CFrame.new(best.part.Position+Vector3.new(0,4,0)))
end
function N.goGate()
    N.requireGame("vd");local r=rootOf(me);assert(r,"Персонаж не готов");local best,d
    for _,entry in ipairs(N.objects)do if entry.category=="gate"and entry.part:IsDescendantOf(workspace)then local distance=(entry.part.Position-r.Position).Magnitude;if not d or distance<d then best=entry;d=distance end end end
    assert(best,"Выход не найден: обнови список");A.Teleport(CFrame.new(best.part.Position+Vector3.new(0,4,0)))
end
function N.setFlag(key,value)
    assert(N.flags[key]~=nil,"Неизвестная функция");local id=key:sub(1,2)=="vd"and "vd"or key:sub(1,3)=="mm2"and "mm2"or "boat"
    if value then N.requireGame(id)end
    local boatTargets=key=="boatMarkers"and value and N.boatTargets()or nil
    N.flags[key]=value
    if boatTargets then N.objects=boatTargets end
    if (key=="vdGenerators"or key=="vdGates")and value then N.scanDistrict()end
    if (key=="mm2Roles"or key=="vdPlayers")and value then A.Set("esp",true);A.Set("names",true);A.Set("health",true)end
    N.rebuildMarkers();if N.refresh then N.refresh()end
end
function N.step(dt)
    if N.Cars then N.Cars.stepProbe(dt)end
    if N.MorePlaces then N.MorePlaces.step(dt)end
    if N.Spray then N.Spray.previewStep()end
    if N.Helper then N.Helper.step(dt)end
    N.scanStep();N.clock=N.clock+dt
    if N.clock>=0.5 then N.clock=0;if N.flags.mm2Gun then N.rebuildMarkers()end;if N.refresh then N.refresh()end end
    local run=N.job;if not run then return end
    run.elapsed=run.elapsed+dt
    local r,h=rootOf(me),humOf(me)
    if run.waiting then
        if run.elapsed>run.timeout then N.stop("Boat: возрождение не получено, цикл остановлен");return end
        if me.Character~=run.character and r and h and h.Health>0 and me.Character~=A.departing then
            local ok,targets=pcall(N.boatTargets);if not ok then N.stop(targets);return end
            run.character=me.Character;run.targets=targets;run.index=1;run.waiting=false;run.elapsed=0
        end
        return
    end
    if not r or not h or h.Health<=0 or run.character~=me.Character then
        if run.kind=="boat"then N.stop("Boat: персонаж погиб до завершения этапов")else N.stop("MM2: сбор остановлен при смерти/возрождении")end;return
    end
    if run.kind=="car"then N.Cars.step(dt,run);return
    elseif run.kind=="carAlign"then N.Cars.stepAlign(dt,run);return
    elseif run.kind=="carRelease"then run.phaseTime=run.phaseTime+dt;if run.phaseTime>8 then N.stop("Гараж: запуск не подтверждён за 8 секунд")end;return
    elseif run.kind=="spray"then N.Spray.step(dt,run);return
    elseif run.kind=="photo"then N.Helper.photoStep(dt,run);return
    elseif run.kind=="district"then N.Helper.districtStep(dt,run);return end
    if run.kind=="boat"then
        if run.elapsed<run.delay then return end
        run.elapsed=0;local target=run.targets[run.index]
        if not target or not target.part:IsDescendantOf(workspace)then N.stop("Boat: этап выгружен; обнови карту");return end
        A.placeCharacter(target.part.CFrame)
        run.index=run.index+1
        if run.index>#run.targets then
            run.completed=run.completed+1
            if run.limit>0 and run.completed>=run.limit then N.stop("Boat: выполнено проходов "..run.completed.."; награда не проверялась")
            else run.waiting=true;run.elapsed=0;A.status("Boat: ожидание возрождения перед следующим проходом")end
        end
    elseif run.kind=="coins"then
        if not run.map.Parent or not run.container.Parent then N.stop("MM2: карта раунда выгружена");return end
        if run.elapsed<run.delay then return end;run.elapsed=0
        local best,d
        for _,coin in ipairs(run.container:GetChildren())do if coin.Name=="Coin_Server"and not run.visited[coin]then local part=G.objectPart(coin);if part then local distance=(part.Position-r.Position).Magnitude;if not d or distance<d then best={coin=coin,part=part};d=distance end end end end
        if not best then N.stop("MM2: все доступные точки посещены; серверный сбор не подтверждался");return end
        run.visited[best.coin]=true;run.attempts=run.attempts+1;A.placeCharacter(CFrame.new(best.part.Position+Vector3.new(0,1,0)))
        if run.attempts>=200 then N.stop("MM2: лимит 200 посещений, остановлено")end
    end
end
function N.render()
    local cam=workspace.CurrentCamera
    for _,m in ipairs(N.markers)do
        local e=m.entry;local enabled=not S.silent and e.part:IsDescendantOf(workspace)and cam~=nil
        m.highlight.Enabled=enabled;m.label.Visible=false
        if enabled then local point,visible=cam:WorldToViewportPoint(e.part.Position);if visible and point.Z>0 then
            local caption=e.name
            if e.category=="generator"then local progress=N.attr(e.object,"RepairProgress");local workers=N.attr(e.object,"PlayersRepairingCount");caption=caption..string.format(" · %.1f%% · %d ремонтируют",type(progress)=="number"and progress or 0,type(workers)=="number"and workers or 0)end
            m.label.Text=caption;m.label.Visible=true;m.label.Position=UDim2.fromOffset(point.X-130,point.Y-25)
        end end
    end
end
function N.cleanup()
    if N.MorePlaces then N.MorePlaces.cleanup()end
    if N.Aim then N.Aim.cleanup()end
    N.stop(nil,false)
    if N.Spray then N.Spray.cleanup()end
    if N.Helper then N.Helper.cleanup()end
    if N.Cars then N.Cars.cleanup()end
    N.scan=nil;N.clearMarkers();N.objects={};for k in pairs(N.flags)do N.flags[k]=false end
    if N.refresh then N.refresh()end
end

-- Original helpers and validated photo-plan pipeline. No remote code loaders.
local H={photoSpeed=1,maxPhotoSide=200,maxPhotoPixels=40000,maxPhotoBytes=4194304,flags={autoGun=false,knifeHelper=false,repairHelper=false,skillHelper=false},clock=0,photo=nil,anchor=nil,preview=nil}
N.Helper=H
function H.tool(name)
    local c=me.Character;local b=me:FindFirstChild("Backpack");return c and c:FindFirstChild(name)or b and b:FindFirstChild(name)
end
function H.remotePath(...)
    local obj=game:GetService("ReplicatedStorage")
    for _,name in ipairs({...})do obj=obj and obj:FindFirstChild(name)end
    return obj
end
function H.repairRemotes()
    local repair=H.remotePath("Remotes","Generator","RepairEvent")
    local skill=H.remotePath("Remotes","Generator","SkillCheckResultEvent")
    assert(repair and repair:IsA("RemoteEvent"),"Remotes/Generator/RepairEvent не найден")
    assert(skill and skill:IsA("RemoteEvent"),"Remotes/Generator/SkillCheckResultEvent не найден")
    return repair,skill
end
function H.setFlag(key,value)
    assert(H.flags[key]~=nil,"Неизвестный хелпер")
    if value then
        if key=="autoGun"or key=="knifeHelper"then N.requireGame("mm2")else N.requireGame("vd");H.repairRemotes()end
        if key=="knifeHelper"then local knife=H.tool("Knife");local remote=knife and knife:FindFirstChild("Stab");assert(remote and remote:IsA("RemoteEvent"),"Нужен свой Knife со Stab RemoteEvent")end
    end
    H.flags[key]=value
    if key=="repairHelper"and not value and H.repairTarget then local repair=H.remotePath("Remotes","Generator","RepairEvent");if repair then pcall(function()repair:FireServer(H.repairTarget,false)end)end;H.repairTarget=nil end
    if H.refresh then H.refresh()end
end
function H.nearestGenerator()
    local r=rootOf(me);if not r then return end;local best,d
    for _,e in ipairs(N.objects)do if e.category=="generator"and e.part:IsDescendantOf(workspace)then local progress=N.attr(e.object,"RepairProgress")
        if type(progress)=="number"and progress<100 then local distance=(r.Position-e.part.Position).Magnitude;if not d or distance<d then best=e;d=distance end end
    end end
    return best,d
end
function H.repairOnce(entry,skillEnabled)
    local r=rootOf(me);if not entry or not r or (r.Position-entry.part.Position).Magnitude>12 then return false end
    local repair,skill=H.repairRemotes();repair:FireServer(entry.object,true);H.repairTarget=entry.object
    if skillEnabled then skill:FireServer("success",1,entry.object,entry.part)end
    return true
end
function H.startDistrict()
    N.requireGame("vd");H.repairRemotes();local entry=H.nearestGenerator();assert(entry,"Сначала обнови генераторы; незавершённые не найдены")
    local run=N.prepare("district");run.target=entry;run.lastProgress=N.attr(entry.object,"RepairProgress");run.stall=0;run.sendClock=0
    A.placeCharacter(CFrame.new(entry.part.Position+Vector3.new(0,3,0)))
    A.status("District: проход генераторов с проверкой реального RepairProgress")
end
function H.cancel(run)
    if run and run.task and type(task.cancel)=="function"then pcall(task.cancel,run.task)end
    if run then run.task=nil;run.awaiting=false end
    if H.repairTarget then local repair=H.remotePath("Remotes","Generator","RepairEvent");if repair and repair:IsA("RemoteEvent")then pcall(function()repair:FireServer(H.repairTarget,false)end)end;H.repairTarget=nil end
end
function H.districtStep(dt,run)
    local e=run.target
    if not e or not e.part:IsDescendantOf(workspace)then N.stop("District: генератор выгружен");return end
    local progress=N.attr(e.object,"RepairProgress");if type(progress)~="number"then N.stop("District: прогресс генератора недоступен");return end
    if progress>=100 then
        H.cancel(run);local nextEntry=H.nearestGenerator()
        if not nextEntry then N.stop("Все обнаруженные генераторы завершены. Победа подтверждается игрой.");return end
        run.target=nextEntry;run.lastProgress=N.attr(nextEntry.object,"RepairProgress");run.stall=0;run.sendClock=0;run.index=run.index+1
        A.placeCharacter(CFrame.new(nextEntry.part.Position+Vector3.new(0,3,0)));return
    end
    if progress>run.lastProgress then run.stall=0;run.lastProgress=progress else run.stall=run.stall+dt end
    if run.stall>10 then N.stop("District: 10 секунд без серверного прогресса; протокол или доступ не подходит");return end
    run.sendClock=run.sendClock+dt
    if run.sendClock>=1 then run.sendClock=0;if not H.repairOnce(e,H.flags.skillHelper)then N.stop("District: персонаж слишком далеко от точки ремонта")end end
end
function H.importPhoto(value)
    assert(not (N.job and N.job.kind=="photo"),"Сначала останови постройку")
    local plan=value
    if type(value)=="string"then assert(#value<=H.maxPhotoBytes,"Схема больше 4 МБ");plan=game:GetService("HttpService"):JSONDecode(value)end
    assert(type(plan)=="table"and plan.format=="nebula-photo-1","Нужна схема nebula-photo-1 из импортера")
    local function integer(n,lo,hi)return type(n)=="number"and n==n and n%1==0 and n>=lo and n<=hi end
    assert(integer(plan.width,1,H.maxPhotoSide)and integer(plan.height,1,H.maxPhotoSide),"Размер: 1–200 блоков по стороне")
    assert(type(plan.pixels)=="table"and #plan.pixels>0 and #plan.pixels<=H.maxPhotoPixels,"Число блоков: 1–40000")
    local material=tostring(plan.material or "PlasticBlock");assert(material:match("^[A-Za-z]+Block$")and #material<=40,"Неверное имя материала")
    local cell=tonumber(plan.cell or 2);assert(finite(cell)and cell>=0.1 and cell<=6,"Размер блока: 0.1–6 studs")
    local clean={format="nebula-photo-1",width=plan.width,height=plan.height,cell=cell,material=material,pixels={}};local seen={}
    for i,pixel in ipairs(plan.pixels)do
        assert(type(pixel)=="table"and #pixel==5,"Неверный пиксель "..i)
        assert(integer(pixel[1],0,plan.width-1)and integer(pixel[2],0,plan.height-1),"Пиксель за пределами схемы")
        for n=3,5 do assert(integer(pixel[n],0,255),"Цвет должен быть 0–255")end
        local key=pixel[1]..":"..pixel[2];assert(not seen[key],"Повтор координат пикселя");seen[key]=true
        clean.pixels[#clean.pixels+1]={pixel[1],pixel[2],pixel[3],pixel[4],pixel[5]}
    end
    H.clearPreview();H.photo=clean;H.anchor=nil;A.status("Схема импортирована: "..clean.width.."×"..clean.height.." · "..#clean.pixels.." блоков");return clean
end
function H.setAnchor()
    assert(not (N.job and N.job.kind=="photo"),"Сначала останови постройку")
    local r=rootOf(me);assert(r,"Персонаж не готов");H.anchor=r.CFrame*CFrame.new(0,2,-12);H.clearPreview();A.status("Точка картины сохранена в 12 studs перед персонажем")
end
function H.photoCF(index)
    local p=H.photo;local pixel=p.pixels[index]
    return H.anchor*CFrame.new((pixel[1]-(p.width-1)/2)*p.cell,(p.height-1-pixel[2])*p.cell,0)
end
function H.clearPreview()destroy(H.preview);H.preview=nil;H.previewIndex=nil;H.previewSeen=nil;H.previewCount=0;H.previewStride=1 end
function H.previewPhoto()
    assert(not (N.job and N.job.kind=="photo"),"Сначала останови постройку")
    assert(H.photo,"Сначала импортируй схему");if not H.anchor then H.setAnchor()end
    H.clearPreview();H.preview=new("Folder",{Name="NEBULA_PhotoPreview"},owned);H.previewIndex=1;H.previewCount=0;H.previewSeen={};H.previewStride=math.max(1,math.ceil(math.sqrt(#H.photo.pixels/4096)))
    A.status("Создаётся локальное превью; оно ещё не является постройкой на сервере")
end
function H.previewStep()
    if not H.previewIndex then return end
    local stride=H.previewStride or 1;local p=H.photo
    for _=1,(stride==1 and 32 or 256)do
        local index=H.previewIndex;local pixel=p.pixels[index]
        if not pixel then H.previewIndex=nil;return end
        local bx,by=math.floor(pixel[1]/stride),math.floor(pixel[2]/stride);local key=bx..":"..by
        if not H.previewSeen[key]and H.previewCount<4096 then
            H.previewSeen[key]=true;H.previewCount=H.previewCount+1
            local x,y=bx*stride,by*stride;local w,h=math.min(stride,p.width-x),math.min(stride,p.height-y)
            local cx,cy=x+(w-1)/2,y+(h-1)/2
            local cf=H.anchor*CFrame.new((cx-(p.width-1)/2)*p.cell,(p.height-1-cy)*p.cell,0)
            new("Part",{Name="PhotoPreviewPixel",Size=Vector3.new(p.cell*w,p.cell*h,math.min(0.5,p.cell)),CFrame=cf,Color=Color3.fromRGB(pixel[3],pixel[4],pixel[5]),Material=Enum.Material.SmoothPlastic,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,Transparency=0.15},H.preview)
        end
        H.previewIndex=index+1
    end
end
function H.setPhotoSpeed(value)
    assert(finite(value)and value>=1 and value<=10,"Скорость фото: ×1–×10")
    H.photoSpeed=value;S.photoBuildSpeed=value
    if N.job and (N.job.kind=="photo"or N.job.kind=="car")then N.job.speed=value;N.job.interval=0.5/value end
    if A.widgets.photoBuildSpeed then A.widgets.photoBuildSpeed()end
    A.status(string.format("Скорость фото ×%.1f: задержки уменьшены; результат зависит от ответа сервера",value))
end
function H.importPhotoClipboard()
    assert(type(getclipboard)=="function","Нет getclipboard. Используй «Скопировать Lua импорта» в HTML-импортере")
    return H.importPhoto(getclipboard())
end
function H.importPhotoFile(name)
    assert(type(name)=="string"and #name>=1 and #name<=40 and name:match("^[A-Za-z0-9_-]+$"),"Имя схемы: латиница, цифры, _ или -")
    assert(type(readfile)=="function","Исполнитель не предоставляет readfile")
    return H.importPhoto(readfile(name..".json"))
end
function H.buildTools()
    local build,paint,scale=H.tool("BuildingTool"),H.tool("PaintingTool"),H.tool("ScalingTool")
    local buildRF=build and build:FindFirstChild("RF");local paintRF=paint and paint:FindFirstChild("RF");local scaleRF=scale and scale:FindFirstChild("RF")
    assert(buildRF and buildRF:IsA("RemoteFunction"),"Нужен BuildingTool.RF")
    assert(paintRF and paintRF:IsA("RemoteFunction"),"Нужен PaintingTool.RF для цветов фото")
    assert(scaleRF and scaleRF:IsA("RemoteFunction"),"Нужен ScalingTool.RF для размера блоков")
    return {build=build,paint=paint,scale=scale,buildRF=buildRF,paintRF=paintRF,scaleRF=scaleRF}
end
function H.findZone()
    for _,obj in ipairs(workspace:GetChildren())do
        if obj:IsA("BasePart")then
            local color=obj:FindFirstChild("TeamColor");if color and color.Value==me.TeamColor then return obj end
            if obj.Name==tostring(me.TeamColor).."Zone"then return obj end
        end
    end
end
function H.startPhoto()
    N.requireGame("boat");assert(H.photo,"Сначала импортируй фото-схему");if not H.anchor then H.setAnchor()end
    local tools=H.buildTools();local zone=H.findZone();assert(zone,"Зона своей команды не найдена")
    local blocks=workspace:FindFirstChild("Blocks");local folder=blocks and blocks:FindFirstChild(me.Name);assert(folder,"Workspace/Blocks/твой ник не загружен")
    local data=me:FindFirstChild("Data");local inventory=data and data:FindFirstChild(H.photo.material)
    assert(inventory and type(inventory.Value)=="number"and inventory.Value>=#H.photo.pixels,"Недостаточно блоков "..H.photo.material.." в Player.Data")
    local run=N.prepare("photo");run.tools=tools;run.zone=zone;run.folder=folder;run.inventory=inventory;run.seen={};run.phase="place";run.phaseTime=0;run.placed=0;run.colored=0;run.sendClock=0;run.speed=H.photoSpeed;run.interval=0.5/H.photoSpeed
    for _,model in ipairs(folder:GetChildren())do run.seen[model]=true end
    H.clearPreview();A.status("Постройка фото: реальные вызовы инструментов, с проверкой появления, размера и цвета")
end
function H.invoke(run,tool,remote,args,nextPhase,onReply)
    assert(not run.awaiting,"Запрос ещё выполняется")
    local h=humOf(me);assert(h,"Персонаж не готов");h:EquipTool(tool)
    run.awaiting=true;run.phaseTime=0;run.nextPhase=nextPhase
    run.task=task.spawn(function()
        task.wait(0.15/(run.speed or 1))
        if not A.alive or N.job~=run then return end
        local ok,result,pose=pcall(function()return remote:InvokeServer(table.unpack(args))end)
        if not A.alive or N.job~=run then return end
        run.awaiting=false;run.task=nil
        if not ok or result==false then N.stop("Инструмент отклонил запрос: "..tostring(result):sub(1,100));return end
        if onReply then local accepted,err=pcall(onReply,result,pose);if not accepted then N.stop("Ответ инструмента не принят: "..tostring(err):sub(1,120));return end end
        run.phase=nextPhase;run.phaseTime=0
    end)
end
function H.photoStep(dt,run)
    run.phaseTime=run.phaseTime+dt;run.sendClock=run.sendClock+dt
    if run.phaseTime>8 then N.stop("Постройка остановлена: 8 секунд без подтверждения инструмента/блока");return end
    if run.awaiting then return end
    local p=H.photo;local pixel=p.pixels[run.index]
    if not pixel then N.stop("Фото: подтверждены размещение и цвет "..run.colored.." блоков");return end
    assert(run.zone.Parent and run.folder.Parent,"Зона или папка блоков выгружена")
    local cf=H.photoCF(run.index);local color=Color3.fromRGB(pixel[3],pixel[4],pixel[5]);local size=Vector3.new(p.cell,p.cell,math.min(0.5,p.cell))
    if run.phase=="place"then
        if run.sendClock<(run.interval or 0.5)then return end;run.sendClock=0
        assert(run.inventory.Value>0,"Блоки закончились")
        H.invoke(run,run.tools.build,run.tools.buildRF,{p.material,run.inventory.Value,run.zone,run.zone.CFrame:ToObjectSpace(cf),true,cf,false},"identify")
    elseif run.phase=="identify"then
        for _,model in ipairs(run.folder:GetChildren())do if not run.seen[model]and model.Name==p.material then local part=model:FindFirstChild("PPart")
            if part and part:IsA("BasePart")and (part.Position-cf.Position).Magnitude<0.6 then run.model=model;run.part=part;run.seen[model]=true;run.placed=run.placed+1;run.phase="scale";run.phaseTime=0;break end
        end end
    elseif run.phase=="scale"then
        if run.sendClock<(run.interval or 0.5)then return end;run.sendClock=0
        H.invoke(run,run.tools.scale,run.tools.scaleRF,{run.model,size,cf},"verifyScale")
    elseif run.phase=="verifyScale"then
        assert(run.part and run.part.Parent,"Размещённый блок удалён")
        local tolerance=math.max(0.002,math.min(0.025,p.cell*0.02))
        if (run.part.Size-size).Magnitude<=tolerance then run.phase="paint";run.phaseTime=0 end
    elseif run.phase=="paint"then
        if run.sendClock<(run.interval or 0.5)then return end;run.sendClock=0
        H.invoke(run,run.tools.paint,run.tools.paintRF,{{{run.model,color}}},"verifyPaint")
    elseif run.phase=="verifyPaint"then
        assert(run.part and run.part.Parent,"Размещённый блок удалён")
        local c=run.part.Color
        if math.abs(c.R-color.R)+math.abs(c.G-color.G)+math.abs(c.B-color.B)<0.04 then
            run.colored=run.colored+1;run.index=run.index+1;run.model=nil;run.part=nil;run.phase="place";run.phaseTime=0
            A.status("Фото: подтверждено "..run.colored.." / "..#p.pixels)
        end
    end
end
function H.step(dt)
    H.previewStep();H.clock=H.clock+dt;if H.clock<1 then return end;H.clock=0
    local r,h=rootOf(me),humOf(me);if not r or not h or h.Health<=0 then return end
    if N.match("mm2")and not N.job and not A.scenario and not A.fling and not A.hidden and not G.runner then
        if H.flags.autoGun and not H.tool("Gun")and not H.tool("Knife")then local gun,part=N.gunDrop();if gun and part then A.placeCharacter(CFrame.new(part.Position+Vector3.new(0,1,0)));H.flags.autoGun=false;A.status("GunDrop: одна попытка подбора; результат проверяй по инвентарю")end end
        if H.flags.knifeHelper then
            local knife=me.Character:FindFirstChild("Knife");local stab=knife and knife:FindFirstChild("Stab")
            if stab and stab:IsA("RemoteEvent")then
                for _,pl in ipairs(P:GetPlayers())do local pr,ph=rootOf(pl),humOf(pl);if pl~=me and pr and ph and ph.Health>0 and (pr.Position-r.Position).Magnitude<=7 then stab:FireServer("Slash");break end end
            end
        end
    end
    if N.match("vd")and not N.job and H.flags.repairHelper then local entry,d=H.nearestGenerator();if entry and d<=12 then H.repairOnce(entry,H.flags.skillHelper)end end
    if H.refresh then H.refresh()end
end
function H.disable()
    H.cancel(N.job);for k in pairs(H.flags)do H.flags[k]=false end;if H.refresh then H.refresh()end
end
function H.cleanup()
    H.cancel(N.job);H.clearPreview();H.photo=nil;H.anchor=nil;for k in pairs(H.flags)do H.flags[k]=false end
    if H.refresh then H.refresh()end
end



























-- BEGIN NEBULA GARAGE
-- Original NEBULA BABFT garage. Included inside Control; no external loaders.
do
local C={selected=1,paint=1,suspension=2,anchor=nil,preview=nil,last=nil,turn=0}
N.Cars=C
-- Individually authored station profiles, dimensions in mm; no downloaded 3D assets.
-- Individually authored station profiles, dimensions in mm; no downloaded 3D assets.
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
 for i,z in ipairs({front,0,rear})do box("crossmember"..i,0,1.35,z,math.min(w*1.74,(w-1.2)*2),.4,.5,"metal",nil,nil,nil,"MetalBlock")end
 for _,s in ipairs({-1,1})do
  box("rail"..s,s*w*.73,1.25,0,.45,.65,l*.82,"metal",nil,nil,nil,"MetalBlock")
  box("sill"..s,s*w*.91,.8,0,.45,.5,wb-3.8,"black")
  for k,z in ipairs({-wb*.22,0,wb*.22})do beam("outrigger"..s..":"..k,V(s*w*.73,1.1,z),V(s*w*.91,.9,z),.28,"metal",.28,"MetalBlock")end
  for k,z in ipairs({front,rear})do box("upperMount"..s..":"..k,s*w*.73,1.95,z,.35,1.4,1.6,"metal",nil,nil,nil,"MetalBlock")end
 end
 for k,z in ipairs({front,0,rear})do for _,s in ipairs({-1,1})do local top=body(z/l+.5,s*.4);beam("skinSupport"..s..":"..k,V(top[1],1.35,z),V(top[1],top[2]-.07,z),.25,"metal",.25,"MetalBlock")end end
 -- Curved double-curvature deck: authored shoulder and centre heights vary separately.
 local long,across=64,10
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
 local preset=C.suspensions[C.suspension];run.tune={stiffness=preset.stiffness,damping=preset.damping}
 for _,q in ipairs(plan.parts)do if q.group=="spring"then local sum=0;for j=1,3 do sum=sum+(q.pos[j]-q.second[j])^2 end;run.tune.freeLength=math.sqrt(sum);break end end
 run.models={};run.phase="place";run.phaseTime=0;run.sendClock=0;C.last=nil;C.clearPreview()
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
  if joint:IsA("Weld")or joint:IsA("WeldConstraint")or joint:IsA("ManualWeld")then union(joint.Part0,joint.Part1)end
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
   C.last={plan=run.plan,models=run.models,folder=run.folder,tune=run.tune,base=run.base}
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
   run.phase=stiffness and "tuneDamping"or "tuneLength";run.phaseTime=0;return
  elseif run.phase=="tuneLength"then
   local springs={};for _,entry in ipairs(run.models)do if entry.spec.group=="spring"then springs[#springs+1]=entry.model end end
   H.invoke(run,run.tools.props,run.tools.propsRF,{"Target lenght",springs,run.tune.freeLength},"verifyLength");return
  elseif run.phase=="verifyLength"then
   for _,entry in ipairs(run.models)do if entry.spec.group=="spring"then local spring=entry.model:FindFirstChildWhichIsA("SpringConstraint",true);if not spring or not finite(spring.FreeLength)or math.abs(spring.FreeLength-run.tune.freeLength)>.01 then return end end end
   run.phase="finish";run.phaseTime=0;return
  elseif run.phase=="finish"then
   C.last={plan=run.plan,models=run.models,folder=run.folder,tune=run.tune,base=run.base};N.stop("Кузов и механика размещены. Машина закреплена; проверь связи и ходовую перед запуском.");return
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
    run.seen[model]=true;run.model=model;run.part=part;run.models[#run.models+1]={model=model,spec=q};run.phase=q.size and "scale"or(q.skipPaint and "advance"or "paint");run.phaseTime=0;break
   end
  end end
 elseif run.phase=="scale"then H.invoke(run,run.tools.scale,run.tools.scaleRF,{run.model,Vector3.new(table.unpack(q.size)),cf},"verifyScale",function(size,pose)C.acceptScaleReply(run,q,size,pose)end)
 elseif run.phase=="verifyScale"then
  assert(run.part.Parent,"Деталь удалена");if (run.part.Size-Vector3.new(table.unpack(q.size))).Magnitude<=.005 and C.poseClose(run.part.CFrame,cf)then run.phase="paint";run.phaseTime=0 end
 elseif run.phase=="paint"then H.invoke(run,run.tools.paint,run.tools.paintRF,{{{run.model,color}}},"verifyPaint")
 elseif run.phase=="advance"then
  run.index=run.index+1;run.phase=run.index>#run.plan.parts and "bind"or "place";run.phaseTime=0
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
 assert(not N.job,"Сначала останови задачу");C.audit(C.last)
 local seat,spine
 for _,entry in ipairs(C.last.models)do if entry.spec.group=="seat"then seat=entry.model:FindFirstChildWhichIsA("VehicleSeat",true)end;if entry.spec.id=="spine"then spine=entry.model:FindFirstChild("PPart")end end
 assert(spine and not spine.Anchored,"Сначала сними закрепление после аудита")
 assert(seat and seat.Occupant==humOf(me),"Сядь в водительское сиденье своей машины")
 C.lastDriveReport=nil;C.probe={record=C.last,seat=seat,spine=spine,character=me.Character,origin=spine.Position,yaw=math.atan2(-spine.CFrame.LookVector.X,-spine.CFrame.LookVector.Z),elapsed=0,distance=0,turn=0,spinning={},throttle=false,steer=false}
 A.status("12 секунд: сам проедь вперёд и поверни. Проверка только измеряет, не управляет персонажем.")
end
function C.stepProbe(dt)
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
function C.cleanup()C.probe=nil;C.lastDriveReport=nil;C.clearPreview();C.anchor=nil;C.last=nil;destroy(C.stage);C.stage=nil end
end

-- END NEBULA GARAGE

-- Original NEBULA Spray Paint module. Image decoding is provided by the local helper.
local SP={plan=nil,area=nil,picks={},picking=false,loadGeneration=0,loading=false,rate=8,layer=1,preview=nil,previewIndex=nil}
N.Spray=SP
N.games.spray={name="NEBULA Spray Paint",place=5991163185}
function SP.import(value)
    assert(not (N.job and N.job.kind=="spray"),"Сначала останови рисование")
    local data=type(value)=="string"and game:GetService("HttpService"):JSONDecode(value)or value
    if type(data)=="table"and data.error then error(tostring(data.error))end
    assert(type(data)=="table"and data.format=="nebula-spray-1","Нужна схема nebula-spray-1")
    local function int(x,a,b)return type(x)=="number"and x==x and x%1==0 and x>=a and x<=b end
    assert(int(data.width,1,128)and int(data.height,1,128),"Разрешение: до 128×128")
    assert(type(data.pixels)=="table"and #data.pixels>0 and #data.pixels<=16384,"Число точек: 1–16384")
    local clean={width=data.width,height=data.height,pixels={}};local seen={}
    for i,p in ipairs(data.pixels)do
        assert(type(p)=="table"and #p==5 and int(p[1],0,data.width-1)and int(p[2],0,data.height-1),"Неверная координата точки "..i)
        for c=3,5 do assert(int(p[c],0,255),"Неверный цвет")end
        local key=p[1]..":"..p[2];assert(not seen[key],"Повтор точки");seen[key]=true
        clean.pixels[#clean.pixels+1]={p[1],p[2],p[3],p[4],p[5]}
    end
    SP.clearPreview();SP.plan=clean;if SP.rememberImport then SP.rememberImport()end;if SP.refresh then SP.refresh()end;A.status("Spray: фото загружено · "..clean.width.."×"..clean.height.." · "..#clean.pixels.." точек")
end
function SP.loadURL(url,side,colors)
    assert(A.alive,"NEBULA выгружена")
    assert(not SP.loading,"Фото уже загружается");assert(not (N.job and N.job.kind=="spray"),"Сначала останови рисование")
    assert(type(url)=="string"and #url<=6000 and url:match("^https://"),"Нужна прямая HTTPS-ссылка на фото")
    assert(finite(side)and side%1==0 and side>=2 and side<=128,"Разрешение: целое 2–128")
    colors=colors or 256;assert(colors==2 or colors==3 or colors==4 or colors==6 or colors==16 or colors==256,"Неверная палитра")
    SP.loading=true;SP.loadGeneration=SP.loadGeneration+1;local generation=SP.loadGeneration
    A.status("Фото: запрос к локальному NEBULA Image Helper…")
    task.spawn(function()
        if not A.alive or generation~=SP.loadGeneration then return end
        local ok,result=pcall(function()
            local http=game:GetService("HttpService")
            return game:HttpGet("http://127.0.0.1:8766/convert?side="..side.."&colors="..colors.."&url="..http:UrlEncode(url))
        end)
        if not A.alive or generation~=SP.loadGeneration then return end
        SP.loading=false
        if not ok then A.status("Не удалось загрузить фото. Запусти NEBULA-Image-Helper.exe и проверь прямую ссылку");return end
        if type(result)~="string"or #result>1500000 then A.status("Декодер вернул неверный или слишком большой ответ");return end
        local valid,err=pcall(SP.import,result);if not valid then A.status("Фото: "..tostring(err):sub(1,180))end
    end)
end
function SP.clearPreview()destroy(SP.preview);SP.preview=nil;SP.previewIndex=nil end
function SP.setArea(a,b,c,part,normal)
    assert(not (N.job and N.job.kind=="spray"),"Сначала останови рисование")
    local delta=b-a;local width=delta.Magnitude;assert(width>=0.5 and width<=100,"Ширина области: 0.5–100 studs")
    local right=delta.Unit;local raw=c-a
    local downVector=raw-right*raw:Dot(right);local height=downVector.Magnitude
    assert(height>=0.5 and height<=100,"Высота области: 0.5–100 studs; точки не должны лежать на одной линии")
    assert(math.abs(raw:Dot(right))<=math.max(0.2,width*0.12),"Третий угол должен быть под первым, а не по диагонали")
    local down=downVector.Unit;local n=normal.Unit
    assert(math.abs(right:Dot(n))<0.08 and math.abs(down:Dot(n))<0.08,"Нужна одна плоская поверхность")
    assert(part and part:IsA("BasePart")and part:IsDescendantOf(workspace),"Поверхность удалена")
    SP.clearPreview();SP.revision=(SP.revision or 0)+1;SP.checkpoint=nil;SP.area={origin=a,right=right,down=down,normal=n,width=width,height=height,part=part,partCF=part.CFrame}
    if SP.refresh then SP.refresh()end
end
function SP.beginSelect()
    N.requireGame("spray");assert(not N.job,"Сначала останови активный цикл")
    local focus=U:GetFocusedTextBox();if focus then focus:ReleaseFocus()end
    SP.picks={};SP.picking=true;A.show(false);A.status("Область: кликни верхний левый, верхний правый, затем нижний левый угол. Escape — отмена")
end
function SP.cancelSelect()SP.picking=false;SP.picks={};if A.alive then A.show(true)end end
function SP.capture(input,processed)
    if not SP.picking then return false end
    if input.KeyCode==Enum.KeyCode.Escape then SP.cancelSelect();return true end
    if input.UserInputType~=Enum.UserInputType.MouseButton1 or processed then return false end
    local cam=workspace.CurrentCamera;if not cam then return true end
    local mouse=U:GetMouseLocation();local ray=cam:ScreenPointToRay(mouse.X,mouse.Y)
    local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={me.Character,owned}
    local hit=workspace:Raycast(ray.Origin,ray.Direction*500,params)
    if not hit or not hit.Instance or not hit.Instance:IsA("BasePart")then A.status("Кликни по плоской стене или полу");return true end
    for _,pl in ipairs(P:GetPlayers())do if pl.Character and hit.Instance:IsDescendantOf(pl.Character)then A.status("Нельзя выбирать поверхность персонажа");return true end end
    if #SP.picks>0 and hit.Instance~=SP.picks[1].part then A.status("Все три угла должны находиться на одной детали");return true end
    SP.picks[#SP.picks+1]={point=hit.Position,part=hit.Instance,normal=hit.Normal}
    if #SP.picks==3 then
        local p=SP.picks;local ok,err=pcall(SP.setArea,p[1].point,p[2].point,p[3].point,p[1].part,p[1].normal)
        SP.picking=false;SP.picks={};A.show(true);A.status(ok and "Область сохранена. Проверь превью перед запуском"or "Область: "..tostring(err))
    else A.status("Сохранён угол "..#SP.picks.." / 3")end
    return true
end
function SP.geometry()
    assert(SP.plan and SP.area,"Загрузи фото и выбери область")
    local p,a=SP.plan,SP.area
    assert(a.part:IsDescendantOf(workspace)and a.part.CFrame==a.partCF,"Поверхность сдвинулась или удалена: выбери область заново")
    local cell=math.min(a.width/p.width,a.height/p.height)
    return cell,(a.width-cell*p.width)/2,(a.height-cell*p.height)/2
end
function SP.point(index)
    local cell,padX,padY=SP.geometry();local p=SP.plan.pixels[index];local a=SP.area
    local position=a.origin+a.right*(padX+(p[1]+0.5)*cell)+a.down*(padY+(p[2]+0.5)*cell)+a.normal*0.012
    return position,CFrame.lookAt(position,position+a.normal,-a.down),cell
end
function SP.previewPhoto()
    assert(not (N.job and N.job.kind=="spray"),"Сначала останови рисование")
    local cell,padX,padY=SP.geometry();SP.clearPreview()
    local a,p=SP.area,SP.plan;local center=a.origin+a.right*(a.width/2)+a.down*(a.height/2)+a.normal*0.02
    SP.preview=new("Part",{Name="NEBULA_SprayPreview",Size=Vector3.new(cell*p.width,cell*p.height,0.01),CFrame=CFrame.lookAt(center,center+a.normal,-a.down),Anchored=true,CanCollide=false,CanQuery=false,CanTouch=false,Transparency=1},owned)
    SP.surface=new("SurfaceGui",{Face=Enum.NormalId.Front,CanvasSize=Vector2.new(p.width,p.height),LightInfluence=0,AlwaysOnTop=false},SP.preview)
    SP.previewIndex=1;A.status("Локальное превью: фотография вписана в область без растягивания")
end
function SP.previewStep()
    if not SP.previewIndex then return end
    local p=SP.plan;local stride=math.max(1,math.ceil(math.sqrt(#p.pixels/4096)))
    for _=1,128 do
        local pixel=p.pixels[SP.previewIndex];if not pixel then SP.previewIndex=nil;return end
        if pixel[1]%stride==0 and pixel[2]%stride==0 then
            local flip=SP.preview.CFrame.RightVector:Dot(SP.area.right)<0
            local x=flip and p.width-pixel[1]-stride or pixel[1]
            new("Frame",{Position=UDim2.fromOffset(math.max(0,x),pixel[2]),Size=UDim2.fromOffset(math.min(stride,p.width-pixel[1]),math.min(stride,p.height-pixel[2])),BackgroundColor3=Color3.fromRGB(pixel[3],pixel[4],pixel[5]),BorderSizePixel=0},SP.surface)
        end
        SP.previewIndex=SP.previewIndex+1
    end
end
function SP.protocol()
    local tool=H.tool("SprayPaint");local remote=tool and tool:FindFirstChild("SendPaintInfo")
    local effect=H.remotePath("SprayEffect")
    assert(tool and remote and remote:IsA("RemoteFunction"),"Экипируй SprayPaint: SendPaintInfo RemoteFunction не найден")
    assert(effect and effect:IsA("RemoteEvent"),"ReplicatedStorage/SprayEffect не найден")
    return tool,remote,effect
end
function SP.start()
    local startIndex=SP.startFrom or 1;SP.startFrom=nil
    N.requireGame("spray");assert(not SP.loading,"Дождись загрузки фото");assert(not SP.picking,"Заверши выбор области")
    local cell=SP.geometry();assert(cell>=0.2 and cell<=2.2,"Для этого разрешения размер точки выходит за 0.2–2.2 studs: измени область или разрешение фото")
    assert(SP.rate>=1 and SP.rate<=12 and SP.layer>=1 and SP.layer<=10,"Скорость 1–12 точек/с; слой 1–10")
    assert(startIndex%1==0 and startIndex>=1 and startIndex<=#SP.plan.pixels,"Номер точки вне схемы")
    local order=SP.buildOrder(SP.orderMode)
    local tool,remote,effect=SP.protocol();local run=N.prepare("spray");run.index=startIndex;run.order=order;run.orderMode=SP.orderMode;run.version=SP.revision;run.remote=remote;run.effect=effect;run.tool=tool;run.clock=0;run.sent=0;run.scale=cell;run.layer=SP.layer;run.rate=SP.rate;run.paused=false
    local ok,err=pcall(function()humOf(me):EquipTool(tool);effect:FireServer(true,Color3.new(1,1,1))end)
    if not ok then N.stop("Spray: инструмент не активирован");error(err)end
    run.effectStarted=true;SP.clearPreview()
    A.status("Spray: начата отправка штрихов; результат на сервере пока не подтверждён")
end
function SP.stop(run)
    if not run or run.kind~="spray"then return end
    SP.checkpoint={index=run.index,version=run.version,mode=run.orderMode,layer=run.layer}
    if run.task and type(task.cancel)=="function"then pcall(task.cancel,run.task)end;run.task=nil;run.awaiting=false
    if run.effectStarted then pcall(function()run.effect:FireServer(false)end);run.effectStarted=false end
end
function SP.step(dt,run)
    if run.awaiting then run.waitTime=run.waitTime+dt;if run.waitTime>8 then N.stop("Spray: 8 секунд без ответа сервера, остановлено")end;return end
    if run.paused then return end
    SP.geometry();run.clock=run.clock+math.min(dt,1)
    if run.clock<1/run.rate then return end;run.clock=0
    local pixelIndex=run.order and run.order[run.index]or run.index
    local pixel=SP.plan.pixels[pixelIndex]
    if not pixel then N.stop("Spray: отправлено точек "..run.sent..". Отрисовку и сохранение проверяй в игре");return end
    local _,cf=SP.point(pixelIndex)
    local record={brushType="Circle",scale=run.scale,cframe=cf,color=Color3.fromRGB(pixel[3],pixel[4],pixel[5]),layer=run.layer,trans=0}
    run.awaiting=true;run.waitTime=0
    run.task=task.spawn(function()
        if not A.alive or N.job~=run then return end
        local ok,result=pcall(function()return run.remote:InvokeServer(tick()/300,{record})end)
        if not A.alive or N.job~=run then return end
        run.task=nil;run.awaiting=false
        if not ok or result==false then N.stop("Spray: сервер отклонил штрих или протокол изменился");return end
        run.sent=run.sent+1;run.index=run.index+1
        if SP.refresh then SP.refresh()end
    end)
end
function SP.cleanup()
    SP.loadGeneration=SP.loadGeneration+1;SP.loading=false;SP.picking=false;SP.picks={};SP.clearPreview();SP.plan=nil;SP.area=nil;SP.original=nil;SP.history={};SP.checkpoint=nil
    if SP.refresh then SP.refresh()end
end

-- Original camera aim assist for the own MM2 module. No weapon remotes or auto fire.
local Aim={enabled=false,showFOV=true,visibleOnly=true,knifeOnly=true,always=false,button=Enum.UserInputType.MouseButton2,part="Head",radius=120,smooth=12,lead=0.08,range=500,target=nil}
N.Aim=Aim
Aim.ring=new("Frame",{Name="MM2AimFOV",AnchorPoint=Vector2.new(0.5,0.5),Size=UDim2.fromOffset(240,240),BackgroundTransparency=1,Visible=false},gui)
new("UICorner",{CornerRadius=UDim.new(0.5,0)},Aim.ring)
Aim.stroke=new("UIStroke",{Color=Color3.fromRGB(210,210,210),Thickness=1,Transparency=0.4},Aim.ring)
Aim.caption=text(gui,"",nil,UDim2.fromOffset(260,22),Enum.Font.GothamMedium,Color3.fromRGB(210,210,210));Aim.caption.Name="MM2AimTarget";Aim.caption.Visible=false;Aim.caption.TextXAlignment=Enum.TextXAlignment.Center
function Aim.hasKnife(pl)
    local c,b=pl.Character,pl:FindFirstChild("Backpack")
    local item=c and c:FindFirstChild("Knife")or b and b:FindFirstChild("Knife")
    return item and item:IsA("Tool")or false
end
function Aim.configure(key,value)
    local limits={radius={20,600},smooth={1,35},lead={0,0.25},range={25,2000}}
    if limits[key]then assert(finite(value),"Нужно конечное число");value=math.clamp(value,limits[key][1],limits[key][2])
    elseif key=="part"then assert(value=="Head"or value=="HumanoidRootPart","Точка: Head или HumanoidRootPart")
    elseif key=="button"then assert(value==Enum.UserInputType.MouseButton1 or value==Enum.UserInputType.MouseButton2 or value==Enum.KeyCode.LeftAlt,"Бинд: ЛКМ, ПКМ или LeftAlt")
    elseif type(Aim[key])=="boolean"then assert(type(value)=="boolean","Нужно on/off")
    else error("Неизвестная настройка aim")end
    if key=="enabled"and value then N.requireGame("mm2")end
    Aim[key]=value;Aim.target=nil
    if not Aim.enabled then Aim.ring.Visible=false;Aim.caption.Visible=false end
    if Aim.refresh then Aim.refresh()end
end
function Aim.isHeld()
    if Aim.always then return true end
    if Aim.button==Enum.KeyCode.LeftAlt then return U:IsKeyDown(Aim.button)end
    return U:IsMouseButtonPressed(Aim.button)
end
function Aim.findTarget(cam,cursor)
    local selfRoot=rootOf(me);if not selfRoot then return end
    local best,bestPoint,bestDistance
    local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={me.Character,owned}
    for _,pl in ipairs(P:GetPlayers())do if pl~=me and pl.Parent==P then
        local h,r=humOf(pl),rootOf(pl);local character=pl.Character
        local part=character and character:FindFirstChild(Aim.part)
        if h and h.Health>0 and r and part and part:IsA("BasePart")and (r.Position-selfRoot.Position).Magnitude<=Aim.range and (not Aim.knifeOnly or Aim.hasKnife(pl))then
            local velocity=r.AssemblyLinearVelocity or Vector3.new();if velocity.Magnitude>200 then velocity=vectorUnit(velocity)*200 end
            local point=part.Position+velocity*Aim.lead
            local screen,onScreen=cam:WorldToViewportPoint(point)
            local distance=Vector2.new(screen.X-cursor.X,screen.Y-cursor.Y).Magnitude
            if onScreen and screen.Z>0 and distance<=Aim.radius and (not bestDistance or distance<bestDistance)then
                local visible=true
                if Aim.visibleOnly then local hit=workspace:Raycast(cam.CFrame.Position,point-cam.CFrame.Position,params)
                    if hit and hit.Instance and not hit.Instance:IsDescendantOf(character)then visible=false end
                end
                if visible then best=pl;bestPoint=point;bestDistance=distance end
            end
        end
    end end
    return best,bestPoint
end
function Aim.step(dt)
    Aim.target=nil;Aim.caption.Visible=false;Aim.ring.Visible=false
    if not A.alive or not Aim.enabled or not N.match("mm2")then return end
    local cam=workspace.CurrentCamera;local h=humOf(me)
    if not cam or not h or h.Health<=0 or me.Character==A.departing then return end
    local cursor=U:GetMouseLocation()
    Aim.ring.Position=UDim2.fromOffset(cursor.X,cursor.Y);Aim.ring.Size=UDim2.fromOffset(Aim.radius*2,Aim.radius*2)
    Aim.ring.Visible=Aim.showFOV and not S.silent
    if U:GetFocusedTextBox()or A.open or S.spectate or cam.CameraType==Enum.CameraType.Scriptable or not Aim.isHeld()then return end
    local gun=me.Character and me.Character:FindFirstChild("Gun")
    if not gun or not gun:IsA("Tool")then return end
    local target,point=Aim.findTarget(cam,cursor)
    if not target or not point or (point-cam.CFrame.Position).Magnitude<0.1 then return end
    Aim.target=target
    local goal=CFrame.lookAt(cam.CFrame.Position,point)
    local alpha=1-math.exp(-Aim.smooth*math.clamp(dt,0,0.1))
    cam.CFrame=cam.CFrame:Lerp(goal,alpha)
    Aim.caption.Text=target.Name.." · aim";Aim.caption.Position=UDim2.fromOffset(cursor.X-130,cursor.Y+Aim.radius+6)
    Aim.caption.Visible=not S.silent
end
function Aim.cleanup()
    Aim.enabled=false;Aim.target=nil;Aim.ring.Visible=false;Aim.caption.Visible=false
    if Aim.refresh then Aim.refresh()end
end

-- Original editing/project helpers for the Spray Paint plan. JSON only, never Lua execution.
SP.orderMode="rows";SP.revision=SP.revision or 0;SP.history={};SP.favorites={};SP.original=nil
function SP.clone(plan)
    local result={format="nebula-spray-1",width=plan.width,height=plan.height,pixels={}}
    for _,p in ipairs(plan.pixels)do result.pixels[#result.pixels+1]={p[1],p[2],p[3],p[4],p[5]}end
    return result
end
function SP.rememberImport()
    SP.original=SP.clone(SP.plan);SP.history={};SP.revision=SP.revision+1;SP.checkpoint=nil
end
function SP.edit(mode)
    assert(SP.plan,"Сначала загрузи изображение");assert(not (N.job and N.job.kind=="spray"),"Сначала останови рисование")
    local before=SP.clone(SP.plan);local output=SP.clone(SP.plan);output.pixels={}
    local function byte(v)return math.clamp(math.floor(v+0.5),0,255)end
    for _,p in ipairs(before.pixels)do
        local x,y,r,g,b=p[1],p[2],p[3],p[4],p[5];local keep=true;local gray=0.2126*r+0.7152*g+0.0722*b
        if mode=="cw"then x,y=before.height-1-y,x
        elseif mode=="ccw"then x,y=y,before.width-1-x
        elseif mode=="flipx"then x=before.width-1-x
        elseif mode=="flipy"then y=before.height-1-y
        elseif mode=="gray"then r,g,b=gray,gray,gray
        elseif mode=="invert"then r,g,b=255-r,255-g,255-b
        elseif mode=="sepia"then r,g,b=0.393*r+0.769*g+0.189*b,0.349*r+0.686*g+0.168*b,0.272*r+0.534*g+0.131*b
        elseif mode=="bright+"then r,g,b=r+20,g+20,b+20
        elseif mode=="bright-"then r,g,b=r-20,g-20,b-20
        elseif mode=="contrast+"or mode=="contrast-"then local factor=mode=="contrast+"and 1.2 or 1/1.2;r,g,b=(r-128)*factor+128,(g-128)*factor+128,(b-128)*factor+128
        elseif mode=="sat+"or mode=="sat-"then local factor=mode=="sat+"and 1.2 or 0.8;r,g,b=gray+(r-gray)*factor,gray+(g-gray)*factor,gray+(b-gray)*factor
        elseif mode=="bw"then local value=gray>=128 and 255 or 0;r,g,b=value,value,value
        elseif mode=="poster"then r,g,b=math.floor(r/85+0.5)*85,math.floor(g/85+0.5)*85,math.floor(b/85+0.5)*85
        elseif mode=="removeWhite"then keep=not (r>240 and g>240 and b>240)
        elseif mode=="removeBlack"then keep=not (r<15 and g<15 and b<15)
        else error("Неизвестная обработка")end
        if keep then output.pixels[#output.pixels+1]={x,y,byte(r),byte(g),byte(b)}end
    end
    if mode=="cw"or mode=="ccw"then output.width,output.height=before.height,before.width end
    assert(#output.pixels>0,"После обработки не осталось видимых точек")
    local original=SP.original;local history=SP.history;history[#history+1]=before;if #history>5 then table.remove(history,1)end
    SP.import(output);SP.original=original;SP.history=history
    A.status("Изображение обработано. Проверь превью перед рисованием")
end
function SP.undo()
    assert(not (N.job and N.job.kind=="spray"),"Сначала останови рисование");local history=SP.history;assert(#history>0,"Нет предыдущего шага")
    local plan=table.remove(history);local original=SP.original;SP.import(plan);SP.history=history;SP.original=original
end
function SP.resetImage()assert(SP.original,"Исходное фото не загружено");local original=SP.clone(SP.original);SP.import(original)end
function SP.buildOrder(mode)
    local indices={};for i in ipairs(SP.plan.pixels)do indices[#indices+1]=i end
    table.sort(indices,function(a,b)
        local p,q=SP.plan.pixels[a],SP.plan.pixels[b]
        if mode=="color"then
            local pc=p[3]*65536+p[4]*256+p[5];local qc=q[3]*65536+q[4]*256+q[5]
            if pc~=qc then return pc<qc end
        end
        if p[2]~=q[2]then return p[2]<q[2]end
        if mode=="snake"and p[2]%2==1 then return p[1]>q[1]end
        return p[1]<q[1]
    end)
    if mode=="reverse"then local reverse={};for i=#indices,1,-1 do reverse[#reverse+1]=indices[i]end;return reverse end
    return indices
end
function SP.setOrder(mode)
    assert(not (N.job and N.job.kind=="spray"),"Сначала останови рисование")
    assert(mode=="rows"or mode=="snake"or mode=="color"or mode=="reverse","Неизвестный порядок")
    SP.orderMode=mode;SP.checkpoint=nil;A.status("Порядок штрихов: "..mode)
end
function SP.resume()
    local c=SP.checkpoint;assert(c and c.version==SP.revision and c.mode==SP.orderMode and c.layer==SP.layer,"Продолжение недоступно: изменилась схема, область, слой или порядок")
    assert(c.index<=#SP.plan.pixels,"Все точки уже отправлены")
    SP.startFrom=c.index;SP.start()
end
function SP.adjustArea(dx,dy,factor)
    assert(SP.area,"Сначала выдели область");local a=SP.area
    local center=a.origin+a.right*(a.width/2+dx*a.width)+a.down*(a.height/2+dy*a.height)
    local width,height=math.clamp(a.width*factor,0.5,100),math.clamp(a.height*factor,0.5,100)
    local origin=center-a.right*(width/2)-a.down*(height/2)
    SP.setArea(origin,origin+a.right*width,origin+a.down*height,a.part,a.normal)
end
function SP.projectPath(name)
    assert(type(name)=="string"and #name>=1 and #name<=40 and name:match("^[A-Za-z0-9_-]+$"),"Имя проекта: латиница, цифры, _ и -, до 40 символов")
    return "NEBULA/Spray/"..name..".json"
end
function SP.saveProject(name)
    assert(SP.plan,"Сначала загрузи изображение");local path=SP.projectPath(name)
    assert(type(writefile)=="function"and type(makefolder)=="function","Исполнитель не предоставляет writefile/makefolder")
    pcall(makefolder,"NEBULA");pcall(makefolder,"NEBULA/Spray")
    local data=SP.clone(SP.plan);data.nebulaSettings={order=SP.orderMode,rate=SP.rate,layer=SP.layer}
    writefile(path,game:GetService("HttpService"):JSONEncode(data));A.status("Проект сохранён: "..path..". Область выбирается отдельно")
end
function SP.loadProject(name)
    local path=SP.projectPath(name);assert(type(readfile)=="function","Исполнитель не предоставляет readfile")
    local text=readfile(path);assert(type(text)=="string"and #text<=1500000,"Файл слишком большой")
    local data=game:GetService("HttpService"):JSONDecode(text);SP.import(data)
    local settings=data.nebulaSettings
    if type(settings)=="table"then
        if settings.order=="rows"or settings.order=="snake"or settings.order=="color"or settings.order=="reverse"then SP.orderMode=settings.order end
        if finite(settings.rate)then SP.rate=math.clamp(settings.rate,1,12)end
        if finite(settings.layer)then SP.layer=math.clamp(math.floor(settings.layer),1,10)end
    end
    A.status("Проект загружен; выбери или проверь область перед запуском")
end
function SP.copyPlan()
    assert(SP.plan,"Нет изображения");local copy=setclipboard or toclipboard;assert(type(copy)=="function","Нет функции копирования буфера");copy(game:GetService("HttpService"):JSONEncode(SP.clone(SP.plan)));A.status("JSON схемы скопирован")
end

-- Original loaded-map helpers for two additional places; no downloaded Lua.
local X={markers={},scan=nil,clock=0,fallReturn=false,towerPoint=nil,lastReturn=0,doorItems={}}
N.MorePlaces=X
N.games.doors={name="NEBULA DOORS",place=6516141723,universe=2440500124}
N.games.toh={name="NEBULA Tower of Hell",place=1962086868,universe=703124385}
function X.clearMarkers()for _,m in ipairs(X.markers)do destroy(m.label);destroy(m.highlight)end;X.markers={}end
function X.addMarker(part,title)
    if #X.markers>=64 then return end
    local label=text(overlay,title,nil,UDim2.fromOffset(240,30),Enum.Font.GothamMedium,Color3.fromRGB(184,153,255));label.TextXAlignment=Enum.TextXAlignment.Center
    local h=new("Highlight",{Adornee=part,FillTransparency=0.9,Enabled=false,OutlineColor=Color3.fromRGB(184,153,255)},owned)
    X.markers[#X.markers+1]={part=part,label=label,highlight=h,title=title}
end
function X.rooms()
    N.requireGame("doors");local rooms=workspace:FindFirstChild("CurrentRooms");assert(rooms,"CurrentRooms не загружены: войди в игровой этаж");return rooms
end
function X.currentDoor()
    local rooms=X.rooms();local data=H.remotePath("GameData","LatestRoom")
    assert(data and type(data.Value)=="number","GameData/LatestRoom недоступен")
    local room=rooms:FindFirstChild(tostring(data.Value));local model=room and room:FindFirstChild("Door");local part=model and (model:FindFirstChild("Door")or G.objectPart(model))
    assert(part and part:IsA("BasePart"),"Дверь текущей комнаты не загружена");return model,part,data.Value
end
function X.doorScan()
    local rooms=X.rooms();X.clearMarkers();X.doorItems={};X.scan={queue={rooms},index=1,count=0,seen={}}
    A.status("DOORS: поиск загруженных ключей, книг, рычагов и шкафов…")
end
function X.doorScanStep()
    local scan=X.scan;if not scan then return end
    local names={KeyObtain="Ключ",ElectricalKeyObtain="Электроключ",LiveHintBook="Книга",LeverForGate="Рычаг",LiveBreakerPolePickup="Предохранитель",Wardrobe="Шкаф"}
    for _=1,100 do
        local obj=scan.queue[scan.index]
        if not obj or scan.count>=12000 then X.scan=nil;A.status("DOORS: найдено "..#X.doorItems.." объектов");return end
        scan.queue[scan.index]=false;scan.index=scan.index+1;scan.count=scan.count+1
        local title=names[obj.Name]
        if title then local part=G.objectPart(obj);if part and not scan.seen[part]then
            scan.seen[part]=true;X.doorItems[#X.doorItems+1]={object=obj,part=part,title=title};X.addMarker(part,title)
        end end
        for _,child in ipairs(obj:GetChildren())do if #scan.queue<12000 then scan.queue[#scan.queue+1]=child end end
    end
end
function X.closestDoorItem(kind)
    N.requireGame("doors");local r=rootOf(me);assert(r,"Персонаж не готов");local best,d
    for _,e in ipairs(X.doorItems)do if e.part:IsDescendantOf(workspace)and (not kind or e.object.Name==kind)then local distance=(e.part.Position-r.Position).Magnitude;if not d or distance<d then best=e;d=distance end end end
    assert(best,"Объект не найден: обнови список");return best
end
function X.goDoorItem(kind)local e=X.closestDoorItem(kind);A.Teleport(CFrame.new(e.part.Position+Vector3.new(0,2,0)))end
function X.interactKey()
    local e=X.closestDoorItem("KeyObtain");local prompt=e.object:FindFirstChild("ModulePrompt",true)
    assert(prompt and prompt:IsA("ProximityPrompt"),"ModulePrompt ключа не найден")
    assert(type(fireproximityprompt)=="function","Исполнитель не предоставляет fireproximityprompt")
    assert((rootOf(me).Position-e.part.Position).Magnitude<=(prompt.MaxActivationDistance or 10)+0.5,"Подойди к ключу")
    fireproximityprompt(prompt);A.status("DOORS: отправлено взаимодействие с ключом; результат определяет сервер")
end
function X.openDoor()
    local model,part=X.currentDoor();local r=rootOf(me);assert(r and (r.Position-part.Position).Magnitude<=12,"Подойди к текущей двери")
    local remote=model:FindFirstChild("ClientOpen");assert(remote and remote:IsA("RemoteEvent"),"Door/ClientOpen не найден")
    remote:FireServer();A.status("DOORS: запрос открытия отправлен; закрытая дверь может требовать ключ")
end
function X.tower()
    N.requireGame("toh");local tower=workspace:FindFirstChild("tower");local sections=tower and tower:FindFirstChild("sections");assert(sections,"tower/sections не загружены");return sections
end
function X.finish()
    local finish=X.tower():FindFirstChild("finish");local part=finish and finish:FindFirstChild("FinishGlow",true)
    assert(part and part:IsA("BasePart"),"finish/FinishGlow не найден");return part
end
function X.towerStages()
    local sections=X.tower();local result={}
    for _,section in ipairs(sections:GetChildren())do if section.Name~="start"and section.Name~="finish"then
        local start=section:FindFirstChild("start",true);local part=start and G.objectPart(start)
        if part then result[#result+1]={part=part,name=section.Name}end
    end end
    table.sort(result,function(a,b)return a.part.Position.Y<b.part.Position.Y end);return result
end
function X.nextStage()
    local r=rootOf(me);assert(r,"Персонаж не готов")
    for _,e in ipairs(X.towerStages())do if e.part.Position.Y>r.Position.Y+2 then A.Teleport(CFrame.new(e.part.Position+Vector3.new(0,3,0)));return end end
    error("Вход следующего загруженного этапа не найден")
end
function X.markTower()
    local stages=X.towerStages();local finish=X.finish();X.clearMarkers();for i,e in ipairs(stages)do X.addMarker(e.part,"Этап "..i.." · "..e.name)end;X.addMarker(finish,"Финиш")
    A.status("Tower: отмечено этапов "..#stages)
end
function X.saveTower()
    X.tower();local r=rootOf(me);assert(r,"Персонаж не готов");X.towerPoint={cf=r.CFrame,character=me.Character};A.status("Tower: личная точка записана")
end
function X.returnTower()
    N.requireGame("toh");assert(X.towerPoint and X.towerPoint.character==me.Character,"Сначала сохрани точку для текущего персонажа");A.Teleport(X.towerPoint.cf)
end
function X.step(dt)
    X.doorScanStep();X.clock=X.clock+dt
    if X.clock<0.5 then return end;X.clock=0;X.returnCooldown=math.max(0,(X.returnCooldown or 0)-0.5)
    if X.fallReturn and N.match("toh")and X.towerPoint and X.towerPoint.character==me.Character and not N.job and not G.runner and not A.scenario and not A.fling and not A.hidden and not S.fly then
        local r,h=rootOf(me),humOf(me)
        if r and h and h.Health>0 and r.Position.Y<X.towerPoint.cf.Position.Y-25 then
            if (X.returnCooldown or 0)<=0 then X.returnCooldown=3;X.returnTower()end
        else X.lastReturn=0 end
    end
end
function X.render()
    local cam=workspace.CurrentCamera
    for _,m in ipairs(X.markers)do local visible=not S.silent and cam~=nil and m.part:IsDescendantOf(workspace)
        m.label.Visible=false;m.highlight.Enabled=visible
        if visible then local p,onScreen=cam:WorldToViewportPoint(m.part.Position);if onScreen and p.Z>0 then m.label.Visible=true;m.label.Position=UDim2.fromOffset(p.X-120,p.Y-24)end end
    end
end
function X.cleanup()X.scan=nil;X.clearMarkers();X.doorItems={};X.fallReturn=false;X.towerPoint=nil;if X.fallToggle then X.fallToggle.Text="Tower · возврат при падении: выкл"end end

function A.Set(key,value)
    assert(A.alive,"Хаб выгружен")
    assert(S[key]~=nil,"Неизвестный параметр: "..tostring(key))
    local movement=false;for _,k in ipairs(A.movementKeys)do if key==k then movement=true;break end end
    if movement and A.Native and A.Native.job then A.Native.stop("Свой модуль отменён сменой движения")end
    if movement and A.Games and A.Games.runner then A.Games.stopRoute("Маршрут отменён сменой движения")end
    if movement and A.hidden then A.hideStop(true,true)end
    if key=="underground"then
        assert(type(value)=="boolean","Нужно on/off")
        if value then A.hideStart()else A.hideStop(true,true)end
        if A.widgets.underground then A.widgets.underground()end
        return
    end
    if movement and A.scenario then A.stopScenario(true,"Сценарий остановлен сменой режима движения")end
    if movement and A.fling then A.stopFling(true)end
    if key=="respawnPoint"and value then assert(A.spawnPoint,"Сначала укажи точку здесь")end
    if key=="boxMode"then assert(value==1 or value==2 or value==3,"Тип рамки: 1, 2 или 3")end
    if type(S[key])=="boolean"then assert(type(value)=="boolean","Нужно on/off")
    elseif ranges[key]then assert(finite(value),"Нужно конечное число");value=math.clamp(value,ranges[key][1],ranges[key][2])end
    if (key=="spectate"or key=="follow"or key=="orbit")and value then assert(A.selected and A.selected~=me,"Выбери другого игрока")end
    S[key]=value
    if key=="photoBuildSpeed"then H.setPhotoSpeed(value)end
    if key=="silent"then A.setSilent(value)end
    if key=="autoRotateOff"and not value then A.release(humOf(me),"AutoRotate")end
    if value and (key=="neonBody"or key=="glassBody")then S.neonBody=key=="neonBody";S.glassBody=key=="glassBody"end
    if value and (key=="blackBody"or key=="rainbowBody")then S.blackBody=key=="blackBody";S.rainbowBody=key=="rainbowBody"end
    local exclusive={"fly","hover","spin","freeze","headstand","ragdoll","orbit"}
    if value==true then for _,k in ipairs(exclusive)do if key==k then for _,other in ipairs(exclusive)do if other~=key then S[other]=false end end end end end
    if key=="orbit"and value then S.follow=false;S.autoWalk=false end
    for _,k in ipairs(exclusive)do if A.widgets[k]then A.widgets[k]()end end
    if key=="respawnPoint"and not value then A.pendingSpawn=nil end
    if key=="xray"or key=="xrayAlpha"then
        for obj,props in pairs(A.props)do if props.LocalTransparencyModifier then A.release(obj,"LocalTransparencyModifier")end end
        A.xrayQueue={workspace};A.xraySeen={}
    end
    for _,k in ipairs({key,"fly","hover","spin","freeze","neonBody","glassBody","blackBody","rainbowBody"})do if A.widgets[k]then A.widgets[k]()end end
    A.motion(0);A.cameraStep();A.worldStep()
    if key=="follow"and not value then local h=humOf(me);local r=rootOf(me);if h and r then h:MoveTo(r.Position)end end
    if key=="stats"then stats.Visible=value end
end
function A.reset()
    if A.Native then A.Native.cleanup()end
    if A.Games then A.Games.cleanup()end
    A.hideStop(true,false)
    A.setSilent(false);A.clearSelfFX()
    A.stopScenario(false);A.stopFling(false);A.clearTrollRig();A.pendingSpawn=nil
    for _,key in ipairs({"underground","silent","invisible","neonBody","blackBody","glassBody","outlineSelf","bodyLight","bodyTrail","hideTag","hideAccessories","autoRotateOff","orbit","headstand","ragdoll","bhop","ghost","rainbowBody","respawnPoint","esp","speed","jump","sprint","infJump","noclip","fly","hover","follow","freeze","sit","autoWalk","spin","clickTP","spectate","fov","zoom","fullbright","noFog","noPost","xray","stats"})do S[key]=false end
    if A.tpTween then A.tpTween:Cancel();A.tpTween=nil end
    local h=humOf(me);local r=rootOf(me);if h then h:Move(Vector3.new(),true);if r then h:MoveTo(r.Position)end end
    A.destroyMotion();A.restoreAll();A.cameraStep();A.xrayQueue={};A.xraySeen={};A.hadNoclip=false;A.hadAutoWalk=false
    for _,fn in pairs(A.widgets)do fn()end;stats.Visible=false;A.status("Все модули выключены; свойства восстановлены")
end
function A.Unload()
    if not A.alive then return end
    A.reset();A.alive=false
    R:UnbindFromRenderStep("NEBULA_ControlESP")
    R:UnbindFromRenderStep("NEBULA_MM2Aim")
    disconnect(A.connections);disconnect(A.characterConnections)
    if A.listConnections then disconnect(A.listConnections)end
    if A.planConnections then disconnect(A.planConnections)end
    for _,list in pairs(A.playerConnections)do disconnect(list)end
    destroy(owned);destroy(gui)
    if env.__NEBULA_CONTROL==A then env.__NEBULA_CONTROL=nil end
    if type(A.OnUnload)=="function"then pcall(A.OnUnload)end
end
local function espEntry(pl)
    if A.esp[pl]then return A.esp[pl]end
    local frame=new("Frame",{Name="ESP_"..pl.Name,BackgroundTransparency=1,Visible=false,BorderSizePixel=0},overlay)
    local stroke=new("UIStroke",{Color=white,Thickness=1,Transparency=0.1},frame)
    local shadow=new("UIStroke",{Color=Color3.new(0,0,0),Thickness=3,Transparency=0.15},frame)
    local edges,corners={},{}
    for n=1,12 do edges[n]=new("Frame",{Name="ESP3DEdge",AnchorPoint=Vector2.new(0,0.5),BackgroundColor3=white,BorderSizePixel=0,Visible=false},overlay)end
    for n=1,8 do corners[n]=new("Frame",{Name="ESPCorner",BackgroundColor3=white,BorderSizePixel=0,Visible=false},frame)end
    local arrow=text(overlay,"▲",nil,UDim2.fromOffset(22,22),Enum.Font.GothamBold);arrow.Name="ESPOffscreen";arrow.Visible=false
    local label=text(overlay,"",nil,UDim2.fromOffset(230,42),Enum.Font.GothamMedium);label.Name="ESPTag_"..pl.Name;label.TextXAlignment=Enum.TextXAlignment.Center;label.TextYAlignment=Enum.TextYAlignment.Bottom;label.Visible=false
    local healthBack=new("Frame",{Size=UDim2.new(0,3,1,0),Position=UDim2.fromOffset(-7,0),BackgroundColor3=Color3.fromRGB(35,35,35),BorderSizePixel=0},frame)
    local healthFill=new("Frame",{AnchorPoint=Vector2.new(0,1),Position=UDim2.fromScale(0,1),Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(130,230,170),BorderSizePixel=0},healthBack)
    local tracer=new("Frame",{Name="Tracer",AnchorPoint=Vector2.new(0,0.5),BackgroundColor3=white,BorderSizePixel=0,Visible=false},overlay)
    local highlight=new("Highlight",{Name="NEBULA_ESP",Enabled=false,DepthMode=Enum.HighlightDepthMode.AlwaysOnTop,FillTransparency=0.85,OutlineTransparency=0.1,FillColor=white,OutlineColor=white},owned)
    local entry={edges=edges,corners=corners,arrow=arrow,shadow=shadow,box=frame,stroke=stroke,label=label,healthBack=healthBack,healthFill=healthFill,tracer=tracer,highlight=highlight};A.esp[pl]=entry;return entry
end
function A.removeESP(pl)local e=A.esp[pl];if e then for _,edge in ipairs(e.edges)do destroy(edge)end;destroy(e.arrow);destroy(e.box);destroy(e.label);destroy(e.tracer);destroy(e.highlight);A.esp[pl]=nil end end
function A.espStep()
    local cam=workspace.CurrentCamera;local selfRoot=rootOf(me)
    for pl,e in pairs(A.esp)do
        local r,h=rootOf(pl),humOf(pl);local distance=r and selfRoot and (r.Position-selfRoot.Position).Magnitude or math.huge
        local enabled=not S.silent and S.esp and not e.removing and cam and r and h and h.Health>0 and distance<=S.espRange
        if S.teamFilter and me.Team~=nil and pl.Team==me.Team then enabled=false end
        if S.selectedOnly and pl~=A.selected then enabled=false end
        if enabled and S.visibleOnly then
            local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={me.Character,owned}
            local hit=workspace:Raycast(cam.CFrame.Position,r.Position-cam.CFrame.Position,params)
            if hit and hit.Instance and not hit.Instance:IsDescendantOf(pl.Character)then enabled=false end
        end
        e.highlight.Enabled=enabled and S.throughWalls or false;e.highlight.Adornee=pl.Character
        local color=S.teamColors and pl.TeamColor and pl.TeamColor.Color or Color3.fromHSV(S.espHue,0.35,1)
        e.highlight.FillColor=color;e.highlight.OutlineColor=color;e.stroke.Color=color;e.tracer.BackgroundColor3=color
        e.box.Visible=false;e.label.Visible=false;e.tracer.Visible=false;e.arrow.Visible=false;e.onScreen=false
        for _,edge in ipairs(e.edges)do edge.Visible=false end
        for _,corner in ipairs(e.corners)do corner.Visible=false end
        if enabled then
            local cf,size=pl.Character:GetBoundingBox();local minX,minY,maxX,maxY=math.huge,math.huge,-math.huge,-math.huge;local inFront=true;local projected={}
            for _,x in ipairs({-1,1})do for _,y in ipairs({-1,1})do for _,z in ipairs({-1,1})do
                local point=cam:WorldToViewportPoint((cf*CFrame.new(x*size.X/2,y*size.Y/2,z*size.Z/2)).Position)
                projected[#projected+1]=point
                if point.Z<=0 then inFront=false end
                minX=math.min(minX,point.X);maxX=math.max(maxX,point.X);minY=math.min(minY,point.Y);maxY=math.max(maxY,point.Y)
            end end end
            if inFront and maxX>=0 and minX<=cam.ViewportSize.X and maxY>=0 and minY<=cam.ViewportSize.Y then
                e.onScreen=true
                e.box.Position=UDim2.fromOffset(minX,minY);e.box.Size=UDim2.fromOffset(math.max(1,maxX-minX),math.max(1,maxY-minY));e.box.Visible=S.boxes and S.boxMode~=2 or S.health
                e.stroke.Enabled=S.boxes and S.boxMode==1;e.shadow.Enabled=e.stroke.Enabled;e.stroke.Thickness=S.espThickness;e.shadow.Thickness=S.espThickness+2
                if S.boxes and S.boxMode==2 then
                    for n,pair in ipairs({{1,2},{1,3},{1,5},{2,4},{2,6},{3,4},{3,7},{4,8},{5,6},{5,7},{6,8},{7,8}})do
                        local a,b=projected[pair[1]],projected[pair[2]];local d=Vector2.new(b.X-a.X,b.Y-a.Y);local line=e.edges[n]
                        line.Position=UDim2.fromOffset(a.X,a.Y);line.Size=UDim2.fromOffset(d.Magnitude,S.espThickness);line.Rotation=math.deg(math.atan2(d.Y,d.X));line.BackgroundColor3=color;line.Visible=true
                    end
                elseif S.boxes and S.boxMode==3 then
                    local w,h=maxX-minX,maxY-minY;local length=math.min(w,h)*0.22
                    for n,line in ipairs(e.corners)do local k=math.floor((n-1)/2);local horizontal=n%2==1;local right=k%2==1;local bottom=k>=2
                        local lw,lh=horizontal and length or S.espThickness,horizontal and S.espThickness or length
                        line.Size=UDim2.fromOffset(lw,lh);line.Position=UDim2.fromOffset(right and w-lw or 0,bottom and h-lh or 0);line.BackgroundColor3=color;line.Visible=true
                    end
                end
                e.healthBack.Visible=S.health;e.healthFill.Size=UDim2.fromScale(1,math.clamp(h.Health/math.max(1,h.MaxHealth),0,1))
                local pieces={};if S.names then pieces[#pieces+1]=pl.DisplayName.." (@"..pl.Name..")"end
                local detail={};if S.health then detail[#detail+1]=math.floor(h.Health+0.5).." HP"end;if S.distance then detail[#detail+1]=math.floor(distance).." studs"end
                if #detail>0 then pieces[#pieces+1]=table.concat(detail,"  ·  ")end
                local intel=N.playerIntel(pl);if #intel>0 then pieces[#pieces+1]=intel end
                if G.toolTags then local tools=G.toolInfo(pl);if #tools>0 then pieces[#pieces+1]="Tool: "..tools end end
                local labelHeight=math.max(42,S.espSize*2+6)
                e.label.Size=UDim2.fromOffset(230,labelHeight);e.label.Text=table.concat(pieces,"\n");e.label.TextSize=S.espSize;e.label.TextColor3=color;e.label.Position=UDim2.fromOffset((minX+maxX)/2-115,minY-labelHeight-4);e.label.Visible=#pieces>0
                if S.tracers then
                    local start=Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y-10);local finish=Vector2.new((minX+maxX)/2,maxY);local d=finish-start
                    e.tracer.Position=UDim2.fromOffset(start.X,start.Y);e.tracer.Size=UDim2.fromOffset(d.Magnitude,1);e.tracer.Rotation=math.deg(math.atan2(d.Y,d.X));e.tracer.Visible=true
                end
            end
            if S.offscreen and not e.onScreen then
                local center=cam:WorldToViewportPoint(r.Position);local dx,dy=center.X-cam.ViewportSize.X/2,center.Y-cam.ViewportSize.Y/2
                if center.Z<=0 then dx=-dx;dy=-dy end
                if math.abs(dx)+math.abs(dy)<0.01 then dy=-1 end
                local factor=math.min((cam.ViewportSize.X/2-30)/math.max(math.abs(dx),0.001),(cam.ViewportSize.Y/2-30)/math.max(math.abs(dy),0.001))
                e.arrow.Position=UDim2.fromOffset(cam.ViewportSize.X/2+dx*factor-11,cam.ViewportSize.Y/2+dy*factor-11);e.arrow.Rotation=math.deg(math.atan2(dy,dx))+90;e.arrow.TextColor3=color;e.arrow.Visible=true
            end
        end
    end
end
local gamePage=page("Маршруты","Профили с точками, маршрутами и поиском объектов. Обнаружение игры не включает функции. Совпадение имени объекта не подтверждает его назначение.")
local rail=new("ScrollingFrame",{Name="GameSubtabs",Size=UDim2.new(1,0,0,42),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=2,AutomaticCanvasSize=Enum.AutomaticSize.X,CanvasSize=UDim2.new()},gamePage);A.place(gamePage,rail)
new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder},rail)
G.tabs={};G.panels={};G.details={};G.resultConnections={}
local detected=G.detect()
local detection=text(gamePage,"Определено: "..G.profile(detected).name.." · PlaceId "..tostring(game.PlaceId or "?").." · UniverseId "..tostring(game.GameId or "?"),nil,UDim2.new(1,0,0,35));detection.TextWrapped=true;A.place(gamePage,detection)
action(gamePage,"Открыть профиль текущей игры",function()G.select(G.detect())end)
action(gamePage,"Остановить маршрут и убрать маркеры",function()G.stopRoute();G.cancelScan();G.clearMarkers()end)
for order,profile in ipairs(G.profiles)do
    local id=profile.id
    local function profileAction(parent,title,fn,description)
        return action(parent,title,function()if G.selected~=id then G.select(id)end;fn()end,description)
    end
    local tab=button(rail,profile.name,nil,UDim2.fromOffset(id=="vd"and 160 or 125,34));tab.LayoutOrder=order;tab.Name="GameSubtab_"..id;G.tabs[id]=tab
    on(tab.Activated,function()G.select(id)end)
    local body=new("Frame",{Name="GameProfile_"..id,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Visible=false},gamePage);A.place(gamePage,body);G.panels[id]=body
    new("UIListLayout",{Padding=UDim.new(0,7),SortOrder=Enum.SortOrder.LayoutOrder},body)
    local detail=text(body,"",nil,UDim2.new(1,0,0,48),nil,Color3.fromRGB(155,155,155));detail.TextWrapped=true;A.place(body,detail);G.details[id]=detail
    local point=input(body,"GamePoint_"..id,"Имя точки: база / выход / удобная позиция")
    profileAction(body,"Сохранить точку · "..profile.name,function()G.savePoint(point.Text)end,"Записать текущую позицию только в этом профиле")
    profileAction(body,"TP к точке · "..profile.name,function()G.goPoint(point.Text)end)
    profileAction(body,"Удалить точку · "..profile.name,function()local session=G.sessions[id];assert(session.points[fold(point.Text)],"Точка не найдена");session.points[fold(point.Text)]=nil;G.refresh()end)
    profileAction(body,"Список точек · "..profile.name,function()local list={};for _,entry in pairs(G.sessions[id].points)do list[#list+1]=entry.name end;table.sort(list);A.status(#list>0 and table.concat(list,", ")or "Точек ещё нет")end)
    profileAction(body,"Записать точку маршрута · "..profile.name,G.recordRoute,"Встань на следующую точку и нажми. До 200 точек.")
    profileAction(body,"Убрать последнюю точку маршрута · "..profile.name,function()assert(not G.runner,"Сначала останови маршрут");table.remove(G.sessions[id].route);G.refresh()end)
    profileAction(body,"Очистить маршрут · "..profile.name,function()G.stopRoute();G.sessions[id].route={};G.refresh()end)
    local mode=profileAction(body,"Маршрут: идти · переключить",function()G.routeMode=G.routeMode=="walk"and "tp"or "walk";G.refresh()end);G.tabs["mode_"..id]=mode
    local loops=input(body,"RouteLoops_"..id,"Повторы маршрута: 0 = бесконечно");loops.Text="1"
    local delay=input(body,"RouteDelay_"..id,"Пауза между TP: 0.1–60 секунд");delay.Text="1"
    profileAction(body,"Запустить маршрут · "..profile.name,function()
        local n=tonumber(loops.Text);local d=tonumber(delay.Text)
        assert(finite(n)and n>=0 and n%1==0,"Повторы: целое число >= 0")
        assert(finite(d)and d>=0.1 and d<=60,"Пауза: 0.1–60 секунд")
        G.routeLoops=n;G.routeDelay=d;G.startRoute()
    end,"Персонаж проходит записанные точки или перемещается TP. Сервер может отклонять перемещения.")
    profileAction(body,"Стоп маршрут · "..profile.name,G.stopRoute)
    for _,filter in ipairs(profile.filters)do
        profileAction(body,"Найти: "..filter[1].." · "..profile.name,function()G.scanStart(filter[2])end,"Поиск по названиям: "..filter[2])
    end
    local custom=input(body,"ObjectQuery_"..id,"Свой поиск по имени: generator,exit,checkpoint")
    profileAction(body,"Искать своё · "..profile.name,function()G.scanStart(custom.Text)end)
    profileAction(body,"Показать найденное · "..profile.name,G.showMarkers,"До 64 маркеров загруженных объектов")
    profileAction(body,"Убрать маркеры · "..profile.name,G.clearMarkers)
    profileAction(body,"TP к ближайшему найденному · "..profile.name,function()G.gotoResult(G.closest())end)
    profileAction(body,"Записать ближайший объект в точки · "..profile.name,function()local entry=G.closest();G.sessions[id].points[fold(entry.name)]={name=entry.name,cf=CFrame.new(entry.part.Position+Vector3.new(0,4,0))};G.refresh()end)
    if id=="mm2"then
        profileAction(body,"MM2 · найденные инструменты игроков",G.toolSummary,"Knife/Gun перечисляются только если они реально доступны клиенту. Роль не угадывается.")
        profileAction(body,"MM2 · инструменты в ESP: вкл/выкл",function()G.toolTags=not G.toolTags;A.status("Инструменты в ESP: "..tostring(G.toolTags))end)
    elseif id=="boat"then
        profileAction(body,"Build a Boat · сохранить старт",function()G.savePoint("Старт")end)
        profileAction(body,"Build a Boat · вернуться на старт",function()G.goPoint("Старт")end)
    elseif id=="vd"or id=="evade"then
        profileAction(body,profile.name.." · выбрать ближайшего игрока",function()local pl,err=A.findPlayer("nearest");assert(pl,err);A.SelectPlayer(pl);A.status("Выбран ближайший: "..pl.Name)end)
        profileAction(body,profile.name.." · наблюдать выбранного",function()A.Set("spectate",true)end)
    elseif id=="arsenal"then
        profileAction(body,"Arsenal · прицел: вкл/выкл",function()G.crosshair=not G.crosshair;G.render()end)
        profileAction(body,"Arsenal · рамки 2D и HP",function()A.Set("boxMode",1);A.Set("boxes",true);A.Set("names",true);A.Set("health",true);A.Set("esp",true)end)
    elseif id=="doors"then
        profileAction(body,"DOORS · сохранить текущую комнату",function()G.savePoint("Комната")end)
        profileAction(body,"DOORS · вернуться к комнате",function()G.goPoint("Комната")end)
    end
    profileAction(body,"Открыть ESP · "..profile.name,function()A.switchPage("ESP")end)
    profileAction(body,"Открыть сценарии · "..profile.name,function()A.switchPage("Сценарии")end)
end
G.cross=new("Frame",{Name="GameCrosshair",AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(20,20),BackgroundTransparency=1,Visible=false},gui)
new("Frame",{Position=UDim2.fromOffset(0,9),Size=UDim2.fromOffset(20,2),BackgroundColor3=white,BorderSizePixel=0},G.cross)
new("Frame",{Position=UDim2.fromOffset(9,0),Size=UDim2.fromOffset(2,20),BackgroundColor3=white,BorderSizePixel=0},G.cross)
local resultsPanel=new("Frame",{Name="GameObjectResults",Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},gamePage);A.place(gamePage,resultsPanel)
new("UIListLayout",{Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder},resultsPanel)
function G.refreshResults()
    disconnect(G.resultConnections)
    for _,child in ipairs(resultsPanel:GetChildren())do if child:IsA("GuiObject")then destroy(child)end end
    for i,entry in ipairs(G.results)do if i<=100 then
        local b=button(resultsPanel,string.format("%02d · %s · TP",i,entry.name));b.LayoutOrder=i
        on(b.Activated,function()local ok,err=pcall(G.gotoResult,entry);if not ok then A.status(err)end end,G.resultConnections)
    end end
end
function G.refresh()
    for _,profile in ipairs(G.profiles)do
        local id=profile.id;local active=id==G.selected
        G.panels[id].Visible=active;G.tabs[id].BackgroundColor3=active and Color3.fromRGB(33,33,33)or Color3.fromRGB(10,10,10)
        local count=0;for _ in pairs(G.sessions[id].points)do count=count+1 end
        G.details[id].Text=profile.name.." · точек "..count.." · маршрут "..#G.sessions[id].route.."\n"..(detected==id and "Игра совпадает по ID."or "Ручной профиль; текущая игра отличается или не определена.")
        G.tabs["mode_"..id].Text=G.routeMode=="walk"and "Маршрут: идти · переключить"or "Маршрут: TP · переключить"
    end
    G.refreshResults()
end
G.select(detected)


local nativePage=page("Свои скрипты","NEBULA Boat / MM2 / District — собственные модули без HTTP-загрузок. Серверные результаты не гарантируются; текущие карты в игре не проверены.")
local nativeRail=new("Frame",{Name="NativeSubtabs",Size=UDim2.new(1,0,0,38),BackgroundTransparency=1},nativePage);A.place(nativePage,nativeRail)
new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,5)},nativeRail)
N.tabs={};N.panels={};N.widgets={};N.statusLabels={}
function N.select(id)
    assert(N.games[id],"Свой модуль не найден")
    if N.selected~=id then N.stop("Свой модуль остановлен сменой вкладки")end
    N.selected=id;if N.refresh then N.refresh()end
end
for _,id in ipairs({"boat","mm2","vd"})do
    local gameId=id;local info=N.games[id]
    local tab=button(nativeRail,info.name,nil,UDim2.fromOffset(160,34));tab.Name="NativeSubtab_"..id;N.tabs[id]=tab
    on(tab.Activated,function()N.select(gameId)end)
    local body=new("Frame",{Name="NativeModule_"..id,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Visible=false},nativePage);A.place(nativePage,body);N.panels[id]=body
    new("UIListLayout",{Padding=UDim.new(0,7),SortOrder=Enum.SortOrder.LayoutOrder},body)
    local desc=text(body,"",nil,UDim2.new(1,0,0,48),nil,Color3.fromRGB(155,155,155));desc.TextWrapped=true;A.place(body,desc);N.statusLabels[id]=desc
    local function nativeAction(title,fn,description)
        return action(body,title,function()N.select(gameId);fn()end,description)
    end
    local function nativeToggle(key,title)
        local b=nativeAction(title,function()N.setFlag(key,not N.flags[key])end)
        N.widgets[key]=function()b.Text=title..(N.flags[key]and " · ВКЛ"or " · выкл")end;N.widgets[key]()
    end
    if id=="boat"then
        local delay=input(body,"NativeBoatDelay","Пауза между этапами: 0.5–15 секунд");delay.Text="1.5"
        local loops=input(body,"NativeBoatLoops","Проходы: 1–10000 или 0 = бесконечно");loops.Text="1"
        nativeAction("Boat · начать проход до сундука",function()
            local d,n=tonumber(delay.Text),tonumber(loops.Text);assert(finite(d)and d>=0.5 and d<=15,"Пауза: 0.5–15 секунд");assert(finite(n)and n>=0 and n<=10000 and n%1==0,"Проходы: целое 0–10000")
            N.delay=d;N.loops=n;N.startBoat()
        end,"Находит CaveStage/DarknessPart и GoldenChest/Trigger. При повторе ждёт реальное возрождение.")
        nativeToggle("boatMarkers","Boat · маркеры этапов и сундука")
        nativeAction("Boat · сохранить свою базу",function()N.requireGame("boat");G.select("boat");G.savePoint("NEBULA База")end)
        nativeAction("Boat · вернуться на свою базу",function()N.requireGame("boat");G.select("boat");G.goPoint("NEBULA База")end)
        nativeAction("Boat · проверить структуру этапов",function()N.requireGame("boat");local targets=N.boatTargets();A.status("Найдено этапов: "..(#targets-1).."; триггер сундука загружен")end)
    elseif id=="mm2"then
        nativeToggle("mm2Roles","MM2 · обнаруженное оружие в ESP")
        nativeToggle("mm2Gun","MM2 · отслеживать выпавший GunDrop")
        nativeAction("MM2 · TP к выпавшему пистолету",function()N.goWeapon("drop")end)
        nativeAction("MM2 · TP к обнаруженному Knife",function()N.goWeapon("Knife")end)
        nativeAction("MM2 · TP к обнаруженному Gun",function()N.goWeapon("Gun")end)
        nativeAction("MM2 · наблюдать владельца Knife",function()N.requireGame("mm2");local pl=N.weaponOwner("Knife");assert(pl,"Knife не обнаружен");A.SelectPlayer(pl);A.Set("spectate",true)end)
        local delay=input(body,"NativeCoinDelay","Пауза посещения монет: 0.5–10 секунд");delay.Text="1"
        nativeAction("MM2 · начать посещение монет",function()local d=tonumber(delay.Text);assert(finite(d)and d>=0.5 and d<=10,"Пауза: 0.5–10 секунд");N.delay=d;N.startCoins()end,"Посещает ближайшие загруженные Coin_Server. Не рисует фальшивый баланс и не обещает сбор сервером.")
        nativeAction("MM2 · показать доступное оружие игроков",function()N.requireGame("mm2");G.toolSummary()end)
    else
        nativeToggle("vdGenerators","District · генераторы, прогресс и ремонтирующие")
        nativeToggle("vdGates","District · выходы и рычаги")
        nativeToggle("vdPlayers","District · команды, Knocked и IsHooked в ESP")
        nativeAction("District · обновить объекты карты",N.scanDistrict)
        nativeAction("District · TP к ближайшему незавершённому генератору",N.closestGenerator)
        nativeAction("District · TP к ближайшему выходу",N.goGate)
        nativeAction("District · выбрать игрока на крюке",function()
            N.requireGame("vd");for _,pl in ipairs(P:GetPlayers())do if N.attr(pl.Character,"IsHooked")then A.SelectPlayer(pl);A.status("Выбран: "..pl.Name);return end end;error("IsHooked не обнаружен у доступных игроков")
        end)
        nativeAction("District · наблюдать выбранного",function()N.requireGame("vd");A.Set("spectate",true)end)
    end
    nativeAction("Остановить свой модуль · "..info.name,function()N.stop()end)
    nativeAction("Выключить все свои функции · "..info.name,N.cleanup)
end
function N.refresh()
    for id,body in pairs(N.panels)do
        body.Visible=id==N.selected;N.tabs[id].BackgroundColor3=id==N.selected and Color3.fromRGB(33,33,33)or Color3.fromRGB(12,12,12)
        N.statusLabels[id].Text=N.games[id].name.." · "..(N.match(id)and "ID игры совпадает"or "текущая игра отличается").."\n"..(N.job and ("Цикл: "..N.job.kind.." · этап "..N.job.index.." · проходов "..N.job.completed)or "Цикл остановлен")
    end
    for _,update in pairs(N.widgets)do update()end
end
for _,id in ipairs({"boat","mm2","vd"})do if N.match(id)then N.selected=id;break end end
N.refresh()

-- Helper controls live in their own module panels.
H.widgets={}
local function helperToggle(id,key,title)
    local b=action(N.panels[id],title,function()N.select(id);H.setFlag(key,not H.flags[key])end)
    H.widgets[key]=function()b.Text=title..(H.flags[key]and " · ВКЛ"or " · выкл")end;H.widgets[key]()
end
helperToggle("mm2","autoGun","MM2 · хелпер подбора GunDrop · одна попытка")
helperToggle("mm2","knifeHelper","MM2 · хелпер Knife рядом · Stab раз в секунду")
helperToggle("vd","repairHelper","District · ремонт ближайшего генератора в радиусе 12")
helperToggle("vd","skillHelper","District · запрос успешного skillcheck при ремонте")
action(N.panels.vd,"District · пройти обнаруженные генераторы",function()N.select("vd");H.startDistrict()end,"Проверяет RepairProgress; 10 секунд без серверного прогресса останавливают цикл")
action(N.panels.boat,"Boat · помощник прохождения · повторять",function()N.select("boat");N.loops=0;N.startBoat()end,"Проходы до сундука с ожиданием настоящего возрождения. Серверная победа/награда не гарантируется.")
action(N.panels.boat,"Гараж · 10 спорткаров",function()A.switchPage("Гараж")end,"McLaren Ferrari Porsche Lamborghini колёса подвеска машины")


























-- BEGIN NEBULA GARAGE UI
do
 local C=N.Cars
 local p=page("Гараж","Собственные блоковые модели по мотивам спорткаров. Сборка механики экспериментальная; реальная езда в BABFT пока не проверена.")
 local view=new("ViewportFrame",{Name="GarageView",Size=UDim2.new(1,0,0,300),BackgroundColor3=Color3.fromRGB(13,13,15),BorderSizePixel=0,Ambient=Color3.fromRGB(175,175,185),LightColor=Color3.fromRGB(245,245,255),LightDirection=Vector3.new(-1,-2,-1)},p);A.place(p,view)
 local camera=new("Camera",{FieldOfView=37},view);view.CurrentCamera=camera
 local headline=text(p,"",nil,UDim2.new(1,0,0,30),Enum.Font.GothamBold);headline.TextSize=20;A.place(p,headline)
 local details=text(p,"",nil,UDim2.new(1,0,0,88),nil,Color3.fromRGB(160,160,160));details.TextWrapped=true;A.place(p,details)
 function C.refreshView(draw)
  local plan=C.plan();headline.Text=plan.name
  local bill={};for kind,count in pairs(plan.bill)do bill[#bill+1]=kind.." ×"..count end;table.sort(bill)
  details.Text="По мотивам "..plan.inspired.." · "..#plan.parts.." деталей\n"..plan.livery.." · акценты: "..C.accentPaints[C.accent].name.."\n"..table.concat(bill," · ")
  if draw then
   destroy(C.stage);C.stage=C.previewInto(view,CFrame.new())
   local angle=math.rad(-43+C.turn);camera.CFrame=CFrame.lookAt(Vector3.new(math.cos(angle)*26,11,math.sin(angle)*26),Vector3.new(0,2.5,0))
  end
 end
 for i,d in ipairs(C.catalog)do
  local id=i
  action(p,d.name.." · "..d.inspired,function()assert(not N.job,"Останови сборку перед сменой модели");C.selected=id;C.clearPreview();C.refreshView(true)end,"Выбрать спорткар "..d.inspired)
 end
 action(p,"Показать / повернуть 3D-модель",function()C.turn=C.turn+35;C.refreshView(true)end)
 action(p,"Цвет кузова · сменить",function()assert(not N.job,"Останови сборку перед сменой цвета");C.paint=C.paint%#C.paints+1;C.clearPreview();C.refreshView(true);A.status("Цвет: "..C.paints[C.paint].name)end)
 action(p,"Схема окраски · акценты / полосы / контраст",function()assert(not N.job,"Останови сборку");C.livery=C.livery%#C.liveries+1;C.clearPreview();C.refreshView(true);A.status("Окраска: "..C.liveries[C.livery])end)
 action(p,"Цвет акцентов · сменить отдельно",function()assert(not N.job,"Останови сборку");C.accent=C.accent%#C.accentPaints+1;C.clearPreview();C.refreshView(true);A.status("Акценты: "..C.accentPaints[C.accent].name)end)
 action(p,"Подвеска · мягкая / спорт / трек",function()assert(not N.job,"Останови сборку перед сменой подвески");C.suspension=C.suspension%#C.suspensions+1;local tune=C.suspensions[C.suspension];A.status("Подвеска: "..tune.name.." · жёсткость "..tune.stiffness.." · демпфирование "..tune.damping)end)
 action(p,"Скорость сборки · ×1 / ×2 / ×5 / ×10",function()local value=H.photoSpeed;H.setPhotoSpeed(value<2 and 2 or value<5 and 5 or value<10 and 10 or 1);A.status("Скорость сборки: ×"..H.photoSpeed..". Сервер может отвечать медленнее.")end)
 action(p,"Указать точку постройки перед собой",C.setAnchor)
 action(p,"Показать на участке · локальное превью",C.previewWorld)
 action(p,"Убрать превью с участка",C.clearPreview)
 action(p,"Проверить инструменты и запас деталей",function()local plan=C.check();A.status("Запас достаточен: "..plan.name.." · "..#plan.parts.." деталей. Посадка и езда ещё не проверены.")end)
 action(p,"Собрать выбранную машину · экспериментально",C.start,"Реальные игровые инструменты, свой запас блоков. Постройка остаётся закреплённой. Серверные блоки после KILL не удаляются.")
 action(p,"Проверить последнюю сборку · связи и подвеску",function()A.status(C.audit(C.last))end)
 action(p,"Совок · точное выравнивание закреплённых панелей",C.startAlign,"Проверить и восстановить точные углы и положение своего кузова. Нужен совок; панели должны быть закреплены.")
 action(p,"Снять закрепление последней сборки",C.release,"Экспериментальный запуск после аудита. Проверка связей не доказывает устойчивость подвески или правильность ориентации колёс.")
 action(p,"Замер езды и поворота · 12 секунд",C.startDriveProbe,"Сядь за руль и управляй сам: замер перемещения, поворота, ввода и вращения колёс. Это не автопилот.")
 action(p,"Остановить сборку / запуск / замер",function()C.probe=nil;if N.job and (N.job.kind=="car"or N.job.kind=="carRelease"or N.job.kind=="carAlign")then N.stop("Гараж остановлен. Уже созданные серверные блоки остаются.")end end)
 C.refreshView(false)
 -- Preview is optional: a restricted ViewportFrame must not prevent Control from opening.
 local ok=pcall(C.refreshView,true);if not ok then destroy(C.stage);C.stage=nil end
end
-- END NEBULA GARAGE UI

local photoNote=text(N.panels.boat,"Импорт фото до 200×200: открой NEBULA-Photo-Importer.html. Большую схему переноси через Lua импорта, буфер или JSON-файл, минуя текстовое поле. Клетка 0.1–6 studs; меньше клетка — меньше вся картина, детализацию задают пиксели. Для реальной постройки нужны свои блоки и BuildingTool / PaintingTool / ScalingTool.",nil,UDim2.new(1,0,0,70),nil,Color3.fromRGB(155,155,155));photoNote.TextWrapped=true;A.place(N.panels.boat,photoNote)
slider(N.panels.boat,"photoBuildSpeed","Скорость постройки фото · ×1–×10",1)
action(N.panels.boat,"Фото · импортировать из буфера без текстового поля",H.importPhotoClipboard)
local photoFile=input(N.panels.boat,"NativePhotoFile","Имя JSON в рабочей папке исполнителя, без .json");photoFile.Text="nebula-photo"
action(N.panels.boat,"Фото · импортировать JSON из файла",function()H.importPhotoFile(photoFile.Text)end)
local photoInput=input(N.panels.boat,"NativePhotoJSON","Вставь JSON-схему nebula-photo-1 из импортера");photoInput.MultiLine=true;photoInput.TextYAlignment=Enum.TextYAlignment.Top;photoInput.Size=UDim2.new(1,0,0,100)
action(N.panels.boat,"Фото · импортировать схему",function()N.select("boat");H.importPhoto(photoInput.Text)end)
action(N.panels.boat,"Фото · указать точку перед собой",H.setAnchor)
action(N.panels.boat,"Фото · локальное превью",H.previewPhoto)
action(N.panels.boat,"Фото · убрать превью",H.clearPreview)
action(N.panels.boat,"Фото · проверить инструменты и запас",function()
    N.requireGame("boat");assert(H.photo,"Нет схемы");H.buildTools();assert(H.findZone(),"Зона команды не найдена");local data=me:FindFirstChild("Data");local count=data and data:FindFirstChild(H.photo.material)
    assert(count and type(count.Value)=="number","Материал не найден в Data");A.status(H.photo.material..": нужно "..#H.photo.pixels..", доступно "..count.Value)
end)
action(N.panels.boat,"Фото · построить настоящими блоками",H.startPhoto,"Экспериментальный адаптер инструментов. Созданные сервером блоки остаются после KILL.")
action(N.panels.boat,"Фото · остановить постройку",function()if N.job and N.job.kind=="photo"then N.stop("Постройка фото остановлена; уже созданные блоки остаются")end end)
for _,id in ipairs({"boat","mm2","vd"})do action(N.panels[id],"Остановить все хелперы · "..N.games[id].name,function()H.disable();N.stop("Хелперы и свой цикл остановлены")end)end
function H.refresh()for _,fn in pairs(H.widgets)do fn()end end
H.refresh()

do
local sprayPage=page("Spray Paint","Фото по HTTPS-ссылке → выбранная плоская область. Нужен запущенный NEBULA-Image-Helper.exe. Протокол рисования не проверен в живой игре.")
SP.ui={root=sprayPage,panels={},buttons={}}
SP.ui.rail=new("Frame",{Name="SpraySubtabs",Size=UDim2.new(1,0,0,38),BackgroundTransparency=1},sprayPage);A.place(sprayPage,SP.ui.rail)
new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,5)},SP.ui.rail)
for _,entry in ipairs({{"draw","Рисование"},{"gallery","Галерея"},{"edit","Обработка"},{"projects","Проекты"}})do
    local id,title=entry[1],entry[2]
    local b=button(SP.ui.rail,title,nil,UDim2.fromOffset(135,34));SP.ui.buttons[id]=b
    local body=new("Frame",{Name="SprayPanel_"..id,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Visible=false},sprayPage);A.place(sprayPage,body)
    new("UIListLayout",{Padding=UDim.new(0,7),SortOrder=Enum.SortOrder.LayoutOrder},body);SP.ui.panels[id]=body
    on(b.Activated,function()SP.ui.select(id)end)
end
function SP.ui.select(id)
    for key,body in pairs(SP.ui.panels)do body.Visible=key==id;SP.ui.buttons[key].BackgroundColor3=key==id and Color3.fromRGB(32,32,32)or Color3.fromRGB(12,12,12)end
end
SP.ui.select("draw")
local sprayDraw=SP.ui.panels.draw
local sprayState=text(sprayDraw,"",nil,UDim2.new(1,0,0,66),nil,Color3.fromRGB(170,170,170));sprayState.TextWrapped=true;A.place(sprayDraw,sprayState)
local sprayURL=input(sprayDraw,"SprayPhotoURL","Прямая HTTPS-ссылка на PNG / JPEG / WebP")
local sprayResolution=input(sprayDraw,"SprayResolution","Разрешение: 2–128 по длинной стороне");sprayResolution.Text="64"
local sprayColors=input(sprayDraw,"SprayColors","Палитра: 256 = исходная; 2/3/4/6/16 = уровни RGB");sprayColors.Text="256"
action(sprayDraw,"Загрузить фото по ссылке",function()SP.loadURL(sprayURL.Text,tonumber(sprayResolution.Text),tonumber(sprayColors.Text))end)
action(sprayDraw,"Проверить локальный декодер",function()
    task.spawn(function()local ok,result=pcall(function()return game:HttpGet("http://127.0.0.1:8766/health")end)
        if not A.alive then return end
        if ok and type(result)=="string"and result:find("nebula-image-helper",1,true)then A.status("Локальный декодер доступен")else A.status("Запусти NEBULA-Image-Helper.exe; нужен порт 8766 на 127.0.0.1")end
    end)
end)
action(sprayDraw,"Выбрать область · три клика",SP.beginSelect,"Верхний левый → верхний правый → нижний левый угол одной детали. Escape — отмена.")
action(sprayDraw,"Отменить выбор области",SP.cancelSelect)
action(sprayDraw,"Показать локальное превью фото",SP.previewPhoto)
action(sprayDraw,"Убрать локальное превью",SP.clearPreview)
local sprayRate=input(sprayDraw,"SprayRate","Скорость: 1–12 точек в секунду");sprayRate.Text="8"
local sprayLayer=input(sprayDraw,"SprayLayer","Слой: 1–10");sprayLayer.Text="1"
function SP.applyInputs()
    local rate,layer=tonumber(sprayRate.Text),tonumber(sprayLayer.Text)
    assert(finite(rate)and rate>=1 and rate<=12,"Скорость: 1–12")
    assert(finite(layer)and layer%1==0 and layer>=1 and layer<=10,"Слой: целое 1–10")
    SP.rate=rate;SP.layer=layer
end
action(sprayDraw,"Начать рисовать на сервере",function()SP.applyInputs();SP.start()end,"Реальные запросы SprayPaint/SendPaintInfo, один за раз. Сервер может отклонить их.")
action(sprayDraw,"Пауза / продолжить рисование",function()local run=N.job;assert(run and run.kind=="spray","Рисование не запущено");run.paused=not run.paused;SP.refresh()end)
action(sprayDraw,"Остановить рисование",function()if N.job and N.job.kind=="spray"then N.stop("Spray: остановлено; уже нанесённые штрихи остаются")end end)
local sprayNotice=text(sprayDraw,"Фото вписывается без искажения пропорций. Прозрачные клетки пропускаются. Круглая кисть и минимальный размер 0.2 studs ограничивают точность. «Отправлено» означает отправленные запросы, а не подтверждённое сохранение рисунка. Превью видно только тебе.",nil,UDim2.new(1,0,0,85),nil,Color3.fromRGB(139,139,139));sprayNotice.TextWrapped=true;A.place(sprayDraw,sprayNotice)
function SP.refresh()
    local image=SP.plan and (SP.plan.width.."×"..SP.plan.height.." · "..#SP.plan.pixels.." точек")or "фото не загружено"
    local area=SP.area and string.format("%.1f×%.1f studs",SP.area.width,SP.area.height)or "область не выбрана"
    local run=N.job;local state=run and run.kind=="spray"and (run.paused and "Пауза · "or "Отправка · ")..run.sent.." / "..#SP.plan.pixels or "Остановлено"
    local remaining=run and run.kind=="spray"and math.max(0,#SP.plan.pixels-run.index+1)or SP.plan and #SP.plan.pixels or 0
    local eta=math.ceil(remaining/(run and run.rate or SP.rate))
    sprayState.Text=image.."\n"..area.."\n"..state.." · ~"..eta.." сек."
end
SP.refresh()

local aimPage=page("MM2 Aim","Плавное наведение камеры при экипированном Gun. По умолчанию ПКМ и только игроки с обнаруженным Knife. Не стреляет автоматически и не меняет направление серверного выстрела.")
Aim.widgets={}
local function aimToggle(key,title)
    local b=action(aimPage,title,function()Aim.configure(key,not Aim[key])end)
    Aim.widgets[key]=function()b.Text=title..(Aim[key]and " · ВКЛ"or " · выкл")end
end
aimToggle("enabled","MM2 Aim · включить")
aimToggle("showFOV","Показывать круг FOV")
aimToggle("visibleOnly","Проверять видимость лучом")
aimToggle("knifeOnly","Целиться только в обнаруженный Knife")
aimToggle("always","Наводить без удержания кнопки")
local aimBind=action(aimPage,"",function()
    local nextButton=Aim.button==Enum.UserInputType.MouseButton2 and Enum.KeyCode.LeftAlt or Aim.button==Enum.KeyCode.LeftAlt and Enum.UserInputType.MouseButton1 or Enum.UserInputType.MouseButton2
    Aim.configure("button",nextButton)
end)
local aimPart=action(aimPage,"",function()Aim.configure("part",Aim.part=="Head"and "HumanoidRootPart"or "Head")end)
for _,cfg in ipairs({{"radius","Радиус FOV в пикселях: 20–600"},{"smooth","Плавность наведения: 1–35, больше = быстрее"},{"lead","Упреждение в секундах: 0–0.25"},{"range","Дистанция в studs: 25–2000"}})do
    local key,title=cfg[1],cfg[2];local field=input(aimPage,"MM2Aim_"..key,title);field.Text=tostring(Aim[key])
    action(aimPage,"Применить · "..title,function()Aim.configure(key,tonumber(field.Text));field.Text=tostring(Aim[key])end)
end
local nativeAim=action(N.panels.mm2,"",function()Aim.configure("enabled",not Aim.enabled)end);nativeAim.LayoutOrder=-91
local nativeSettings=action(N.panels.mm2,"MM2 · настройки Aim",function()A.switchPage("MM2 Aim")end);nativeSettings.LayoutOrder=-90
action(aimPage,"Выключить MM2 Aim",function()Aim.configure("enabled",false)end)
function Aim.refresh()
    for _,fn in pairs(Aim.widgets)do fn()end
    local bind=Aim.button==Enum.UserInputType.MouseButton2 and "ПКМ"or Aim.button==Enum.UserInputType.MouseButton1 and "ЛКМ"or "LeftAlt"
    aimBind.Text="Кнопка: "..bind.." · сменить";aimPart.Text="Точка: "..(Aim.part=="Head"and "голова"or "корпус").." · сменить"
    nativeAim.Text="MM2 · AIM"..(Aim.enabled and " · ВКЛ"or " · выкл")
end
Aim.refresh()

SP.gallery={
{id="photo_0",name="Космонавт",url="https://raw.githubusercontent.com/scikit-image/scikit-image/v0.19.3/skimage/data/astronaut.png",credit="NASA / scikit-image",category="Фото"},
{id="photo_1",name="Кот Челси",url="https://raw.githubusercontent.com/scikit-image/scikit-image/v0.19.3/skimage/data/chelsea.png",credit="scikit-image",category="Фото"},
{id="photo_2",name="Кофе",url="https://raw.githubusercontent.com/scikit-image/scikit-image/v0.19.3/skimage/data/coffee.png",credit="scikit-image",category="Фото"},
{id="photo_3",name="Ракета",url="https://raw.githubusercontent.com/scikit-image/scikit-image/v0.19.3/skimage/data/rocket.jpg",credit="NASA / scikit-image",category="Фото"},
{id="photo_4",name="Глубокий космос",url="https://raw.githubusercontent.com/scikit-image/scikit-image/v0.19.3/skimage/data/hubble_deep_field.jpg",credit="NASA / scikit-image",category="Фото"},
{id="photo_5",name="Луна",url="https://raw.githubusercontent.com/scikit-image/scikit-image/v0.19.3/skimage/data/moon.png",credit="scikit-image",category="Фото"},
{id="photo_6",name="Силуэт лошади",url="https://raw.githubusercontent.com/scikit-image/scikit-image/v0.19.3/skimage/data/horse.png",credit="scikit-image",category="Фото"},
{id="photo_7",name="Фотограф",url="https://raw.githubusercontent.com/scikit-image/scikit-image/v0.19.3/skimage/data/camera.png",credit="scikit-image",category="Фото"},
{id="photo_9",name="Кирпичная стена",url="https://raw.githubusercontent.com/scikit-image/scikit-image/v0.19.3/skimage/data/brick.png",credit="scikit-image",category="Фото"},
{id="photo_10",name="Монеты",url="https://raw.githubusercontent.com/scikit-image/scikit-image/v0.19.3/skimage/data/coins.png",credit="scikit-image",category="Фото"},
{id="photo_11",name="Цветная мозаика",url="https://raw.githubusercontent.com/scikit-image/scikit-image/v0.19.3/skimage/data/color.png",credit="scikit-image",category="Фото"},
{id="emoji_1f431",name="Кот",url="https://raw.githubusercontent.com/twitter/twemoji/v14.0.2/assets/72x72/1f431.png",credit="Twemoji · CC-BY 4.0",category="Иконки"},
{id="emoji_1f436",name="Собака",url="https://raw.githubusercontent.com/twitter/twemoji/v14.0.2/assets/72x72/1f436.png",credit="Twemoji · CC-BY 4.0",category="Иконки"},
{id="emoji_1f47b",name="Призрак",url="https://raw.githubusercontent.com/twitter/twemoji/v14.0.2/assets/72x72/1f47b.png",credit="Twemoji · CC-BY 4.0",category="Иконки"},
{id="emoji_1f480",name="Череп",url="https://raw.githubusercontent.com/twitter/twemoji/v14.0.2/assets/72x72/1f480.png",credit="Twemoji · CC-BY 4.0",category="Иконки"},
{id="emoji_1f525",name="Огонь",url="https://raw.githubusercontent.com/twitter/twemoji/v14.0.2/assets/72x72/1f525.png",credit="Twemoji · CC-BY 4.0",category="Иконки"},
{id="emoji_2764",name="Сердце",url="https://raw.githubusercontent.com/twitter/twemoji/v14.0.2/assets/72x72/2764.png",credit="Twemoji · CC-BY 4.0",category="Иконки"},
{id="emoji_1f308",name="Радуга",url="https://raw.githubusercontent.com/twitter/twemoji/v14.0.2/assets/72x72/1f308.png",credit="Twemoji · CC-BY 4.0",category="Иконки"},
{id="emoji_1f339",name="Роза",url="https://raw.githubusercontent.com/twitter/twemoji/v14.0.2/assets/72x72/1f339.png",credit="Twemoji · CC-BY 4.0",category="Иконки"},
{id="emoji_1f30d",name="Земля",url="https://raw.githubusercontent.com/twitter/twemoji/v14.0.2/assets/72x72/1f30d.png",credit="Twemoji · CC-BY 4.0",category="Иконки"},
{id="emoji_1f319",name="Месяц",url="https://raw.githubusercontent.com/twitter/twemoji/v14.0.2/assets/72x72/1f319.png",credit="Twemoji · CC-BY 4.0",category="Иконки"},
{id="emoji_2b50",name="Звезда",url="https://raw.githubusercontent.com/twitter/twemoji/v14.0.2/assets/72x72/2b50.png",credit="Twemoji · CC-BY 4.0",category="Иконки"},
{id="emoji_1f98a",name="Лиса",url="https://raw.githubusercontent.com/twitter/twemoji/v14.0.2/assets/72x72/1f98a.png",credit="Twemoji · CC-BY 4.0",category="Иконки"}
}
do
local search=input(SP.ui.panels.gallery,"SprayGallerySearch","Поиск: кот, космос, кофе, лиса, иконки…")
local favoriteOnly=false;local category="all";local rows={}
local favoritesButton=action(SP.ui.panels.gallery,"Только избранное: выкл",function()favoriteOnly=not favoriteOnly;SP.ui.filterGallery()end)
local categoryButton=action(SP.ui.panels.gallery,"Категория: все",function()category=category=="all"and "Фото"or category=="Фото"and "Иконки"or "all";SP.ui.filterGallery()end)
for i,item in ipairs(SP.gallery)do
    local entry=item
    local row=new("Frame",{Name="SprayGallery_"..entry.id,Size=UDim2.new(1,0,0,72),BackgroundColor3=Color3.fromRGB(12,12,12),BorderSizePixel=0},SP.ui.panels.gallery);A.place(SP.ui.panels.gallery,row)
    text(row,entry.name,UDim2.fromOffset(10,8),UDim2.new(1,-190,0,24),Enum.Font.GothamMedium)
    text(row,entry.credit,UDim2.fromOffset(10,35),UDim2.new(1,-190,0,25),nil,Color3.fromRGB(135,135,135)).TextSize=10
    local load=button(row,"Загрузить фото",UDim2.new(1,-174,0,18),UDim2.fromOffset(122,34))
    local star=button(row,"☆",UDim2.new(1,-44,0,18),UDim2.fromOffset(34,34))
    on(load.Activated,function()
        local ok,err=pcall(SP.loadURL,entry.url,tonumber(sprayResolution.Text),tonumber(sprayColors.Text));if not ok then A.status(err)else sprayURL.Text=entry.url;SP.ui.select("draw")end
    end)
    on(star.Activated,function()SP.favorites[entry.id]=not SP.favorites[entry.id];star.Text=SP.favorites[entry.id]and "★"or "☆";SP.ui.filterGallery()end)
    rows[#rows+1]={row=row,entry=entry}
end
function SP.ui.filterGallery()
    local query=fold(search.Text)
    for _,r in ipairs(rows)do r.row.Visible=(not favoriteOnly or SP.favorites[r.entry.id])and (category=="all"or category==r.entry.category)and fold(r.entry.name.." "..r.entry.credit):find(query,1,true)~=nil end
    favoritesButton.Text=favoriteOnly and "Только избранное: ВКЛ"or "Только избранное: выкл";categoryButton.Text="Категория: "..(category=="all"and "все"or category)
end
on(search:GetPropertyChangedSignal("Text"),SP.ui.filterGallery)
SP.ui.filterGallery()
local credits=text(SP.ui.panels.gallery,"Фото: тестовый набор scikit-image (включая NASA); иконки: Twemoji, Twitter и участники, CC-BY 4.0. Ссылки и атрибуция сохранены в README. Файлы загружаются по нажатию; рисование не запускается автоматически.",nil,UDim2.new(1,0,0,70),nil,Color3.fromRGB(132,132,132));credits.TextWrapped=true;A.place(SP.ui.panels.gallery,credits)
for _,entry in ipairs({{"cw","Повернуть на 90° вправо"},{"ccw","Повернуть на 90° влево"},{"flipx","Отразить по горизонтали"},{"flipy","Отразить по вертикали"},{"gray","Чёрно-белое фото"},{"invert","Инверсия цветов"},{"sepia","Сепия"},{"bright+","Яркость +20"},{"bright-","Яркость −20"},{"contrast+","Увеличить контраст"},{"contrast-","Уменьшить контраст"},{"sat+","Увеличить насыщенность"},{"sat-","Уменьшить насыщенность"},{"bw","Чёрно-белый трафарет"},{"poster","Палитра до 64 цветов"},{"removeWhite","Убрать почти белый фон"},{"removeBlack","Убрать почти чёрный фон"}})do
    local mode,title=entry[1],entry[2];action(SP.ui.panels.edit,title,function()SP.edit(mode)end)
end
action(SP.ui.panels.edit,"Отменить последнюю обработку · до 5 шагов",SP.undo)
action(SP.ui.panels.edit,"Вернуть исходное изображение",SP.resetImage)
action(SP.ui.panels.edit,"Показать превью обработки",SP.previewPhoto)
for _,entry in ipairs({{"rows","Рисовать по строкам"},{"snake","Рисовать змейкой"},{"color","Рисовать по цветам"},{"reverse","Рисовать в обратном порядке"}})do local mode,title=entry[1],entry[2];action(SP.ui.panels.projects,title,function()SP.setOrder(mode)end)end
action(SP.ui.panels.projects,"Продолжить с последней остановки",function()SP.applyInputs();SP.resume()end)
local from=input(SP.ui.panels.projects,"SprayStartIndex","Начать с номера точки: 1…число точек");from.Text="1"
action(SP.ui.panels.projects,"Начать с указанной точки",function()local n=tonumber(from.Text);assert(finite(n)and n%1==0,"Нужен целый номер");SP.applyInputs();SP.startFrom=n;SP.start()end)
action(SP.ui.panels.projects,"Сбросить отметку продолжения",function()SP.checkpoint=nil;A.status("Отметка продолжения сброшена")end)
local name=input(SP.ui.panels.projects,"SprayProjectName","Имя проекта латиницей, без пути");name.Text="my_picture"
action(SP.ui.panels.projects,"Сохранить схему проекта",function()SP.saveProject(name.Text)end)
action(SP.ui.panels.projects,"Загрузить схему проекта",function()SP.loadProject(name.Text);sprayRate.Text=tostring(SP.rate);sprayLayer.Text=tostring(SP.layer)end)
action(SP.ui.panels.projects,"Скопировать JSON схемы",SP.copyPlan)
action(SP.ui.panels.projects,"Область · сдвинуть влево на 10%",function()SP.adjustArea(-0.1,0,1)end)
action(SP.ui.panels.projects,"Область · сдвинуть вправо на 10%",function()SP.adjustArea(0.1,0,1)end)
action(SP.ui.panels.projects,"Область · сдвинуть вверх на 10%",function()SP.adjustArea(0,-0.1,1)end)
action(SP.ui.panels.projects,"Область · сдвинуть вниз на 10%",function()SP.adjustArea(0,0.1,1)end)
action(SP.ui.panels.projects,"Область · уменьшить до 80%",function()SP.adjustArea(0,0,0.8)end)
action(SP.ui.panels.projects,"Область · увеличить до 125%",function()SP.adjustArea(0,0,1.25)end)
end

end
do
local doorsPage=page("DOORS · свой","Свой помощник загруженных комнат. Ничего не скачивает. Совместимость с актуальным этажом проверяется по структуре; серверные TP/взаимодействия не гарантируются.")
action(doorsPage,"DOORS · показать номер комнаты",function()local _,_,room=X.currentDoor();A.status("GameData.LatestRoom: "..room)end)
action(doorsPage,"DOORS · обновить ключи, книги, шкафы",X.doorScan)
action(doorsPage,"DOORS · TP к текущей двери",function()local _,part=X.currentDoor();A.Teleport(CFrame.new(part.Position+Vector3.new(0,2,0)))end)
action(doorsPage,"DOORS · запросить открытие рядом",X.openDoor)
action(doorsPage,"DOORS · TP к ближайшему ключу",function()X.goDoorItem("KeyObtain")end)
action(doorsPage,"DOORS · подобрать ключ рядом",X.interactKey)
action(doorsPage,"DOORS · TP к ближайшей книге",function()X.goDoorItem("LiveHintBook")end)
action(doorsPage,"DOORS · TP к ближайшему шкафу",function()X.goDoorItem("Wardrobe")end)
action(doorsPage,"DOORS · убрать маркеры",X.clearMarkers)
local tohPage=page("Tower of Hell · свой","Свои инструменты tower/sections: этапы, FinishGlow и личная точка. Нет поддельной победы или неуязвимости; перемещения может отклонить сервер.")
action(tohPage,"Tower · отметить этапы и финиш",X.markTower)
action(tohPage,"Tower · следующий загруженный этап",X.nextStage)
action(tohPage,"Tower · TP к FinishGlow",function()A.Teleport(CFrame.new(X.finish().Position+Vector3.new(0,3,0)))end)
action(tohPage,"Tower · записать свою точку",X.saveTower)
action(tohPage,"Tower · вернуться к своей точке",X.returnTower)
X.fallToggle=action(tohPage,"Tower · возврат при падении: выкл",function()
    N.requireGame("toh");assert(X.towerPoint,"Сначала запиши свою точку");X.fallReturn=not X.fallReturn;X.lastReturn=0
    X.fallToggle.Text=X.fallReturn and "Tower · возврат при падении: ВКЛ"or "Tower · возврат при падении: выкл";A.status("Возврат при падении: "..tostring(X.fallReturn))
end)
action(tohPage,"Tower · убрать маркеры",X.clearMarkers)
action(tohPage,"Tower · выключить помощник",function()X.cleanup()end)
end

local scenarioPage=page("Сценарии","Свои шаги, точка возрождения, конечное число кругов или бесконечный повтор.")
local pointLabel=text(scenarioPage,"Точка не выбрана",nil,UDim2.new(1,-8,0,35),Enum.Font.Code);A.place(scenarioPage,pointLabel)
action(scenarioPage,"Указать точку здесь",A.saveSpawnPoint,"Берёт текущие координаты и направление персонажа","точка возрождение spawn сценарий")
toggle(scenarioPage,"respawnPoint","Точка после возрождения","Локально переносит к записанной точке после появления персонажа.")
action(scenarioPage,"Очистить точку",function()A.stopScenario(true);A.spawnPoint=nil;A.pendingSpawn=nil;A.Set("respawnPoint",false);A.updateScenarioUI();A.status("Точка очищена")end)
local repeatInput=input(scenarioPage,"ScenarioRepeats","Повторов: число, 0 или бесконечно");repeatInput.Text="3"
local durationInput=input(scenarioPage,"ScenarioSeconds","Длительность нового шага в секундах");durationInput.Text="3"
local planList=new("Frame",{Name="ScenarioPlan",BackgroundTransparency=1,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y},scenarioPage);A.place(scenarioPage,planList)
new("UIListLayout",{Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder},planList)
A.planConnections={}
function A.updateScenarioUI()
    disconnect(A.planConnections)
    for _,child in ipairs(planList:GetChildren())do if child:IsA("Frame")then child:Destroy()end end
    local pos=A.spawnPoint and A.spawnPoint.Position
    pointLabel.Text=pos and string.format("Точка: %.1f  %.1f  %.1f",pos.X,pos.Y,pos.Z)or"Точка не выбрана"
    for index,step in ipairs(A.plan)do
        local f=new("Frame",{Name="ScenarioStep_"..index,Size=UDim2.new(1,0,0,37),BackgroundColor3=Color3.fromRGB(12,12,12),BorderSizePixel=0,LayoutOrder=index},planList);round(f)
        text(f,index..". "..A.stepNames[step.kind],UDim2.fromOffset(10,0),UDim2.new(1,-200,1,0))
        if step.kind=="walk"or step.kind=="wait"then
            local field=new("TextBox",{Name="StepSeconds",Text=tostring(step.seconds),ClearTextOnFocus=false,Font=Enum.Font.Code,TextSize=12,TextColor3=white,
                BackgroundColor3=Color3.fromRGB(20,20,20),BorderSizePixel=0,Position=UDim2.new(1,-190,0,5),Size=UDim2.fromOffset(63,27)},f);round(field,4)
            on(field.FocusLost,function()local n=tonumber(field.Text);if finite(n)and n>=0.05 and n<=3600 then step.seconds=n else field.Text=tostring(step.seconds);A.status("Длительность: 0.05–3600 секунд")end end,A.planConnections)
        end
        for _,cfg in ipairs({{label="↑",x=-115,delta=-1},{label="↓",x=-78,delta=1},{label="×",x=-41}})do
            local b=new("TextButton",{Text=cfg.label,Position=UDim2.new(1,cfg.x,0,5),Size=UDim2.fromOffset(31,27),BackgroundColor3=Color3.fromRGB(23,23,23),
                TextColor3=white,Font=Enum.Font.GothamMedium,TextSize=14,BorderSizePixel=0},f);round(b,4)
            on(b.Activated,function()
                if cfg.delta then local other=index+cfg.delta;if other>=1 and other<=#A.plan then A.plan[index],A.plan[other]=A.plan[other],A.plan[index]end
                else table.remove(A.plan,index)end
                A.updateScenarioUI()
            end,A.planConnections)
        end
    end
end
function A.addStep(kind,seconds)
    assert(A.stepNames[kind],"Шаг: walk, wait, jump, point или die")
    if kind=="walk"or kind=="wait"then seconds=tonumber(seconds);assert(finite(seconds)and seconds>=0.05 and seconds<=3600,"Длительность: 0.05–3600 секунд")end
    A.plan[#A.plan+1]={kind=kind,seconds=seconds};A.updateScenarioUI()
end
for _,cfg in ipairs({{kind="walk",title="Добавить: идти вперёд"},{kind="wait",title="Добавить: подождать"},{kind="jump",title="Добавить: прыгнуть"},{kind="point",title="Добавить: вернуться в точку"},{kind="die",title="Добавить: умереть"}})do
    action(scenarioPage,cfg.title,function()A.addStep(cfg.kind,durationInput.Text)end)
end
action(scenarioPage,"Шаблон: идти 3 секунды → смерть",function()A.plan={{kind="walk",seconds=3},{kind="die"}};A.updateScenarioUI()end)
action(scenarioPage,"Очистить шаги",function()A.plan={};A.updateScenarioUI()end)
slider(scenarioPage,"spawnTimeout","Ожидание возрождения, секунд",5)
action(scenarioPage,"Запустить сценарий",function()A.startScenario(repeatInput.Text)end)
action(scenarioPage,"Остановить сценарий",function()A.stopScenario(true)end)
local note=text(scenarioPage,"Шаги копируются при запуске: правки списка применятся к следующему запуску. Смерть — собственного персонажа; возрождение выполняет сама игра.",nil,UDim2.new(1,-8,0,48),nil,Color3.fromRGB(136,136,136));note.TextWrapped=true;note.TextSize=11;A.place(scenarioPage,note)
A.scenarioStop=button(gui,"СТОП СЦЕНАРИЙ",UDim2.new(0,16,1,-64),UDim2.fromOffset(160,36));A.scenarioStop.Visible=false;A.scenarioStop.ZIndex=9
on(A.scenarioStop.Activated,function()A.stopScenario(true)end)
A.scenarioHUD=text(gui,"",UDim2.new(0,18,1,-139),UDim2.fromOffset(320,62),Enum.Font.Code);A.scenarioHUD.Visible=false;A.scenarioHUD.ZIndex=9
A.updateScenarioUI()

local quietPage=page("Silent и удобство","F9 — скрыть/вернуть интерфейс NEBULA. Не скрывает инжектор от игры. Невидимость только локальная.")
toggle(quietPage,"silent","Silent · F9","Скрывает оба окна, HUD и ESP. Бинд меню возвращает интерфейс.")
toggle(quietPage,"underground","Спрятаться под картой · TP","Переносит персонажа вниз; выключение и KILL возвращают. Не скрывает от ESP.")
slider(quietPage,"hideDepth","Глубина укрытия",5)
action(quietPage,"Вернуться из-под карты",function()A.hideStop(true,true)end)
toggle(quietPage,"invisible","Невидимость · локально","Полностью скрывает своё тело только на твоём экране.")
toggle(quietPage,"hideAccessories","Скрыть аксессуары","Убирает свои аксессуары локально.")
toggle(quietPage,"hideTag","Скрыть свой тег","Отключает стандартный тег своего персонажа локально.")
toggle(quietPage,"autoRotateOff","Зафиксировать направление","Отключает автоматический поворот персонажа.")
action(quietPage,"Сохранить позицию возврата",A.saveReturn)
action(quietPage,"Вернуться в сохранённую позицию",A.returnSaved)
action(quietPage,"Освободить персонажа и вернуть камеру",A.rescue)
action(quietPage,"Скопировать свои координаты",function()local r=rootOf(me);assert(r,"Персонаж не готов");A.copy(string.format("%.2f %.2f %.2f",r.Position.X,r.Position.Y,r.Position.Z))end)
local trollPage=page("Тролл","Действия своего персонажа и кратковременная попытка физического fling. Есть остановка и общий сброс.")
for _,cfg in ipairs({{"orbit","Орбита вокруг выбранного","Локальное движение вокруг цели."},{"headstand","Стойка на голове","Переворот своего тела через AlignOrientation."},
    {"ragdoll","Падение своего персонажа","Локальный PlatformStand."},{"bhop","Автопрыжки","Прыгает, когда ноги касаются земли."},
    {"ghost","Полупрозрачный персонаж","Локальная прозрачность собственного тела."},{"rainbowBody","Радужное тело","Локальная переливающаяся окраска."}})do toggle(trollPage,cfg[1],cfg[2],cfg[3])end
for _,cfg in ipairs({{"neonBody","Неоновое тело"},{"blackBody","Чёрный силуэт"},{"glassBody","Стеклянное тело"},{"outlineSelf","Фиолетовый контур"},{"bodyLight","Фиолетовый свет"},{"bodyTrail","Широкий фиолетовый след"}})do toggle(trollPage,cfg[1],cfg[2],"Локальный эффект своего персонажа; отключение восстанавливает свойства.")end
for _,emote in ipairs({"wave","point","cheer","laugh","dance","dance2","dance3"})do
    action(trollPage,"Жест: "..emote,function()local h=humOf(me);assert(h,"Персонаж не готов");local ok,played=pcall(function()return h:PlayEmote(emote)end);assert(ok and played,"Игра или аватар не поддерживает этот жест")end)
end
slider(trollPage,"orbitRadius","Радиус орбиты",0.5);slider(trollPage,"orbitSpeed","Скорость орбиты",0.1)
slider(trollPage,"flingPower","Угловая скорость fling",10);slider(trollPage,"flingDuration","Длительность попытки fling",0.1)
action(trollPage,"Fling выбранного · кратковременно",function()A.startFling()end)
action(trollPage,"Остановить fling",function()A.stopFling(true)end)
action(trollPage,"Остановить тролл-режимы",function()A.stopFling(true);for _,k in ipairs({"orbit","headstand","ragdoll","bhop","ghost","rainbowBody","spin"})do A.Set(k,false)end end)

local playersPage=page("Игроки","Выбор цели, информация и действия. Имена ищутся по username, DisplayName или UserId.")
local playerFilter=input(playersPage,"PlayerFilter","Имя игрока или часть имени")
local info=text(playersPage,"Никто не выбран",nil,UDim2.new(1,-8,0,62),Enum.Font.Code);info.TextWrapped=true;info.TextSize=11
A.place(playersPage,info)
local list=new("Frame",{Name="PlayerList",BackgroundTransparency=1,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y},playersPage)
A.place(playersPage,list)
new("UIListLayout",{Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder},list)
A.listConnections={}
function A.refreshPlayers()
    disconnect(A.listConnections);for _,child in ipairs(list:GetChildren())do if child:IsA("TextButton")then child:Destroy()end end
    local query=fold(playerFilter.Text);local players=P:GetPlayers();table.sort(players,function(a,b)return fold(a.Name)<fold(b.Name)end)
    for _,pl in ipairs(players)do
        if pl~=me and (query==""or fold(pl.Name.." "..pl.DisplayName):find(query,1,true))then
            local b=new("TextButton",{Name="Player_"..pl.Name,Text=pl.DisplayName.."  @"..pl.Name,Size=UDim2.new(1,0,0,34),TextColor3=pl==A.selected and white or Color3.fromRGB(170,170,170),
                Font=Enum.Font.GothamMedium,TextSize=12,BackgroundColor3=pl==A.selected and Color3.fromRGB(25,25,25)or Color3.fromRGB(9,9,9),BorderSizePixel=0},list);round(b)
            on(b.Activated,function()A.SelectPlayer(pl)end,A.listConnections)
        end
    end
end
on(playerFilter:GetPropertyChangedSignal("Text"),A.refreshPlayers)
action(playersPage,"Выбрать по имени",function()local pl,err=A.findPlayer(playerFilter.Text);assert(pl,err);A.SelectPlayer(pl)end)
action(playersPage,"Выбрать ближайшего",function()local pl,err=A.findPlayer("nearest");assert(pl,err);A.SelectPlayer(pl)end)
action(playersPage,"Выбрать случайного",function()local pl,err=A.findPlayer("random");assert(pl,err);A.SelectPlayer(pl)end)
action(playersPage,"Снять выбор",function()A.SelectPlayer(nil)end)
action(playersPage,"Скопировать имя",function()assert(A.selected,"Выбери игрока");A.copy(A.selected.Name)end)
action(playersPage,"Скопировать UserId",function()assert(A.selected,"Выбери игрока");A.copy(A.selected.UserId)end)
local espPage=page("ESP","Отображение других игроков на твоём клиенте. Без Drawing API и внешних библиотек.")
for _,cfg in ipairs({
    {"esp","Включить ESP","Общий переключатель отображения игроков.","видеть сквозь стены esp wallhack"},
    {"names","Имена","DisplayName и username над персонажем."},{"health","Здоровье","Число HP и вертикальная полоска."},
    {"distance","Дистанция","Расстояние от твоего персонажа."},{"offscreen","Игроки за экраном","Указатели направления у края экрана."},{"boxes","Рамки","Границы модели по восьми углам bounding box."},
    {"tracers","Линии к игрокам","Линии от нижнего центра экрана."},{"throughWalls","Подсветка сквозь стены","Контур и слабая заливка модели через Highlight."},
    {"teamColors","Цвета команд","Цвет TeamColor, если он доступен."},{"teamFilter","Скрывать свою команду","Игроки с той же Team исключаются."},
    {"visibleOnly","Только прямая видимость","Проверка препятствия лучом от камеры."},{"selectedOnly","Только выбранный","Показывает только выбранного в списке игрока."},
})do toggle(espPage,cfg[1],cfg[2],cfg[3],cfg[4])end
local boxTypes={"2D Box","3D Box","Corner Box"}
local boxButton=action(espPage,"Тип рамки: 2D Box",function()A.Set("boxMode",S.boxMode%3+1)end,"","cs2 2d 3d box рамки каркас углы")
A.widgets.boxMode=function()boxButton.Text="Тип рамки: "..boxTypes[S.boxMode]end
slider(espPage,"espThickness","Толщина рамок",0.5)
slider(espPage,"espRange","Максимальная дистанция ESP",25);slider(espPage,"espSize","Размер подписей",1);slider(espPage,"espHue","Свой цвет ESP",0.01)
local movementPage=page("Персонаж","Изменения снимаются при отключении и KILL. Сервер игры может возвращать свои значения.")
for _,cfg in ipairs({{"speed","Своя скорость","Заданная WalkSpeed."},{"sprint","Спринт на Shift","Отдельная скорость, пока удерживается Shift."},{"jump","Сила прыжка","Работает с JumpPower и режимом JumpHeight."},
    {"infJump","Прыжок в воздухе","Повторный прыжок по JumpRequest."},{"noclip","Noclip","Локальное отключение CanCollide у своего тела."},
    {"fly","Полёт","WASD, Space вверх, левый Ctrl вниз. F6."},{"hover","Парение на месте","Удержание позиции через LinearVelocity."},
    {"follow","Идти за выбранным","Периодический MoveTo; препятствия не обходятся автоматически."},{"autoWalk","Автобег","Движение вперёд относительно камеры."},
    {"spin","Вращение","Угловая скорость вокруг вертикальной оси."},{"freeze","Заморозить себя","Anchored корня. Выключи для продолжения движения."},
    {"sit","Сидеть","Состояние Sit собственного Humanoid."}})do toggle(movementPage,cfg[1],cfg[2],cfg[3])end
for _,cfg in ipairs({{"speedValue","Скорость",1},{"sprintValue","Скорость спринта",1},{"jumpValue","Сила прыжка",1},{"flySpeed","Скорость полёта",1},{"spinSpeed","Вращений в секунду",0.1}})do slider(movementPage,cfg[1],cfg[2],cfg[3])end
action(movementPage,"Снять скорость персонажа",function()local r=rootOf(me);assert(r,"Персонаж не готов");r.AssemblyLinearVelocity=Vector3.new();r.AssemblyAngularVelocity=Vector3.new()end)
action(movementPage,"Встать",function()A.Set("sit",false);local h=humOf(me);if h then h.Sit=false;h:ChangeState(Enum.HumanoidStateType.GettingUp)end end)
local tpPage=page("Телепорты","Локальные перемещения. Возврат хранит положение перед последним телепортом.")
action(tpPage,"К выбранному игроку",function()A.gotoPlayer()end,"","тп tp goto телепорт игрок")
action(tpPage,"Над выбранным игроком",function()A.gotoPlayer(nil,"above")end)
action(tpPage,"Плавно к выбранному",function()A.gotoPlayer(nil,"smooth")end)
action(tpPage,"Назад после телепорта",function()assert(A.back,"Точки возврата ещё нет");local cf=A.back;A.Teleport(cf)end)
slider(tpPage,"tpOffset","Отступ от цели",1);slider(tpPage,"tpTime","Время плавного перемещения",0.1)
local xyz=input(tpPage,"TeleportXYZ","Координаты: X Y Z")
action(tpPage,"Перейти к координатам",function()A.xyz(xyz.Text)end)
toggle(tpPage,"clickTP","Ctrl + клик: телепорт","Удерживай левый Ctrl и кликни по поверхности.")
local waypointName=input(tpPage,"WaypointName","Название точки")
action(tpPage,"Сохранить точку",function()A.savePoint(waypointName.Text)end)
action(tpPage,"Перейти к точке",function()A.goPoint(waypointName.Text)end)
action(tpPage,"Удалить точку",function()local key=fold(waypointName.Text);assert(A.waypoints[key],"Точка не найдена");A.waypoints[key]=nil;A.status("Точка удалена")end)
action(tpPage,"Список точек",function()local names={};for _,v in pairs(A.waypoints)do names[#names+1]=v.name end;table.sort(names);A.status(#names>0 and table.concat(names,", ")or"Точек ещё нет")end)
action(tpPage,"Скопировать координаты",function()local r=rootOf(me);assert(r,"Персонаж не готов");local p=r.Position;A.copy(string.format("%.2f %.2f %.2f",p.X,p.Y,p.Z))end)
local cameraPage=page("Камера","Наблюдение, поле зрения и масштаб. Автоматической Scriptable-камеры здесь нет.")
toggle(cameraPage,"spectate","Наблюдать за выбранным","Камера следует Humanoid выбранного игрока.")
toggle(cameraPage,"fov","Свой FOV","Включает выбранное поле зрения.");slider(cameraPage,"fovValue","Поле зрения",1)
toggle(cameraPage,"zoom","Дальний зум","Увеличивает CameraMaxZoomDistance.");slider(cameraPage,"zoomValue","Дальность зума",10)
action(cameraPage,"Вернуть камеру к себе",function()A.Set("spectate",false);local cam=workspace.CurrentCamera;local h=humOf(me);if cam and h then cam.CameraType=Enum.CameraType.Custom;cam.CameraSubject=h end;A.status("Камера следует за тобой")end)
local worldPage=page("Мир","Локальные инструменты читаемости карты. Сохраняются исходные свойства объектов.")
toggle(worldPage,"fullbright","Светлый мир","Повышенный окружающий свет и выключенные глобальные тени.")
toggle(worldPage,"noFog","Убрать туман","Fog и плотность существующего Atmosphere.")
toggle(worldPage,"noPost","Убрать постэффекты","Отключает Enabled у существующих PostEffect.")
toggle(worldPage,"xray","Прозрачная карта","LocalTransparencyModifier загруженных закреплённых деталей, без персонажей.")
slider(worldPage,"xrayAlpha","Прозрачность карты",0.05)
action(worldPage,"День",function()A.ownProp(L,"ClockTime",14);A.status("Локальное время: 14:00")end)
action(worldPage,"Ночь",function()A.ownProp(L,"ClockTime",0);A.status("Локальное время: 00:00")end)
action(worldPage,"Вернуть время игры",function()A.release(L,"ClockTime")end)
local commandsPage=page("Команды","Команды вводятся в нижнюю строку. Кавычки сохраняют имена точек с пробелами. История — стрелки вверх/вниз.")
local commandHelp=text(commandsPage,"",nil,UDim2.new(1,-10,0,100),Enum.Font.Code);commandHelp.TextSize=11;commandHelp.TextWrapped=true;commandHelp.AutomaticSize=Enum.AutomaticSize.Y;commandHelp.TextYAlignment=Enum.TextYAlignment.Top
A.place(commandsPage,commandHelp)
local settingsPage=page("Настройки","Общий сброс, интерфейс и управление. Бинд меню отделён от NEBULA Visuals.")
toggle(settingsPage,"stats","Информационный HUD","FPS, координаты и скорость.")
toggle(settingsPage,"reduced","Уменьшить анимации","Мгновенное открытие и переключение контролов.")
local rebind=action(settingsPage,"Бинд меню: RightAlt — изменить",function()A.waitingKey=true;A.status("Нажми новую клавишу; Escape — отмена")end)
action(settingsPage,"Выключить все модули",A.reset)
action(settingsPage,"KILL SCRIPT",A.Unload)
A.keyHint=text(panel,"1.13  / RightAlt",UDim2.new(0,20,1,-36),UDim2.fromOffset(160,20),nil,Color3.fromRGB(110,110,110));A.keyHint.TextSize=11
function A.tokenize(line)
    local out,buf={},{};local quote=nil
    for n=1,#line do local c=line:sub(n,n)
        if quote then if c==quote then quote=nil else buf[#buf+1]=c end
        elseif c=='"'or c=="'"then quote=c
        elseif c:match("%s")then if #buf>0 then out[#out+1]=table.concat(buf);buf={}end
        else buf[#buf+1]=c end
    end
    assert(not quote,"Закрой кавычки");if #buf>0 then out[#out+1]=table.concat(buf)end;return out
end
local function register(name,usage,description,fn,aliases)
    A.commands[name]={name=name,usage=usage,description=description,run=fn};A.aliases[name]=name
    for _,alias in ipairs(aliases or {})do A.aliases[alias]=name end
end
local function boolArg(v,current)if not v then return not current end;v=fold(v);assert(v=="on"or v=="off"or v=="1"or v=="0","Используй on/off");return v=="on"or v=="1"end
for _,cfg in ipairs({{"esp","esp"},{"names","names"},{"health","health"},{"distance","distance"},{"boxes","boxes"},{"tracers","tracers"},{"walls","throughWalls"},{"teamcolors","teamColors"},{"teamfilter","teamFilter"},{"visible","visibleOnly"},{"selectedonly","selectedOnly"},
    {"noclip","noclip"},{"fly","fly"},{"hover","hover"},{"infjump","infJump"},{"sprint","sprint"},{"follow","follow"},{"autowalk","autoWalk"},{"spin","spin"},{"freeze","freeze"},{"sit","sit"},{"spectate","spectate"},{"clicktp","clickTP"},{"fullbright","fullbright"},{"nofog","noFog"},{"nopost","noPost"},{"xray","xray"},{"stats","stats"}})do
    register(cfg[1],cfg[1].." [on/off]","Переключатель "..cfg[1],function(args)
        local first=args[1]and fold(args[1])
        if (cfg[2]=="spectate"or cfg[2]=="follow")and first and first~="on"and first~="off"and first~="1"and first~="0"then
            local pl,err=A.findPlayer(table.concat(args," "));assert(pl,err);A.SelectPlayer(pl);A.Set(cfg[2],true)
        else A.Set(cfg[2],boolArg(args[1],S[cfg[2]]))end
    end)
end
for _,cfg in ipairs({{"speed","speedValue","speed"},{"jump","jumpValue","jump"},{"fov","fovValue","fov"},{"zoom","zoomValue","zoom"},{"flyspeed","flySpeed"},{"range","espRange"},{"textsize","espSize"},{"offset","tpOffset"},{"tptime","tpTime"},{"xrayalpha","xrayAlpha"}})do
    register(cfg[1],cfg[1].." число / off","Числовая настройка "..cfg[1],function(args)
        if args[1]and fold(args[1])=="off"and cfg[3]then A.Set(cfg[3],false);return end
        local value=tonumber(args[1]);assert(finite(value),"Нужно число");A.Set(cfg[2],value);if cfg[3]then A.Set(cfg[3],true)end
    end)
end
for _,cfg in ipairs({{"headstand","headstand"},{"ragdoll","ragdoll"},{"bhop","bhop"},{"ghost","ghost"},{"rainbowbody","rainbowBody"},{"offscreen","offscreen"}})do
    register(cfg[1],cfg[1].." [on/off]","Дополнительный режим",function(args)A.Set(cfg[2],boolArg(args[1],S[cfg[2]]))end)
end
for _,key in ipairs({"silent","invisible","neonBody","blackBody","glassBody","outlineSelf","bodyLight","bodyTrail","hideTag","hideAccessories","autoRotateOff"})do
    register(string.lower(key),string.lower(key).." [on/off]","Локальный режим",function(args)A.Set(key,boolArg(args[1],S[key]))end)
end
register("hide","hide [on/off]","Переместиться под карту / вернуться",function(args)A.Set("underground",boolArg(args[1],S.underground))end)
register("unhide","unhide","Вернуться из укрытия",function()A.Set("underground",false)end)
register("hidedepth","hidedepth число","Глубина следующего укрытия",function(args)A.Set("hideDepth",tonumber(args[1]))end)
register("gameprofile","gameprofile boat/mm2/vd/doors/evade/arsenal/custom","Выбрать профиль игры",function(args)G.select(args[1]);A.switchPage("Маршруты")end)
register("gamepoint","gamepoint имя","Сохранить точку игрового профиля",function(args)G.savePoint(table.concat(args," "))end)
register("gamegoto","gamegoto имя","TP к точке игрового профиля",function(args)G.goPoint(table.concat(args," "))end)
register("gamescan","gamescan имена,через,запятую","Поиск загруженных объектов",function(args)G.scanStart(table.concat(args," "))end)
register("gamemarkers","gamemarkers","Маркеры результатов поиска",G.showMarkers)
register("gameclear","gameclear","Убрать маркеры и остановить поиск",function()G.cancelScan();G.clearMarkers()end)
register("gameclosest","gameclosest","TP к ближайшему результату",function()G.gotoResult(G.closest())end)
register("routerec","routerec","Записать точку маршрута",G.recordRoute)
register("routestart","routestart","Запустить записанный маршрут",G.startRoute)
register("routestop","routestop","Остановить маршрут",function()G.stopRoute()end)
register("tools","tools","Список доступных инструментов игроков",G.toolSummary)
register("crosshair","crosshair","Переключить прицел",function()G.crosshair=not G.crosshair;G.render()end)
register("savepos","savepos","Сохранить позицию возврата",A.saveReturn)
register("returnpos","returnpos","Вернуться в сохранённую позицию",A.returnSaved)
register("rescue","rescue","Остановить движение и восстановить камеру",A.rescue)
register("emote","emote wave/point/cheer/laugh/dance/dance2/dance3","Жест аватара",function(args)local allowed={wave=true,point=true,cheer=true,laugh=true,dance=true,dance2=true,dance3=true};assert(allowed[args[1]],"Неизвестный жест");local h=humOf(me);assert(h and h:PlayEmote(args[1]),"Жест недоступен")end)
register("orbit","orbit [имя/off]","Орбита вокруг игрока",function(args)if args[1]and fold(args[1])=="off"then A.Set("orbit",false)else if args[1]then local pl,err=A.findPlayer(table.concat(args," "));assert(pl,err);A.SelectPlayer(pl)end;A.Set("orbit",true)end end)
register("fling","fling [имя]","Кратковременная попытка физического fling",function(args)A.startFling(table.concat(args," "))end)
register("unfling","unfling","Остановить попытку fling",function()A.stopFling(true)end)
register("box2d","box2d","2D рамки",function()A.Set("boxMode",1);A.Set("boxes",true);A.Set("esp",true)end)
register("box3d","box3d","3D каркасы",function()A.Set("boxMode",2);A.Set("boxes",true);A.Set("esp",true)end)
register("cornerbox","cornerbox","Угловые рамки",function()A.Set("boxMode",3);A.Set("boxes",true);A.Set("esp",true)end)
register("spawnpoint","spawnpoint","Запомнить точку возрождения здесь",A.saveSpawnPoint)
register("cleanspawn","cleanspawn","Убрать точку возрождения",function()A.Set("respawnPoint",false);A.spawnPoint=nil end)
register("addstep","addstep walk/wait/jump/point/die [секунды]","Добавить шаг",function(args)A.addStep(args[1],args[2])end)
register("clearsteps","clearsteps","Очистить план",function()A.plan={};A.updateScenarioUI()end)
register("scenario","scenario число/бесконечно","Запустить сценарий",function(args)A.startScenario(args[1]or"1")end)
register("stopscenario","stopscenario","Остановить сценарий",function()A.stopScenario(true)end)
register("select","select имя","Выбрать игрока",function(args)local pl,err=A.findPlayer(table.concat(args," "));assert(pl,err);A.SelectPlayer(pl)end,{"target"})
register("goto","goto [имя]","Телепорт за игрока",function(args)A.gotoPlayer(table.concat(args," "))end,{"tp"})
register("above","above [имя]","Телепорт над игроком",function(args)A.gotoPlayer(table.concat(args," "),"above")end)
register("tweento","tweento [имя]","Плавно к игроку",function(args)A.gotoPlayer(table.concat(args," "),"smooth")end)
register("pos","pos X Y Z","Телепорт по координатам",function(args)A.xyz(table.concat(args," "))end,{"xyz"})
register("back","back","Назад после TP",function()assert(A.back,"Нет точки возврата");A.Teleport(A.back)end)
register("savewp","savewp имя","Сохранить точку",function(args)A.savePoint(table.concat(args," "))end)
register("gowp","gowp имя","Перейти к точке",function(args)A.goPoint(table.concat(args," "))end)
register("delwp","delwp имя","Удалить точку",function(args)local key=fold(table.concat(args," "));assert(A.waypoints[key],"Точка не найдена");A.waypoints[key]=nil end)
register("waypoints","waypoints","Список точек",function()local names={};for _,item in pairs(A.waypoints)do names[#names+1]=item.name end;table.sort(names);A.status(table.concat(names,", "))end)
register("coords","coords","Показать координаты",function()local r=rootOf(me);assert(r,"Персонаж не готов");A.status(tostring(r.Position))end)
register("copypos","copypos","Координаты в буфер",function()local r=rootOf(me);assert(r,"Персонаж не готов");local p=r.Position;A.copy(string.format("%.2f %.2f %.2f",p.X,p.Y,p.Z))end)
register("copyname","copyname","Имя цели в буфер",function()assert(A.selected,"Выбери игрока");A.copy(A.selected.Name)end)
register("userid","userid","UserId цели",function()assert(A.selected,"Выбери игрока");A.status(A.selected.UserId)end)
register("stop","stop","Остановить движение",function()A.stopScenario(true);A.stopFling(true);for _,key in ipairs({"fly","hover","spin","follow","autoWalk"})do A.Set(key,false)end;local r=rootOf(me);if r then r.AssemblyLinearVelocity=Vector3.new();r.AssemblyAngularVelocity=Vector3.new()end end)
register("unsit","unsit","Встать",function()A.Set("sit",false);local h=humOf(me);if h then h.Sit=false;h:ChangeState(Enum.HumanoidStateType.GettingUp)end end)
register("unfreeze","unfreeze","Снять свою заморозку",function()A.Set("freeze",false)end)
register("day","day","День локально",function()A.ownProp(L,"ClockTime",14)end)
register("night","night","Ночь локально",function()A.ownProp(L,"ClockTime",0)end)
register("time","time час","Свое локальное время",function(args)local hour=tonumber(args[1]);assert(finite(hour),"Нужно число");A.ownProp(L,"ClockTime",hour%24)end)
register("resetime","resetime","Вернуть время игры",function()A.release(L,"ClockTime")end)
register("unview","unview","Камера к себе",function()A.Set("spectate",false);local cam=workspace.CurrentCamera;local h=humOf(me);if cam and h then cam.CameraType=Enum.CameraType.Custom;cam.CameraSubject=h end end)
register("reset","reset","Выключить все модули",A.reset,{"panic"})
register("show","show","Открыть окно",function()A.show(true)end)
register("hidemenu","hidemenu","Скрыть окно",function()A.show(false)end)
register("clear","clear","Очистить строку команд",function()commandBox.Text=""end)
register("help","help [часть имени]","Справка",function(args)local q=fold(args[1]or"");local out={};for name,cmd in pairs(A.commands)do if name:find(q,1,true)then out[#out+1]=cmd.usage end end;table.sort(out);commandHelp.Text=table.concat(out,"\n");A.switchPage("Команды");A.status("Команд найдено: "..#out)end,{"commands"})
register("kill","kill","Выгрузить NEBULA Control",A.Unload,{"unload"})
A.aliases.ws="speed";A.aliases.walkspeed="speed";A.aliases.jp="jump";A.aliases.jumppower="jump";A.aliases.view="spectate";A.aliases.fs="flyspeed"
A.shortcuts={unfly={"fly","off"},clip={"noclip","off"},uninfjump={"infjump","off"},unfollow={"follow","off"},unesp={"esp","off"},unxray={"xray","off"},unspeed={"speed","off"},unjump={"jump","off"},unsprint={"sprint","off"}}
function A.Command(line)
    if not A.alive then return false,"Хаб выгружен"end
    local ok,result=pcall(function()
        local args=A.tokenize(tostring(line):gsub("^%s*[;/]",""));local name=fold(table.remove(args,1)or"")
        local shortcut=A.shortcuts[name];if shortcut then name=shortcut[1];table.insert(args,1,shortcut[2])end
        local command=A.commands[A.aliases[name]or""];assert(command,"Неизвестная команда. Введи help")
        command.run(args);return true
    end)
    if not ok then A.status("Ошибка: "..tostring(result):sub(1,160));return false,result end
    return true
end
local helpLines={};for _,cmd in pairs(A.commands)do helpLines[#helpLines+1]=cmd.usage.."  —  "..cmd.description end;table.sort(helpLines);commandHelp.Text=table.concat(helpLines,"\n")
on(commandBox.FocusLost,function(enter)if enter and commandBox.Text~=""then
    local line=commandBox.Text;A.history[#A.history+1]=line;if #A.history>40 then table.remove(A.history,1)end;A.historyIndex=#A.history+1;A.Command(line);if A.alive then commandBox.Text=""end
end end)
on(search:GetPropertyChangedSignal("Text"),function()
    local query=fold(search.Text)
    if query==""then for _,item in ipairs(A.indexed)do item.control.Parent=item.home end;results.Visible=false;if A.pages[A.page]then A.pages[A.page].frame.Visible=true end;return end
    for _,p in pairs(A.pages)do p.frame.Visible=false end;results.Visible=true
    for _,item in ipairs(A.indexed)do local match=true;for word in query:gmatch("%S+")do if not item.find:find(word,1,true)then match=false;break end end;item.control.Parent=match and results or item.home end
end)
on(header.InputBegan,function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then A.drag={input=i,start=i.Position,pos=panel.Position}end end)
on(resizeGrip.InputBegan,function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then A.resize={input=i,start=i.Position,width=A.windowWidth,height=A.windowHeight,scale=scale.Scale}end end)
on(U.InputChanged,function(i)
    if i.UserInputType==Enum.UserInputType.MouseMovement or A.drag and i==A.drag.input or A.dragSlider and i==A.dragSlider.input or A.resize and i==A.resize.input then
        if A.resize then local d=i.Position-A.resize.start;A.windowWidth=math.clamp(A.resize.width+d.X/A.resize.scale,760,1400);A.windowHeight=math.clamp(A.resize.height+d.Y/A.resize.scale,540,1000);panel.Size=UDim2.fromOffset(A.windowWidth,A.windowHeight)
        elseif A.dragSlider then A.dragSlider.update(i.Position.X)elseif A.drag then local d=i.Position-A.drag.start;panel.Position=UDim2.new(A.drag.pos.X.Scale,A.drag.pos.X.Offset+d.X,A.drag.pos.Y.Scale,A.drag.pos.Y.Offset+d.Y)end
    end
end)
on(U.InputEnded,function(i)if A.drag and i==A.drag.input then A.drag=nil end;if A.dragSlider and i==A.dragSlider.input then A.dragSlider=nil end;if A.resize and i==A.resize.input then A.resize=nil end end)
on(U.InputBegan,function(i,processed)
    if N.Spray and N.Spray.capture(i,processed)then return end
    local focus=U:GetFocusedTextBox()
    if focus==commandBox and i.UserInputType==Enum.UserInputType.Keyboard then
        if i.KeyCode==Enum.KeyCode.Up then A.historyIndex=math.max(1,(A.historyIndex or #A.history+1)-1);commandBox.Text=A.history[A.historyIndex]or""
        elseif i.KeyCode==Enum.KeyCode.Down then A.historyIndex=math.min(#A.history+1,(A.historyIndex or #A.history+1)+1);commandBox.Text=A.history[A.historyIndex]or""end
        return
    end
    if focus then return end
    if A.waitingKey and i.UserInputType==Enum.UserInputType.Keyboard then
        if i.KeyCode==Enum.KeyCode.Escape then A.waitingKey=false;A.status("Смена бинда отменена");return end
        if i.KeyCode~=Enum.KeyCode.Unknown then S.key=i.KeyCode;A.waitingKey=false;rebind.Text="Бинд меню: "..S.key.Name.." — изменить";A.keyHint.Text="1.13  / "..S.key.Name;A.status("Новый бинд: "..S.key.Name)end;return
    end
    if i.UserInputType==Enum.UserInputType.Keyboard then
        if S.silent and i.KeyCode==S.key then A.setSilent(false);A.show(true)
        elseif i.KeyCode==S.key then A.show(not A.open)
        elseif i.KeyCode==Enum.KeyCode.F9 then A.Set("silent",not S.silent)
        elseif i.KeyCode==Enum.KeyCode.F6 then A.Set("fly",not S.fly)
        elseif i.KeyCode==Enum.KeyCode.F7 then A.Set("noclip",not S.noclip)
        elseif i.KeyCode==Enum.KeyCode.F8 then A.Set("esp",not S.esp)
        elseif i.KeyCode==Enum.KeyCode.Semicolon then A.show(true);commandBox:CaptureFocus()end
    elseif i.UserInputType==Enum.UserInputType.MouseButton1 and not processed and S.clickTP and U:IsKeyDown(Enum.KeyCode.LeftControl)then
        local cam=workspace.CurrentCamera;if cam then local mouse=U:GetMouseLocation();local ray=cam:ScreenPointToRay(mouse.X,mouse.Y);local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={me.Character,owned}
            local hit=workspace:Raycast(ray.Origin,ray.Direction*3000,params);if hit then local ok,err=pcall(function()A.Teleport(CFrame.new(hit.Position+Vector3.new(0,3,0)))end);if not ok then A.status(err)end end
        end
    end
end)
on(U.JumpRequest,function()if S.infJump and not U:GetFocusedTextBox()then local h=humOf(me);if h then h:ChangeState(Enum.HumanoidStateType.Jumping)end end end)
on(hide.Activated,function()A.show(false)end);on(launcher.Activated,function()A.show(true)end)
on(kill.Activated,A.Unload);on(close.Activated,A.Unload);on(panic.Activated,A.Unload)
on(me.CharacterRemoving,function()
    if N.job and not (N.job.kind=="boat"and N.job.waiting)then N.stop("Свой модуль остановлен при смене персонажа",false)end
    if A.Games then A.Games.stopRoute("Маршрут остановлен при смене персонажа",false)end
    A.hideStop(false,false)
    A.stopFling(false);A.clearTrollRig();A.clearSelfFX();A.departing=me.Character
    A.destroyMotion();A.restoreAll();A.hadNoclip=false;disconnect(A.characterConnections)
    if A.tpTween then A.tpTween:Cancel();A.tpTween=nil end
end)
on(me.CharacterAdded,function()A.spawnSerial=(A.spawnSerial or 0)+1;A.departing=nil;A.pendingSpawn={character=me.Character,elapsed=0};task.defer(function()if A.alive then A.motion(0);A.cameraStep()end end)end)
local function watch(pl)
    if pl==me or A.playerConnections[pl]then return end
    espEntry(pl);A.playerConnections[pl]={}
    on(pl.CharacterAdded,function()if A.alive then espEntry(pl).removing=false end end,A.playerConnections[pl])
    on(pl.CharacterRemoving,function()local e=A.esp[pl];if e then e.removing=true;e.highlight.Enabled=false;e.box.Visible=false;e.label.Visible=false;e.tracer.Visible=false end end,A.playerConnections[pl])
end
on(P.PlayerAdded,function(pl)watch(pl);A.refreshPlayers()end)
on(P.PlayerRemoving,function(pl)
    if A.fling and A.fling.target==pl then A.stopFling(true)end
    if A.selected==pl then
        if S.follow then local h,r=humOf(me),rootOf(me);if h and r then h:MoveTo(r.Position)end end
        S.follow=false;S.spectate=false;A.selected=nil;A.cameraStep();for _,key in ipairs({"follow","spectate"})do A.widgets[key]()end
    end
    if A.playerConnections[pl]then disconnect(A.playerConnections[pl]);A.playerConnections[pl]=nil end
    A.removeESP(pl);task.defer(function()if A.alive then A.refreshPlayers()end end)
end)
on(workspace.DescendantAdded,function(obj)if S.xray and obj~=owned and not obj:IsDescendantOf(owned)then A.xrayQueue[#A.xrayQueue+1]=obj end end)
A.xrayQueue={};A.xraySeen={};A.worldClock=0;A.espClock=0;A.statsClock=0
R:BindToRenderStep("NEBULA_MM2Aim",201,function(dt)
    if not A.alive then return end
    local ok,err=pcall(Aim.step,dt)
    if not ok then Aim.cleanup();A.status("Aim отключён: "..tostring(err):sub(1,130))end
end)
R:BindToRenderStep("NEBULA_ControlESP",215,function(dt)
    if not A.alive then return end
    A.espClock=A.espClock+dt
    if A.espClock>=0.04 then A.espClock=0;A.espStep();G.render();N.render();X.render()end
end)
on(R.Heartbeat,function(dt)
    if not A.alive then return end
    if A.pendingSpawn then local ok,err=pcall(A.processSpawnPoint,dt);if not ok then A.pendingSpawn=nil;A.status("Ошибка точки: "..tostring(err):sub(1,100))end end
    if A.scenario then local ok,err=pcall(A.scenarioStep,dt);if not ok then A.stopScenario(true,"Ошибка шага: "..tostring(err):sub(1,100))end end
    local ok,err=pcall(function()G.routeStep(dt);G.scanStep();N.step(dt)end)
    if not ok then G.stopRoute("Ошибка игрового режима: "..tostring(err):sub(1,100));G.cancelScan();N.stop("Ошибка своего модуля: "..tostring(err):sub(1,100));N.scan=nil;if N.Helper then N.Helper.disable()end end
    A.motion(dt);A.cameraStep();A.worldClock=A.worldClock+dt
    if A.worldClock>0.15 then A.worldClock=0;A.worldStep()end
end)
on(R.RenderStepped,function(dt)
    if not A.alive then return end
    A.statsClock=A.statsClock+dt
    local cam=workspace.CurrentCamera
    if cam then scale.Scale=math.clamp(math.min((cam.ViewportSize.X-20)/A.windowWidth,(cam.ViewportSize.Y-30)/A.windowHeight,1),0.35,1)end
    if A.statsClock>=0.2 then
        A.statsClock=0;local r=rootOf(me);local pos=r and r.Position or Vector3.new();local velocity=r and r.AssemblyLinearVelocity or Vector3.new()
        stats.Text=string.format("control  ·  %.0f FPS\nXYZ %.1f  %.1f  %.1f\nСкорость %.1f",1/math.max(dt,0.001),pos.X,pos.Y,pos.Z,velocity.Magnitude)
        local pl=A.selected;local h=humOf(pl);local targetRoot=rootOf(pl)
        info.Text=pl and string.format("%s (@%s)  |  UserId %s\nHP %.0f / %.0f  |  Возраст аккаунта %s дней\nДистанция %.1f studs",pl.DisplayName,pl.Name,tostring(pl.UserId),h and h.Health or 0,h and h.MaxHealth or 0,tostring(pl.AccountAge),r and targetRoot and (r.Position-targetRoot.Position).Magnitude or 0)or"Никто не выбран"
    end
end)
for _,pl in ipairs(P:GetPlayers())do watch(pl)end
A.refreshPlayers();A.switchPage("Сценарии")
A.status("Готово · "..#helpLines.." команд · RightAlt: меню · F6/F7/F8: fly/noclip/ESP")

end
local e=(getgenv and getgenv())or _G
local a=e.__NEBULA_CONTROL
if a and a.alive then a.Native.select("vd");a.switchPage("Свои скрипты")end
