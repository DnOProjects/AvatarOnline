local input = {}

local moveDirs = {w=Vec(0,-1),a=Vec(-1,0),s=Vec(0,1),d=Vec(1,0)}
local mousepresses = {} --stores mousepresses until updating input
local function handleMousepress(press)
  if press.button==1 then
    local vel = (press.pos-client.player.pos):setMag(10)
    for i=-3,3 do
      client.request({objectType='bullet',vel=vel:rotate(i/10),pos=client.player.pos,ownerID=client.playerID},'createObj')
    end
  end
end

function input.update(dt)
  if client.player then
    for i=1,#mousepresses do handleMousepress(mousepresses[i]) end
    mousepresses = {} --reset for next time

    local moveDir = Vec()
    for k,v in pairs(moveDirs) do
      if love.keyboard.isDown(k) then moveDir = moveDir+v*5 end
    end
    if moveDir~=Vec() then client.request({vec=moveDir,id=client.playerID},'moveObj') end
  end
end

function love.mousepressed(x,y,button) table.insert(mousepresses,{pos=Vec(x,y),button=button}) end

return input
