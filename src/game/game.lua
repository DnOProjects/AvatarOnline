local game = {}

local Bullet = Object:new('bullet',{bullet=true,hitR=12,vel=Vec(),ownerID=nil,
onTouches=function(self,object)
  if object.player and self.ownerID~=object.id then object:damage(5) end
end,
getDrawData=function(self)
  return {path={start=self.pos,vel=self.vel,time=0},img='water'}
end})

function game.update(dt)
    for i, object in ipairs(Objects) do
      if object.pos.x > 1920 or object.pos.x<0 or object.pos.y > 1080 or object.pos.y<0 then server.removeObject(i) end
        if (not object.trash) and (not object.dead) then
            object:updateTouches()
            if object.vel then object.pos = object.pos+object.vel*dt end --apply velocity
        end
    end
end

function game.createObject(objectType,request)
    local object
    if objectType == 'player' then object = Player:obj({clientID=request.clientID}) end
    if objectType == 'bullet' then object = Bullet:obj({vel=request.vel,ownerID=request.ownerID}) end
    object.pos = request.pos or Vec()
    server.addObject(object)
    object:onCreate()
    return object
end

return game
