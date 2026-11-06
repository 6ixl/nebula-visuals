-- Native seat key bindings shared by all car models.
do
local D={};C.Drive=D
function D.keys()
 return {Forward=Enum.KeyCode.W.Value,Backward=Enum.KeyCode.S.Value,Left=Enum.KeyCode.A.Value,Right=Enum.KeyCode.D.Value}
end
function D.args(models,seat)
 assert(seat and seat.Parent,"Нет своего водительского кресла")
 local groups=C.bindingGroups(models);local keys=D.keys();local map={}
 for action in pairs(groups)do assert(keys[action],"Неизвестное действие колеса: "..action);map[action]=keys[action]end
 -- Current native BindLocalScript: groups, controller ARRAY, key map,
 -- disconnect=false, custom seat input=true. Empty keys are not a seat binding.
 return {groups,{seat},map,false,true}
end
function D.verify(models,seat)
 local groups=C.bindingGroups(models);local keys=D.keys()
 for action,values in pairs(groups)do for _,value in ipairs(values)do
  if value.Value~=keys[action]then return false,"Не подтверждена клавиша "..action.." у "..value.Parent.Name end
 end end
 local wheels=0
 for _,entry in ipairs(models)do if entry.spec.group=="wheel"then
  wheels=wheels+1;local linked=false
  for _,beam in ipairs(seat:GetChildren())do
   if beam:IsA("Beam")and beam.Attachment1 and beam.Attachment1.Parent and beam.Attachment1.Parent:IsDescendantOf(entry.model)then linked=true;break end
  end
  if not linked then return false,"Нет связи кресла с "..entry.spec.id end
 end end
 return wheels==4,wheels==4 and "W/S/A/D подтверждены"or "Нужны четыре колеса"
end
function D.rebind()
 assert(not N.job,"Сначала останови текущую задачу")
 N.requireGame("boat")
 local record=C.last;local models=record and record.models;local seat
 if record then assert(not record.plan.tank and not record.plan.aircraft,"Эта кнопка для машин");for _,entry in ipairs(models)do if entry.spec.group=="seat"then seat=entry.model end end end
 if not seat then
  -- After reloading the hub, select only an unambiguous nearby own car.
  local root=assert(rootOf(me),"Нет персонажа");local blocks=workspace:FindFirstChild("Blocks");local folder=blocks and blocks:FindFirstChild(me.Name)
  assert(folder,"Нет своей папки блоков");local candidates={}
  for _,model in ipairs(folder:GetChildren())do local pp=model:FindFirstChild("PPart")
   if model.Name=="CarSeat"and pp and(pp.Position-root.Position).Magnitude<20 then candidates[#candidates+1]=model end
  end
  assert(#candidates==1,"Подойди к одной машине: в радиусе 20 studs должно быть одно своё CarSeat")
  seat=candidates[1];models={}
  for _,model in ipairs(folder:GetChildren())do local pp=model:FindFirstChild("PPart")
   if(model.Name=="FrontWheel"or model.Name=="BackWheel")and pp and(pp.Position-seat.PPart.Position).Magnitude<22 then models[#models+1]={model=model,spec={group="wheel",id=model.Name..":"..#models}}end
  end
  assert(#models==4,"Рядом должны быть ровно четыре своих колеса; другие машины отодвинь")
 end
 local tool=H.tool("BindTool");local rf=tool and tool:FindFirstChild("RF");assert(rf and rf:IsA("RemoteFunction"),"Нужна отвёртка BindTool")
 local args=D.args(models,seat);local run=N.prepare("carWheelRepair");run.phaseTime=0;run.models=models
 run.task=task.spawn(function()
  local ok,err=pcall(function()
   humOf(me):EquipTool(tool);task.wait(.15);if not A.alive or N.job~=run then return end
   assert(rf:InvokeServer(table.unpack(args))~=false,"Сервер отклонил привязку")
   local message
   for _=1,25 do
    if not A.alive or N.job~=run then return end
    local verified;verified,message=D.verify(models,seat);if verified then return end;task.wait(.1)
   end
   error(message or "Клавиши колёс не подтверждены")
  end)
  if A.alive and N.job==run then run.task=nil;N.stop(ok and "Привязка W/S/A/D подтверждена. Проверь снятие закрепления и движение в игре."or("Привязка не подтверждена: "..tostring(err)))end
 end)
end
end
