local map = {}

GridSize,TileSize,CliffWidth = Vec(9,5), 200, 50
local shadowWidth =  5 --px without scaling
local shadowSize = Vec(CliffWidth+shadowWidth,TileSize)

local stencilPos, stencilSize = Vec(),Vec()
local function stencil(pos,size,mode,value)
  local value = value or 1
  stencilPos, stencilSize = pos,size
  love.graphics.stencil(function()
    love.graphics.rectangle("fill",stencilPos.x,stencilPos.y,stencilSize.x,stencilSize.y)
  end,mode, value)
end
local function tileLower(pos,h) return Grid[pos.x]==nil or Grid[pos.x][pos.y]==nil or Grid[pos.x][pos.y].h<h end
local function tileOneHigher(pos,h) return Grid[pos.x]~=nil and Grid[pos.x][pos.y]~=nil and Grid[pos.x][pos.y].h==h+1 end
local function getTilePos(coords,h) return (coords-VecSquare(1))*TileSize-VecSquare(CliffWidth)*h end
local function drawQuadrant(tileCoords,tilePos,quadrantCoords)
  --Find n
  local h = Grid[tileCoords.x][tileCoords.y].h
  local n = 0
  if tileLower(tileCoords+Vec(quadrantCoords.x*2-1,0),h) then n=n+1 end --left/right
  if tileLower(tileCoords+Vec(0,quadrantCoords.y*2-1),h) then n=n+2 end --above/below

  stencil(tilePos+quadrantCoords*TileSize/2, VecSquare(TileSize)/2,'replace')
  love.graphics.setStencilTest('greater', 0)
  love.graphics.draw(assets.get('image','dirt/'..n),tilePos.x,tilePos.y)
  love.graphics.setStencilTest()
end
function map.setTile(pos,tile) Grid[pos.x][pos.y] = tile end
function map.drawLayer(h)
  --Draw tiles
  for x=1,GridSize.x do
    for y=1,GridSize.y do
      local pos = getTilePos(Vec(x,y),h)
      if Grid[x][y].h==h then
        local s = 0.8 + h*0.2 --slightly shade to indicate height
        Col(s,s,s):use()
        for qx=0,1 do
          for qy=0,1 do drawQuadrant(Vec(x,y),pos,Vec(qx,qy)) end
        end
        --Draw cliffs
        Col(1,1,1):use()
        if tileLower(Vec(x,y+1),h) then love.graphics.draw(assets.get('image','dirt/cliffBottom'),pos.x,pos.y+TileSize) end
        if tileLower(Vec(x+1,y),h) then love.graphics.draw(assets.get('image','dirt/cliffSide'),pos.x+TileSize,pos.y) end
      end
      --Draw double cliffs
      if h==0 and Grid[x][y].h==1 then
        if tileLower(Vec(x,y+1),0) then love.graphics.draw(assets.get('image','dirt/cliffBottom'),pos.x,pos.y+TileSize) end
        if tileLower(Vec(x+1,y),0) then love.graphics.draw(assets.get('image','dirt/cliffSide'),pos.x+TileSize,pos.y) end
      end
    end
  end

  --Draw tile shadows
  love.graphics.stencil(
  function()
    for x=1,GridSize.x do
      for y=1,GridSize.y do
        if Grid[x][y].h==h then
          if tileOneHigher(Vec(x,y+1),h) then --top shadow
            local p = getTilePos(Vec(x,y+1),h+1)
            love.graphics.rectangle('fill',p.x,p.y-shadowWidth,shadowSize.y+CliffWidth,shadowSize.x)
          end
          if tileOneHigher(Vec(x+1,y),h) then --left shadow
            local p = getTilePos(Vec(x+1,y),h+1)
            love.graphics.rectangle('fill',p.x-shadowWidth,p.y+CliffWidth,shadowSize.x,shadowSize.y)
          end
        end
      end
    end
  end,'replace',1)
  love.graphics.setColor(0,0,0,0.5)
  love.graphics.setStencilTest('greater', 0)
  love.graphics.rectangle('fill',0,0,1920,1080)
  love.graphics.setStencilTest()
  Col(1,1,1):use()
end

return map
