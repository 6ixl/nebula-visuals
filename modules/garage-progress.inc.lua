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
