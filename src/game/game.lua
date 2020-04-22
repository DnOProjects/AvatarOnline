local game = {}

local Bullet = Object:new('bullet',{bullet=true,vel=Vec(),ownerID=nil,getDrawData=function(self)
  return {path={start=self.pos,vel=self.vel,time=0},img='water'}
end})

function game.update(dt)
    for i, obj in ipairs(Objects) do
        if not obj.trash then
            if obj.vel then obj.pos = obj.pos+obj.vel*dt end --apply velocity
            if obj.player then
                for j, objB in ipairs(Objects) do
                    if objB.bullet and objB.ownerID~=obj.id and objB.pos..obj.pos < 12 then
                        server.removeObject(i)
                    end
                end
            elseif obj.pos.x > 1920 or obj.pos.x<0 or obj.pos.y > 1080 or obj.pos.y<0 then server.removeObject(i) end
        end
    end
end

function game.createObject(objectType,request)
    local object
    if objectType == 'player' then object = Player:obj({clientID=request.clientID}) end
    if objectType == 'bullet' then object = Bullet:obj({vel=request.vel,ownerID=request.ownerID}) end
    object.pos = request.pos or Vec()
    server.addObject(object)
    return object
end

return game
