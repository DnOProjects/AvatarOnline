local graphics = {}

function graphics.pathPos(path) return path.start + path.vel*path.time end
function graphics.objPos(object)
  if object.path then return graphics.pathPos(object.path) end
  if object.pos then return object.pos end
end

function graphics.draw()
  love.graphics.setShader(Shader)

  for h=-1,1 do --draw 3 heights in sequence
    --Send light info to the shader (temp atm)
    if (enableShaders == true) then
      for i,obj in ipairs(Objects) do
        if obj.light and not obj.trash and obj.h>=h  then
          local intensity,spread,type,dir,length,col, endPos = obj.light.intensity or 1, obj.light.spread or 50, 'point', obj.light.dir, obj.light.length, obj.light.col, obj.light.endPos
          if endPos then endPos = endPos:gameToScreen() end
          if obj.light.length or obj.light.endPos then type='line' end
          if obj.light.flash then --flash is a percentage
            local a,b = (1-obj.light.flash)*50, 100-(1-obj.light.flash)*50
            spread = math.random(a,b)/100*spread
            col = col:overBrighten(math.random(0,obj.light.flash*100)/100):mix(ColRand(),0.8)
          end
          shaderMan.light(graphics.objPos(obj):gameToScreen(),{col=col,intensity=intensity,spread=spread,type=type,dir=dir,length=length,endPos=endPos})
        end
      end
      shaderMan.send() --must be called after all calls to shaderMan.light
    end

    --Draw map
    map.drawLayer(h)

    --Draw object shadow
    for i,obj in ipairs(Objects) do
      if (not obj.trash) and (not obj.dead) and obj.h==h and obj.img then
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
            Col(0.2,0.2,0.2,a):use()
            love.graphics.circle('fill',pos.x,pos.y,size)
          end
        end
      end
    end
    Col(1,1,1):use()

    --Draw objects
    for i,obj in ipairs(Objects) do
      if (not obj.trash) and (not obj.dead) and obj.h==h and obj.img then
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
