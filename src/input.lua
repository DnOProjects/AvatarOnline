local input = {}

local moveDirs = {w=Vec(0,-1),a=Vec(-1,0),s=Vec(0,1),d=Vec(1,0)}
local toRequest = {} --requests stored to submit when client next looks for them

function input.update(dt)
    for i=1,#toRequest do
        client.request(toRequest[i].request,toRequest[i].requestType)
    end
    toRequest = {} --reset for next time

    local moveDir = Vec()
    for k,v in pairs(moveDirs) do
        if love.keyboard.isDown(k) then
            moveDir = moveDir+v
        end
    end
    if moveDir~=Vec() then
        client.request({vec=moveDir,id=client.playerID},'movePlayer')
    end
end

function input.abilityTriggered(abilityName,press) --press=true if on press; false if on release
   if press or utils.inList(abilityName,client.abilitiesWaitingToRelease) then
     local dir = (VecMouse()-client.player.pos):setMag(1)  --only sends release trigger if the server is waiting for such an input
     table.insert(toRequest,{request={dir=dir,id=client.playerID,name=abilityName,press=press}, requestType='triggerAbility'})
   end
end

function love.mousepressed(x,y,button) hud.handleInputEvent({type='mousepress',pos=Vec(mouseX,mouseY),button=button}) end
function love.mousereleased(x, y, button) hud.handleInputEvent({type='mouserelease',pos=Vec(mouseX,mouseY),button=button}) end
function love.keypressed(key) hud.handleInputEvent({type='keypress',key=key}) end

return input
