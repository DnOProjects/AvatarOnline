local Object = require 'src/game/object'

local Player = Object:new('player',{player=true,hp=0,hitR=37,maxHp=100,dead=false,lastR=0,clientID=nil,getDrawData=function(self)
  return {pos=self.pos,img='katara',r=self.lastR,dead=self.dead,hpP=self.hp/self.maxHp,h=self.height}
end})

function Player:setPos(pos)
  self.pos = pos
  if self.pos.x<0 then self.pos.x=0 end
  if self.pos.x>1920 then self.pos.x=1920 end
  if self.pos.y<0 then self.pos.y=0 end
  if self.pos.y>1080 then self.pos.y=1080 end
end

function Player:move(request)
  local speed, oldPos, sliding = 5, self.pos, false
  self:setPos(self.pos+request.vec*speed)
  for i=1,2 do if not self:onGround() then
    self.height = self.height - 1
    sliding = self:touchingPillar()
  end end
  if sliding then
    while sliding do
      self.pos = self.pos + request.vec
      sliding = self:touchingPillar()
    end
  elseif self:touchingPillar() then self.pos = oldPos end
  self.lastR = request.vec:getDir()+math.pi/2
  server.updateClientData(self)
end

function Player:useAbility(name,request)
  if not self.dead then
    if name=='waterSpray' then
      for i=-5,5 do game.createObject('bullet',{vel=request.dir:rotate(i/10)*200,pos=self.pos,ownerID=request.id,height=self.height}) end
    end
    if name=='bubble' then game.createObject('bullet',{vel=request.dir*200,pos=self.pos,ownerID=request.id,height=self.height}) end
  end
end

function Player:onCreate() self:setHp(self.maxHp) end
function Player:setHp(x)
  self.hp = x
  if self.hp<0 then self.hp = 0 end
  server.updateClientData(self)
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
