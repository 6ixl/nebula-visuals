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
local function read(model,property)
 if property=="Transparency"then return alpha(model)
 elseif property=="Collision"then local p=model:FindFirstChild("PPart");return p and p.CanCollide
 elseif property=="Wheel speed"then local value=model:FindFirstChild("MaxSpeed");return value and value.Value
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
   elseif item.property=="Wheel speed"or item.property=="Wheel torque"then
    local cycle=item.property=="Wheel speed"and speedCycle or torqueCycle;local position
    for i,value in ipairs(cycle)do if math.abs(value-current)<.01 then position=i;break end end
    assert(position,"Неизвестная настройка колеса: "..tostring(current));expected=cycle[position%#cycle+1]
   end
   item.expected[model]=expected
  end
 end
 if #batch==0 then advance();return end
 item.cycles=item.cycles+1;assert(item.cycles<=12,"Свойство не достигло заданного значения: "..item.property)
 local args={item.property,batch}
 if item.property=="Collision"then args[3]=false elseif item.property=="Transparency"then args[3]=.25 end
 H.invoke(run,run.tools.props,run.tools.propsRF,args,"propertiesVerify")
end
function X.audit(record)
 for _,entry in ipairs(record.models)do local q=entry.spec
  if q.noCollide then assert(read(entry.model,"Collision")==false,"Коллизия не отключена: "..q.id)end
  if q.transparency then local value=read(entry.model,"Transparency");assert(finite(value)and math.abs(value-q.transparency)<.011,"Не подтверждена прозрачность: "..q.id)end
  if q.group=="wheel"then
   assert(read(entry.model,"Wheel speed")==record.wheelSpeed and read(entry.model,"Wheel torque")==record.wheelTorque,"Не подтверждены скорость/момент колеса")
   local collider=entry.model:FindFirstChild("InvisPart",true)or entry.model:FindFirstChild("WheelCollider",true)
   assert(collider and collider.CanCollide,"У игрового колеса нет физической коллизии")
  end
 end
end
end
