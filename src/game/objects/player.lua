local Player = Object:new('player',{player=true,hp=0,hitR=37,maxHp=100,mana=0,maxMana=100,dead=false,lastR=0,clientID=nil,removeOOB=false,hudUpdateTimer=0,
  hudUpdatePeriod = 0.2 --[[seconds before player hud is refreshed]], manaRegen = 2, --mana/sec
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
        if self.mana>=ability.cost or (ability.castMode=='hold' and self.mana>0) then
          local holdData = {}
          server.updateClientData(self)
          ability:pressed(self,request,holdData)
          if ability.castMode=='hold' then
            self:setInputFlags('releases',true) --request the client to listen for the key's release
            self.heldAbilities = self.heldAbilities or {}
            holdData.name = name
            holdData.pressRequest = request
            table.insert(self.heldAbilities,holdData) --save to held abilities, saving the original request data
          else
            self.mana = self.mana - ability.cost
          end
        end
      else
        local holdData = nil
        for i=1,#self.heldAbilities do
          if self.heldAbilities[i].name==name then holdData=self.heldAbilities[i] end
        end
        if holdData~=nil then
          ability:released(self,request,holdData)
            self:setInputFlags('releases',false) --stop listening for releases
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
end

function Player:sendHUDStat(k,v) server.request({k=k,v=v},'setHudStat',self.clientID) end
function Player:setInputFlags(...)
  local args = {...}
  if #args%2==1 then error('Player:setInputFlags() takes arguements in form: flagname1,value1,flagname2,value2...') end
  for i=1,#args,2 do server.request({flag=args[i],value=args[i+1]},'setInputFlag',self.clientID) end
end

function Player:update(dt)
  if self.heldAbilities then --Update held abilities
    for i=1,#self.heldAbilities do
      local holdData = self.heldAbilities[i]
      local ability = abilities[holdData.name]
      ability:held(self,holdData,dt)
      self.mana = self.mana - ability.cost*dt
    end
  end

  if self.mana < 0 then self.mana = 0 end --Update mana
  if self.mana < self.maxMana then
    self.mana = self.mana + dt*self.manaRegen
    self.hudUpdateTimer = self.hudUpdateTimer + dt
    if self.hudUpdateTimer>self.hudUpdatePeriod then
      self:sendHUDStat('manaP',self.mana/self.maxMana)
      self.hudUpdateTimer = 0
    end
  else
    self.mana = self.maxMana
  end
end

function Player:onCreate()
  self.hp, self.mana = self.maxHp, self.maxMana
  server.updateClientData(self)
  self:sendHUDStat('manaP',self.mana/self.maxMana)
end
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
