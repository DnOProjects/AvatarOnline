local input = {}

local moveDirs = {w=Vec(0,-1),a=Vec(-1,0),s=Vec(0,1),d=Vec(1,0)}
local mousepresses = {} --stores mousepresses until updating input
local function handleMousepress(press)
    if press.button==1 then
        local dir = (press.pos-client.player.pos):setMag(1)
        client.request({dir=dir,id=client.playerID,name='waterSpray'},'useAbility')
    end
end

function input.update(dt)
    for i=1,#mousepresses do
        handleMousepress(mousepresses[i])
    end
    mousepresses = {} --reset for next time

    local moveDir = Vec()
    for k,v in pairs(moveDirs) do
        if love.keyboard.isDown(k) then
            moveDir = moveDir+v*5
        end
    end
    if moveDir~=Vec() then
        client.request({vec=moveDir,id=client.playerID},'movePlayer')
    end
end

function love.mousepressed(x,y,button)
    table.insert(mousepresses,{pos=Vec(mouseX,mouseY),button=button})
end

return input
