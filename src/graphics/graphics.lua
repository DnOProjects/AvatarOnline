local graphics = {}

function graphics.draw()
  for x=0,10 do
    for y=0,10 do
      love.graphics.draw(assets.get('image','dirt'),x*200,y*200)
    end
  end

  for i,obj in ipairs(Objects) do
    if not obj.trash then
      local pos
      --Find pos
      if obj.pos then pos = obj.pos end
      if obj.path then pos = obj.path.start + obj.path.vel*obj.path.time end

      assets.draw(obj.img,pos,obj.r or 0,1)
    end
  end
end

function graphics.update(dt)
  for i,obj in ipairs(Objects) do
    if not obj.trash then
      if obj.path then obj.path.time = obj.path.time + dt end
    end
  end
end

return graphics
