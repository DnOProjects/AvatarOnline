local player = {}

function player.updateGame(i, player, objects)
    for j, obj in ipairs(objects) do
        if obj.bullet and obj.data.ownerID~=player.id and obj.pos..player.pos < 10 then
            print("DEATH!")
            server.removeObject(i)
        end
    end
end

function player.updateInput(mousepresses, moveDirs)
    for i=1,#mousepresses do
        input.handleMousepress(mousepresses[i])
    end
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

local function calculateRadians(playerPos)
    local xDiff = mouseX - playerPos.x
    local yDiff = mouseY - playerPos.y
    local radians = 0
    local opposite = math.abs(xDiff)
    local adjacent = math.abs(yDiff)
    if (xDiff < 0 ) then
        radians = radians + utils.degreesToRadians(180)
        if (yDiff < 0) then
            radians = radians + utils.degreesToRadians(90)
            opposite = math.abs(yDiff)
            adjacent = math.abs(xDiff)
        end
    elseif (yDiff > 0) then
        radians = radians + utils.degreesToRadians(90)
        opposite = math.abs(yDiff)
        adjacent = math.abs(xDiff)
    end
    return radians + math.atan(opposite / adjacent)
end

function player.draw(i, playerPos)
    local char = 'katara'
    if i~=client.playerID then char = 'iroh' end
    love.graphics.draw(assets.get('image',char),playerPos.x,playerPos.y,calculateRadians(playerPos),1,1,60,60)
end

return player
