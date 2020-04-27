local map = {}

GridSize,TileSize,CliffWidth = Vec(9,5), 200, 30
local shadowWidth =  20 --px without scaling

local stencilPos, stencilSize = Vec(),Vec()
local function stencil(pos,size,mode,value)
  local value = value or 1
  stencilPos, stencilSize = pos,size
  love.graphics.stencil(function()
    love.graphics.rectangle("fill",stencilPos.x,stencilPos.y,stencilSize.x,stencilSize.y)
  end,mode, value)
end
local function tileLower(pos,h) return Grid[pos.x]==nil or Grid[pos.x][pos.y]==nil or Grid[pos.x][pos.y].h<h end
local function tileHigher(pos,h) return Grid[pos.x]~=nil and Grid[pos.x][pos.y]~=nil and Grid[pos.x][pos.y].h>h end
local function tileLevel(pos,h) return Grid[pos.x]~=nil and Grid[pos.x][pos.y]~=nil and Grid[pos.x][pos.y].h==h end
local function getTilePos(coords,h) return (coords-VecSquare(1))*TileSize-VecSquare(CliffWidth)*h end
local function drawQuadrant(tileCoords,tilePos,quadrantCoords)
  --Find n
  local h = Grid[tileCoords.x][tileCoords.y].h
  local n = 0
  if not tileLevel(tileCoords+Vec(quadrantCoords.x*2-1,0),h) then n=n+1 end --left/right
  if not tileLevel(tileCoords+Vec(0,quadrantCoords.y*2-1),h) then n=n+2 end --above/below

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
        if tileLower(Vec(x,y+1),h) then love.graphics.draw(assets.get('image','dirt/cliff'),pos.x,pos.y+TileSize) end
        if tileLower(Vec(x+1,y),h) then love.graphics.draw(assets.get('image','dirt/cliff'),pos.x+TileSize+CliffWidth,pos.y+CliffWidth+TileSize,math.pi/2,-1,1) end
      end
      --Draw double cliffs
      if h==0 and Grid[x][y].h==1 then
        if tileLower(Vec(x,y+1),0) then love.graphics.draw(assets.get('image','dirt/cliff'),pos.x,pos.y+TileSize) end
        if tileLower(Vec(x+1,y),0) then love.graphics.draw(assets.get('image','dirt/cliff'),pos.x+TileSize+CliffWidth,pos.y+CliffWidth+TileSize,math.pi/2,-1,1) end
      end
    end
  end
end

return map
