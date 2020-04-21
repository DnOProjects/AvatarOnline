local debugger = {}

local log = {}
local function grade(value,best,worst) --args given are bounds from best to worst
  local low, high = best,worst
  if best>worst then low,high = worst,best end
  local grade = (value-low)/(high-low)--from 0 to 1
  if best<worst then grade = 1-grade end--lower the better
  return ColMix(Col(0,1,0),Col(1,0,0),grade)
end
local function logVal(name,value,color) table.insert(log,{text=name..": "..tostring(value or ''),color=color or Colors.white})  end
local i=0

function debugger.update(dt)  --clear log before frame starts
  log = {}
  local fps = love.timer.getFPS()
  logVal('  FPS',fps,grade(fps,60,20))
end
function debugger.logServer(objects,server)
  logVal('Server')
  logVal('  #objects',#objects)
end
function debugger.logClient(server,objects,client)
  logVal('Client')
  i=i+0.5
  local ping = server:round_trip_time()
  logVal('  #objects',#objects)
  logVal('  ping',tostring(ping)..' ms',grade(ping,20,80))
end
function debugger.draw()
  for i,v in ipairs(log) do
    v.color:use()
    love.graphics.print(v.text,0,20*(i-1))
    Colors.white:use()
  end
end

return debugger
