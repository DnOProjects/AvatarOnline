local Object = require 'src/game/object'

local Player = Object:new('player',{player=true,lastR=0,clientID=nil,getDrawData=function(self)
  return {pos=self.pos,img='katara',r=self.lastR}
end})

function Player:move(request)
  local newPos = self.pos+request.vec
  if newPos.x<0 then newPos.x=0 end
  if newPos.x>1920 then newPos.x=1920 end
  if newPos.y<0 then newPos.y=0 end
  if newPos.y>1080 then newPos.y=1080 end
  self.pos = newPos
  self.lastR = request.vec:getDir()+math.pi/2
  server.updateClientData(self)
end

function Player:useAbility(name,request)
  if not self.trash then
    if name=='waterSpray' then
      for i=-5,5 do game.createObject('bullet',{vel=request.dir:rotate(i/10)*200,pos=self.pos,ownerID=request.id}) end
    end
  end
end

return Player
