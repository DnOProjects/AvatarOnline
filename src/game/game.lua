local Object = require 'src/game/object'

local game = {}

local Player = Object:new('player',{player=true,clientID=nil,getDrawData=function(self)
  return {pos=self.pos,img='player'}
end})
local Bullet = Object:new('bullet',{bullet=true,vel=Vec(),ownerID=nil,getDrawData=function(self)
  return {path={start=self.pos,vel=self.vel,time=0},img='bullet'}
end})

function game.update(dt,objects)
    for i, obj in ipairs(objects) do
        if not obj.trash then
            if obj.vel then obj.pos = obj.pos+obj.vel*dt end --apply velocity
            if obj.player then
                for j, objB in ipairs(objects) do
                    if objB.bullet and objB.ownerID~=obj.id and objB.pos..obj.pos < 10 then
                        obj.dead = true
                        server.removeObject(i)
                    end
                end
            elseif obj.pos.x > 1920 or obj.pos.x<0 or obj.pos.y > 1080 or obj.pos.y<0 then server.removeObject(i) end
        end
    end
end

function game.getClientData(object)
  local data = object:getDrawData()
  data.trash = object.trash --include trash
  return data
end

function game.createObject(objectType,request)
    local object
    if objectType == 'player' then object = Player:obj({clientID=request.clientID}) end
    if objectType == 'bullet' then object = Bullet:obj({vel=request.vel,ownerID=request.ownerID}) end
    object.pos = request.pos or Vec()
    server.addObject(object,game.getClientData(object))
    return object
end

function game.useAbility(name,request,objects)
  if not objects[request.id].dead then
    if name=='waterSpray' then
      for i=-5,5 do game.createObject('bullet',{vel=request.dir:rotate(i/10)*200,pos=objects[request.id].pos,ownerID=request.id}) end
    end
  end
end

return game
