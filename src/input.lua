local input = {}

local moveDirs = {w=Vec(0,-1),a=Vec(-1,0),s=Vec(0,1),d=Vec(1,0)}
local mousepresses = {} --stores mousepresses until updating input
function input.handleMousepress(press)
    if press.button==1 then
        local vel = (press.pos-client.player.pos):setMag(200)
        for i=-5,5 do
          client.request({objectType='bullet',vel=vel:rotate(i/10),pos=client.player.pos,ownerID=client.playerID},'createObj')
        end
    end
end

function input.update(dt)
    if client.player then
        player.updateInput(mousepresses, moveDirs)
        mousepresses = {} --reset for next time
    end
end

function love.mousepressed(x,y,button)
    table.insert(mousepresses,{pos=Vec(mouseX,mouseY),button=button})
end

return input
