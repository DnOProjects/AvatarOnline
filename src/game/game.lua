local game = {}

function game.update(dt,objects)
    for i, obj in ipairs(objects) do
        if not obj.trash then
            if obj.data.vel then obj.pos = obj.pos+obj.data.vel*dt end --apply velocity
            if obj.player then
                player.updateGame(i, obj, objects)
            elseif obj.pos.x > 1920 or obj.pos.x < 0 or obj.pos.y > 1080 or obj.pos.y < 0 then
                server.removeObject(i)
            end
        end
    end
end

function game.createObject(objectType,request)
    local object
    if objectType == 'player' then object = utils.copy({player=true,data={clientID=request.clientID}}) end
    if objectType == 'bullet' then object = utils.copy({bullet=true,path={start=request.pos,vel=request.vel,time=0},data={vel=request.vel,ownerID=request.ownerID}}) end
    object.pos = request.pos or Vec()

    server.addObject(object)
    return object
end

return game
