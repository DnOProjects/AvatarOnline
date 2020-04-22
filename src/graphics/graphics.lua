local graphics = {}

function graphics.draw(objects)
  for x=0,10 do
    for y=0,10 do
      love.graphics.draw(assets.get('image','dirt'),x*200,y*200)
    end
  end

  for i,obj in ipairs(objects) do
    if not obj.trash then
      local pos
      --Find pos
      if obj.pos then pos = obj.pos end
      if obj.path then pos = obj.path.start + obj.path.vel*obj.path.time end

      if obj.img=='bullet' then
        love.graphics.draw(assets.get('image','water'),pos.x,pos.y,0,1/6,1/6,60,60)
      elseif obj.img=='player' then
        local char = 'katara'
        if i~=client.playerID then char = 'iroh' end
        love.graphics.draw(assets.get('image',char),pos.x,pos.y,0,1,1,60,60)
      end
      love.graphics.setColor(1, 1, 1)
    end
  end
end

function graphics.update(dt,objects)
  for i,obj in ipairs(objects) do
    if not obj.trash then
      if obj.path then obj.path.time = obj.path.time + dt end
    end
  end
end

return graphics
