local  objMan, net, logic = require 'objectManager', require 'net', require 'logic'

local server = {
  nodeType='Server',
  host=nil, --host object (self) bound to an address
}
local clients = {} --to store the clients when they connect
local clientRequests = {} --to store accumulated requests for each client
local objects = {}

local function broadcast() --send all accumulated requests
  for i, requests in ipairs(clientRequests) do
    if #requests>0 then clients[i]:send(bitser.dumps(requests)) end
  end
end
local function requestAddObj(object,clientID) --requests all if client == nil
  if not object.data.internal then --don't transfer the object if not used by client
    local dataCopy = utils.copy(object.data)
    object.data = nil --nullify object data to avoid sending unnessesary details
    server.request({object=object},"addObj",clientID)
    object.data = dataCopy --restore data to the object
  end
end

function server.start(address)
  server.host = enet.host_create(address)
  if server.host then print('Server: started at '..address) end
end
function server.update(dt) --Called before main game updates
  objMan.bind(objects)
  for i=1,#clientRequests do clientRequests[i] = {} end --clear requests
  net.getEvents(server) --get events triggered by clients and call the appropriate handler method
  logic.update(dt,objects) --process game logic and send requests based from resultant state changes
  objMan.clearTrash()
  broadcast()
  debug.logServer(objects,server)
  objMan.unbind()
end
function server.request(request,requestType,clientID)
  if requestType then request.type = requestType end
  if clientID then table.insert(clientRequests[clientID],request) --send to one client
  else --send to all clients
    for i,requests in ipairs(clientRequests) do table.insert(requests,request) end
  end
end

--Handler functions
function server.handleRequest(client,request)
  if request.type=='createObj' then logic.createObject(request.objectType,request)
  elseif request.type=='moveObj' then server.moveObject(request.id,request.vec) end
end
function server.handleConnect(client)
  --Add client
  local clientID = #clients+1 --Defaults to expanding the list
  for i=1,#clients do --Search for removed (trash) objects to overwrite
    if clients[i].trash then
      clientID = i
      break
    end
  end
  clientRequests[clientID] = {}
  clients[clientID] = client

  for i,object in ipairs(objects) do requestAddObj(object,clientID) end   --Send all current objects to new client
  local player = logic.createObject('player',{clientID=clientID}) --Add new player object
  server.request({id=player.id},'setPlayerID',clientID) --Send the client their player's id
end
function server.handleDisconnect(client)
  --todo: remove from clients list
end

--Functions to change internal game state and possibly update the draw state of clients
function server.addObject(object)
  objMan.addObject(object)
  requestAddObj(object)
  return object
end
function server.removeObject(id)
  if objects[id] then
    objMan.removeObject(id)
    server.request({id=id},'removeObj')
  end
end
function server.moveObject(id,vec)
  if objects[id] then
    objects[id].pos = objects[id].pos + vec
    server.request({vec=vec,id=id},'moveObj')
  end
end

return server
