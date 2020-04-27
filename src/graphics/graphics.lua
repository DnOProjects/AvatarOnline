local graphics = {}

function graphics.pathPos(path) return path.start + path.vel*path.time end

function graphics.draw()
  love.graphics.setShader(Shader)

  for h=-1,1 do --draw 3 heights in sequence
    --Send light info to the shader (temp atm)
    for i,obj in ipairs(Objects) do
      if not obj.trash and obj.path and obj.h>=h then
        shaderMan.light(graphics.pathPos(obj.path),{col=Col(1,1,1),intensity=0.5,spread=100})
      end
    end
    shaderMan.light(Vec(500,500),{col=ColRand(),intensity=3,spread=math.random(1,20),type='line',dir=math.pi*(math.sin(love.timer.getTime())+1),length=10000})
    shaderMan.send() --must be called after all calls to shaderMan.light

    --Draw map
    map.drawLayer(h)

    --Draw object shadow
    for i,obj in ipairs(Objects) do
      if (not obj.trash) and (not obj.dead) and obj.h==h then
        local pos
        --Find pos
        if obj.pos then pos = obj.pos end
        if obj.path then pos = graphics.pathPos(obj.path) end
        local tilePos = ((pos+VecSquare(CliffWidth*h))/TileSize):floor()+VecSquare(1)
        if Grid[tilePos.x]~=nil and Grid[tilePos.x][tilePos.y]~=nil then
          local tileH = Grid[tilePos.x][tilePos.y].h
          local heightDiff = h - tileH

          if heightDiff>0 then
            pos = pos + VecSquare(CliffWidth*heightDiff)
            local a, size = 0.4, 20
            if heightDiff==2 then a, size = 0.2, 30 end
            Col(0,0,0,a):use()
            love.graphics.circle('fill',pos.x,pos.y,size)
          end
        end
      end
    end
    Col(1,1,1):use()

    --Draw objects
    for i,obj in ipairs(Objects) do
      if (not obj.trash) and (not obj.dead) and obj.h==h then
        local pos
        --Find pos
        if obj.pos then pos = obj.pos end
        if obj.path then pos = graphics.pathPos(obj.path) end

        assets.draw(obj.img,pos,obj.r or 0,1)
      end
    end
  end
  love.graphics.setShader()

  if DEBUG.drawGrid then --Debug grid height 0
    for x=1,GridSize.x do
      for y=1,GridSize.y do
        local pos = Vec(x-1,y-1)*TileSize
        love.graphics.rectangle('line',pos.x,pos.y,TileSize,TileSize)
      end
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
