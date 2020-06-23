abilities = {}
local Ability = Class:new('ability',{
  cost = 10,
  castMode = 'press', --Modes:
  -- press = pressed() called when button moved down
  -- hold = pressed() called when button moved down, held() called every frame button is down for, released() called when button released
  pressed = function(self,caster,request,holdData) end, --caster = player object that cast the ability, request = mic. info passed by client, holdData = optional table to fill with data to save for held abilities
  held = function(self,caster,pressRequest,holdData) end, --pressRequest = request originally used to trigger its press
  released = function(self,caster,request,holdData) end,
  mouseMovedWhileHeld = function(self,caster,holdData,newPos) end --called if a mouse-moved packet is recieved while the ability is being held
})
local function newAbility(name,args)
  args.name = name
  local ability = Ability:new(name,args)
  abilities[name] = ability
end

newAbility('waterSpray',{pressed = function(self,caster,request)
  for i=-5,5 do game.createObject('bubble',{vel=request.dir:rotate(i/10)*200,pos=caster.pos,ownerID=request.id,height=caster.height}) end
end})
newAbility('bubble',{pressed = function(self,caster,request)
  game.createObject('bubble',{vel=request.dir*200,pos=caster.pos,ownerID=request.id,height=caster.height})
end})
newAbility('Laser',{pressed = function(self,caster,request)
  game.createObject('laser',{dir=request.dir,pos=caster.pos+request.dir*100,length=10000,ownerID=request.id,height=caster.height})
end})

newAbility('Laser',{castMode = 'hold',
pressed = function(self,caster,request,holdData)
  caster:setInputFlags('mousePos',true,'moveKeys',false)
  local laser = game.createObject('laser',{dir=request.dir,pos=caster.pos+request.dir*100,length=10000,ownerID=request.id,height=caster.height})
  holdData.laser = laser --save a reference to the created object
end,
mouseMovedWhileHeld = function(self,caster,holdData,newPos)
  local dirChange = (newPos-holdData.laser.pos):setMag(0.1)
  holdData.laser:setDir(holdData.laser.dir+dirChange)
end,
released = function(self,caster,request,holdData)
  caster:setInputFlags('mousePos',false,'moveKeys',true)
  holdData.laser:remove()
end
})

newAbility('charge',{castMode = 'hold',
pressed = function(self,caster,request,holdData)
  caster:setInputFlags('mousePos',true)
  holdData.timer = 0
end,
held = function(self,caster,holdData)
  holdData.timer = holdData.timer + 1
  if holdData.timer == 10 then
    local dir = holdData.dir or holdData.pressRequest.dir
    local vel = (dir*math.random(200,300)):rotate(math.random(-50,50)/100)
    game.createObject('bubble',{vel=vel,pos=caster.pos,ownerID=holdData.pressRequest.id,height=caster.height})
    holdData.timer = 0
  end
end,
released = function(self,caster,request)
  caster:setInputFlags('mousePos',false)
end,
mouseMovedWhileHeld = function(self,caster,holdData,newPos)
  holdData.dir = (newPos-caster.pos):setMag(1)
end
})

return Ability
