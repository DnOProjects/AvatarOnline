local server = {
  nodeType='Server',
  host=nil, --host object (self) bound to an address
  running=false
}
local clients = {} --to store the clients when they connect
local clientRequests = {} --to store accumulated requests for each client
local objects = {}

local grid = {}
for x=1,GridSize.x do
  grid[x] = {}
  for y=1,GridSize.y do
    local height = math.random(-1,10)
    if height>1 then height = 0 end
    grid[x][y] = {h=height} --h is height (-1,0,1)
  end
end



local function broadcast() --send all accumulated requests
  for i, requests in ipairs(clientRequests) do
    if #requests>0 then clients[i]:send(bitser.dumps(requests)) end
  end
end

function server.start(address)
  server.running = true
  server.host = enet.host_create(address)
  if server.host then print('Server: started at '..address) end
end
function server.update(dt) --Called before main game updates
  if Hosting and server.running then
    Objects = objects
    Grid = grid
    for i=1,#clientRequests do clientRequests[i] = {} end --clear requests
    net.getEvents(server) --get events triggered by clients and call the appropriate handler method
    game.update(dt) --process game logic and send requests based from resultant state changes
    broadcast()
    debugger.logServer(server)
    objMan.clearTrash()
    Objects = 'unbound'
    Grid = 'unbound'
  end
end
function server.draw()
  Col(1,1,1,0.4):use()
  for i,obj in ipairs(objects) do
    love.graphics.circle("fill",obj.pos.x,obj.pos.y,10)
  end
  Col(1,1,1):use()
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
  local player
  if request.id then player = Objects[request.id] end

  if request.type == 'respawn' then player:respawn()
  elseif request.type=='move' then player:move(request)
  elseif request.type=='mouseMoved' then player:triggerAbilityMouseMoves(request.vec) 
  elseif request.type=='triggerAbility' then player:triggerAbility(request.name,request) end
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

  print("Server: Sending",#objects,'objects to the new guy')
  for i=1,#objects do server.requestAddObj(objects[i]:getClientData(),clientID,true) end   --Send all current objects to new client
  print("Server: Sending all the tiles to the new guy")
  for x=1,GridSize.x do
    for y=1,GridSize.y do
      server.request({pos=Vec(x,y),tile=grid[x][y]},'setTile',clientID)
    end
  end
  print("Server: Making the new guy a body")
  local player = game.createObject('player',{clientID=clientID,pos=Vec(100,100)}) --Add new player object
  print("Server: Telling the new guy where his body is: ",player.id)
  server.request({playerID=player.id},'acceptEntry',clientID) --Send the client their player's id
end
function server.handleDisconnect(client)
  --todo: remove from clients list
end

--Object management functions must mirror actions across all clients
function server.addObject(object)
  objMan.addObject(object)
  server.requestAddObj(object:getClientData())
  return object
end
function server.removeObject(id)
  if objects[id] then
    objMan.removeObject(id)
    server.request({id=id},'removeObj')
  else
    error('Object did not exist to remove')
  end
end
--Specific request functions
function server.requestAddObj(object,clientID,append) --sends to all if client == nil; append forces the reciever to append the object to their list
  server.request({object=object,append=append},"addObj",clientID)
end
function server.updateClientData(object) server.request({id=object.id,data=object:getClientData()},'changeObj') end

return server
