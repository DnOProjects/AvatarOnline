local net = {}

local function reconstruct(x) --restores classes
  if type(x) == 'table' then
      if x.class then
        if Constructors[x.class] then return Constructors[x.class](x)
        else return nil end
      end
      for k, v in pairs(x) do x[k] = reconstruct(v) end
  end
  return x
end

function net.getEvents(node) --Recieve all events in order of sending and pass them to the provided node's event handler
  local event = node.host:service()
  while event do
    if event.type == 'receive' then
      local requests = reconstruct(bitser.loads(event.data))
      for i,request in ipairs(requests) do node.handleRequest(peer,request) end
    else
      print(node.nodeType..': recieved '..event.type..' event from '..tostring(event.peer)) --Receive events do not print to avoid spam
      if event.type == 'connect' and node.handleConnect then node.handleConnect(event.peer) end
      if event.type == 'disconnect' and node.handleDisconnect then node.handleDisconnect(event.peer) end
    end
    event = node.host:service() --get new event (nil if there are no new events)
  end
end

return net
