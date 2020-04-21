local graphics = {}

function graphics.draw(objects)
  for i,obj in ipairs(objects) do
    if obj.bullet then love.graphics.setColor(1, 0, 0) end
    if not obj.trash then love.graphics.circle('fill',obj.pos.x,obj.pos.y,10) end
    love.graphics.setColor(1, 1, 1)
  end
end

return graphics
