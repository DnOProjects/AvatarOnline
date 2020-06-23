local Player = Object:new('player',{player=true,hp=0,hitR=37,maxHp=100,dead=false,lastR=0,clientID=nil,
getDrawData=function(self)
  return {pos=self.pos,img='katara',r=self.lastR,dead=self.dead,hpP=self.hp/self.maxHp,h=self.height}
end})

function Player:move(request)
  local speed, oldPos, oldHeight, sliding = 5, utils.copy(self.pos), self.height, false
  self.pos = self.pos+request.vec*speed

  --Test for collision with screen boundries
  local p = self.pos + VecSquare(CliffWidth)*self.height
  if p.x+self.hitR>1920 or p.x-self.hitR<0 or p.y+self.hitR>1080 or p.y-self.hitR<0 then self.pos = utils.copy(oldPos) end

  for i=1,2 do
    if not self:onGround() then
      self.height = self.height - 1
      self.pos = self.pos + VecSquare(CliffWidth)
    end
 end

 --Resolve collision with pillar
 if self:touchingPillar() then
    self.pos.y = self.pos.y - speed*request.vec.y
    if self:touchingPillar() then
      self.pos.y = self.pos.y + speed*request.vec.y
      self.pos.x = self.pos.x - speed*request.vec.x
      if self:touchingPillar() then self.pos = utils.copy(oldPos) end
    end
  end

  self.lastR = request.vec:getDir()+math.pi/2
  server.updateClientData(self)
end

function Player:triggerAbilityMouseMoves(newPos)
  if self.heldAbilities then
    for i=1,#self.heldAbilities do
      local holdData = self.heldAbilities[i]
      local ability = abilities[holdData.name]
      if ability.mouseMovedWhileHeld then ability:mouseMovedWhileHeld(self,holdData,newPos) end
    end
  end
end

function Player:triggerAbility(name,request)
  if not self.dead then --todo: check if enough mana as well
    local ability = abilities[name]
    if ability then
      if request.press then
        local holdData = {}
        ability:pressed(self,request,holdData)
        if ability.castMode=='hold' then
          server.request({flag='releases',value=true},'setInputFlag',self.clientID) --request the client to listen for the key's release
          server.request({flag='presses',value=false},'setInputFlag',self.clientID) --deny any more presses until ability ceases
          self.heldAbilities = self.heldAbilities or {}
          holdData.name = name
          holdData.pressRequest = request
          table.insert(self.heldAbilities,holdData) --save to held abilities, saving the original request data
        end
      else
        ability:released(self,request)
        server.request({flag='releases',value=false},'setInputFlag',self.clientID) --stop listening for releases
        server.request({flag='presses',value=true},'setInputFlag',self.clientID) --allow more presses
        for i=1,#self.heldAbilities do --remove ability from held abilities
          if self.heldAbilities[i].name==name then
            table.remove(self.heldAbilities,i)
            break
          end
        end
      end
    end
  end
end
function Player:update()
  if self.heldAbilities then
    for i=1,#self.heldAbilities do
      local holdData = self.heldAbilities[i]
      abilities[holdData.name]:held(self,holdData)
    end
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
