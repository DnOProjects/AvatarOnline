local Object = require 'src/game/object'

local Player = Object:new('player',{player=true,hp=0,hitR=37,maxHp=100,dead=false,lastR=0,clientID=nil,getDrawData=function(self)
  return {pos=self.pos,img='katara',r=self.lastR,dead=self.dead}
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
  if not self.dead then
    if name=='waterSpray' then
      for i=-5,5 do game.createObject('bullet',{vel=request.dir:rotate(i/10)*200,pos=self.pos,ownerID=request.id}) end
    end
    if name=='bubble' then game.createObject('bullet',{vel=request.dir*200,pos=self.pos,ownerID=request.id}) end
  end
end

function Player:onCreate() self:setHp(self.maxHp) end
function Player:setHp(x)
  self.hp = x
  if self.hp<0 then self.hp = 0 end
  server.requestSetGlobal('hp',self.hp,self.clientID)
  if self.hp==0 then self:die() end
end
function Player:die()
  self.dead = true
  server.request({},'youDied',self.clientID)
  server.updateClientData(self)
end
function Player:damage(x) self:setHp(self.hp-x) end
function Player:respawn()
  self.dead = false
  self:setHp(self.maxHp)
  server.updateClientData(self)
end

return Player
