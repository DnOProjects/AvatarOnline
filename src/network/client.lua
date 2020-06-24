local client = {
  nodeType='Client',
  host=enet.host_create(), --unbound (meaning it cannot be connect to) host object (self)
  player = nil, --is updated to refer to the client's player
  requestedConnection = false,
  connected = false,
  playerID = nil, --unique id of the client's player game object
  --Stats for debug:
  sent = 0,
  recieved = 0,
  hudStats = {}
}
local server --bound peer object that it is connected to
local objects = {} --client-side objects list to draw graphics, interpret inputs and provide instant feedback with
local grid = {}
for x=1,GridSize.x do grid[x] = {} end
local requests = {}

local function broadcast() --sends all accumulated requests
  if #requests>0 then server:send(bitser.dumps(requests)) end
end

function client.load()
  scale.load()
  ui.load()
end
function client.connect(address)
  client.requestedConnection = true
  server = client.host:connect(address)
end
function client.update(dt) --Called before main game updates
  client.sent, client.recieved = 0,0 --reset stats
  requests = {} --clear requests
  Objects = objects
  Grid = grid
  if client.requestedConnection then net.getEvents(client) end
  ui.update()
  hud.update()
  if client.connected then
    client.player = objects[client.playerID] --update player
    graphics.update(dt)
    input.update(dt)
    objMan.clearTrash()
    if server then debugger.logClient(server,client) end

    --temp:
    for i,obj in ipairs(Objects) do
      if not obj.trash then
        if obj.path then
          --shaderMan.light(graphics.pathPos(obj.path),{col=Col(1,1,1),intensity=0.5,spread=100})
        end
      end
    end
    --shaderMan.light(Vec(500,500),{col=ColRand(),intensity=3,spread=math.random(1,20),type='line',dir=math.pi*(math.sin(love.timer.getTime())+1),length=10000})

    --shaderMan.update(dt) --must be called after all calls to shaderMan.light
    broadcast()
  end
  Objects = 'unbound'
  Grid = 'unbound'
end
function client.draw()
  if client.connected and utils.inList(currentPage, ui.getIGPages()) then
    Objects = objects
    Grid = grid
    graphics.draw()
    hud.draw()
    Objects = 'unbound'
    Grid = 'unbound'
  end
  ui.draw()
end
function client.request(request,requestType)
  client.sent = client.sent + 1
  if requestType then request.type = requestType end
  table.insert(requests,request)
end
function client.handleRequest(from,request) --requests are recieved from the server and each have a type
  client.recieved = client.recieved + 1
  --local variables populated for convenience
  local object
  if request.id then object = objects[request.id] end

  if request.type=='acceptEntry' then
    client.playerID = request.playerID
    client.connected = true
  elseif request.type=='youDied' then currentPage = "deathScreen"
  elseif request.type=='addObj' then
    if request.object.path and server:round_trip_time()<200 then request.object.path.time = server:round_trip_time()/2000 end
    objMan.addObject(request.object,request.append)
  elseif request.type=='removeObj' then
    objMan.removeObject(request.id)
  elseif request.type=='setTile' then map.setTile(request.pos,request.tile)
  elseif request.type=='changeObj' then
    objects[request.id] = request.data
    objects[request.id].id = request.id --restore lost id
  elseif request.type=='setInputFlag' then input.send[request.flag] = request.value
  elseif request.type=='setHudStat' then client.hudStats[request.k] = request.v end
end

return client
