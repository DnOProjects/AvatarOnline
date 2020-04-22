local graphics = {}

function graphics.draw(objects)
  for x=0,10 do
    for y=0,10 do
      love.graphics.draw(assets.get('image','dirt'),x*200,y*200)
    end
  end

  for i,obj in ipairs(objects) do
    if not obj.trash then
      local pos = obj.pos
      if obj.path then pos = obj.path.start + obj.path.vel*obj.path.time end
      if obj.bullet then
        love.graphics.draw(assets.get('image','water'),pos.x,pos.y,0,1/6,1/6,60,60)
      elseif obj.player then
        player.draw(i, pos)
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
