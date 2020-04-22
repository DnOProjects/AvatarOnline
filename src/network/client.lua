local client = {
  nodeType='Client',
  host=enet.host_create(), --unbound (meaning it cannot be connect to) host object (self)
  player = nil, --is updated to refer to the client's player
  connected = false,
  playerID = nil --unique id of the client's player game object
}
local server --bound peer object that it is connected to
local objects = {} --client-side objects list to draw graphics, interpret inputs and provide instant feedback with
local requests = {}
local function broadcast() --sends all accumulated requests
  if #requests>0 then server:send(bitser.dumps(requests)) end
end

function client.connect(address) server = client.host:connect(address) end
function client.update(dt) --Called before main game updates
  requests = {} --clear requests
  objMan.bind(objects)
  net.getEvents(client)
  if client.connected then
    client.player = objects[client.playerID] --update player
    graphics.update(dt,objects)
    input.update(dt)
    objMan.clearTrash()
    if server then debug.logClient(server,objects,client) end
    broadcast()
  end
  objMan.unbind()
end
function client.draw() graphics.draw(objects) end
function client.request(request,requestType)
  if requestType then request.type = requestType end
  table.insert(requests,request)
end
function client.handleRequest(from,request) --requests are recieved from the server and each have a type
  --local variables populated for convenience
  local object
  if request.id then object = objects[request.id] end
  if request.type=='acceptEntry' then
    client.playerID = request.playerID
    client.connected = true
  end
  if request.type=='addObj' then
    if request.object.path and server:round_trip_time()<200 then request.object.path.time = server:round_trip_time()/2000 end
    objMan.addObject(request.object,request.append)
  end
  if request.type=='removeObj' then objMan.removeObject(request.id) end
  if request.type=='changeObj' then
    objects[request.id] = request.data
    objects[request.id].id = request.id --restore lost id
  end
end

return client
