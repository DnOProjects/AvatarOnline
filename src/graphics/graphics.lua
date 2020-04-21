local graphics = {}

function graphics.draw(objects)
  for x=0,10 do
    for y=0,10 do
      love.graphics.draw(assets.get('image','dirt'),x*200,y*200)
    end
  end

  for i,obj in ipairs(objects) do
    if obj.bullet then love.graphics.setColor(1, 0, 0) end
    if not obj.trash then love.graphics.circle('fill',obj.pos.x,obj.pos.y,10) end
    love.graphics.setColor(1, 1, 1)
  end
end

return graphics
