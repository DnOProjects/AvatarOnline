local logic = {}

function logic.update(dt,objects)
    for i, obj in ipairs(objects) do
        if not obj.trash then
            if obj.data.vel then server.moveObject(i,obj.data.vel) end --apply velocity
            if obj.player then
                for j, objB in ipairs(objects) do
                    if objB.bullet and objB.data.ownerID~=obj.id and objB.pos..obj.pos < 10 then
                        print("DEATH!")
                        server.removeObject(i)
                    end
                end
                if obj.pos.x > 1920 then
                    server.moveObject(i,Vec(-10, 0))
                elseif obj.pos.x < 0 then
                    server.moveObject(i,Vec(10, 0))
                elseif obj.pos.y > 1080 then
                    server.moveObject(i,Vec(0, -10))
                elseif obj.pos.y < 0 then
                    server.moveObject(i,Vec(0, 10))
                end
            end
        end
    end
end

function logic.createObject(objectType,request)
    local object
    if objectType == 'player' then object = {player=true,data={clientID=request.clientID}} end
    if objectType == 'bullet' then object = {bullet=true,data={vel=request.vel,ownerID=request.ownerID}} end
    object.pos = request.pos or Vec()

    server.addObject(object)
    return object
end

return logic
