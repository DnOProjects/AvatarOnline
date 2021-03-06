local debugger = {}

local log = {}
local function grade(value,best,worst) --args given are bounds from best to worst
  local low, high = best,worst
  if best>worst then low,high = worst,best end
  local grade = (value-low)/(high-low)--from 0 to 1
  if best<worst then grade = 1-grade end--lower the better
  return Col(0,1,0):mix(Col(1,0,0),grade)
end
local function logVal(name,value,color) table.insert(log,{text=name..": "..tostring(value or ''),color=color or Colors.white})  end
local i=0

function debugger.update(dt)  --clear log before frame starts
  log = {}
  local fps = love.timer.getFPS()
  logVal('FPS',fps,grade(fps,60,20))
end
function debugger.logServer(server)
  logVal('Server')
  logVal('    #Objects',#Objects)
end
function debugger.logClient(server,client)
  logVal('Client')
  i=i+0.5
  local ping = server:round_trip_time()
  logVal('    ping',tostring(ping)..' ms',grade(ping,20,80))
  logVal('    #Objects',#Objects)
  logVal('    playerID',client.playerID)
  logVal('    player')
  for k,v in pairs(client.player) do
    local text
    if type(v)=="table" and v.getText then text = v:getText()
    else text = tostring(v) end
    logVal('      '..tostring(k),text)
  end
  logVal('    sent',tostring(client.sent)..' request(s)/frame',grade(client.sent,0,3))
  logVal('    recieved',tostring(client.recieved)..' request(s)/frame',grade(client.recieved,0,7))
end
function debugger.draw()
  for i,v in ipairs(log) do
    v.color:use()
    love.graphics.setFont(love.graphics.newFont(20))
    love.graphics.print(v.text,0,20*(i-1))
    Colors.white:use()
  end
end

return debugger
