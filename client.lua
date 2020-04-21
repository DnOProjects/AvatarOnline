local input, graphics, objMan, net = require 'input', require 'graphics', require 'objectManager', require 'net'

local client = {
  nodeType='Client',
  host=enet.host_create(), --unbound (meaning it cannot be connect to) host object (self)
  player = nil, --is updated to refer to the client's player
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
  if client.playerID then client.player = objects[client.playerID] end --update player
  input.update(dt)
  objMan.clearTrash()
  if server then debug.logClient(server,objects,client) end
  broadcast()
  objMan.unbind()
end
function client.draw() graphics.draw(objects) end
function client.request(request,requestType)
  if requestType then request.type = requestType end
  table.insert(requests,request)
end
function client.handleRequest(server,request) --requests are recieved from the server and each have a type
  --local variables populated for convenience
  local object
  if request.id then object = objects[request.id] end

  if request.type=='setPlayerID' then client.playerID = request.id end
  if request.type=='addObj' then objMan.addObject(request.object) end
  if request.type=='removeObj' then objMan.removeObject(request.id) end
  if request.type=='moveObj' then object.pos = object.pos+request.vec end

end

return client
