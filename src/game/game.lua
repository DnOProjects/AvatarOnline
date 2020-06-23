--Automatically require all objects into a list
local objectClasses = {}
for i,file in ipairs(love.filesystem.getDirectoryItems('src/game/objects')) do
  local name = string.match(file,'%a+') --removes the .lua from the filename
  objectClasses[name] = require ('src/game/objects/'..name)
end

local game = {}

function game.update(dt)
    for i, object in ipairs(Objects) do
      if not object.trash then
        if (not object.player) and (object.pos.x > 1920 or object.pos.x<0 or object.pos.y > 1080 or object.pos.y<0 or object:touchingPillar()) then server.removeObject(i) end
          if not object.dead then
              object:updateTouches() --apply velocity
              if object.update then object:update() end
              if object.vel then object.pos = object.pos+object.vel*dt end
          end
      end
    end
end

function game.createObject(objectType,request)
    local object
    --Special case creations
    if objectType == 'player' then object = Player:obj({clientID=request.clientID}) end
    if objectType == 'bubble' then object = objectClasses.bubble:obj({vel=request.vel,ownerID=request.ownerID}) end
    object.pos = request.pos or Vec()
    object.height=request.height or 1
    server.addObject(object)
    object:onCreate()
    return object
end

return game
