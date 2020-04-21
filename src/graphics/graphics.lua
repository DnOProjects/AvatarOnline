local graphics = {}

function graphics.draw(objects)
  for x=0,10 do
    for y=0,10 do
      love.graphics.draw(assets.get('image','dirt'),x*200,y*200)
    end
  end

  for i,obj in ipairs(objects) do
    if not obj.trash then
      if obj.bullet then
        love.graphics.draw(assets.get('image','water'),obj.pos.x,obj.pos.y,0,1/6)
      elseif obj.player then
        local char = 'katara'
        if i~=client.playerID then char = 'iroh' end
        love.graphics.draw(assets.get('image',char),obj.pos.x,obj.pos.y,0,1,1,60,60)
      end
      love.graphics.setColor(1, 1, 1)
    end
  end
end

return graphics
