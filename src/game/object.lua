local Object = Class:new('object',{

  pos=Vec(),
  height = 1, --height from -1 to 1

  hitEnd=nil, --if nil, hitbox is considered as a cicle; if as Vector, hitbox considered as the locus, radius hitR, of the line segment from pos -> hitEnd
  hitR=0 --radius in px. when drawn without any scaling for the hitcircle (hitbox but circular)
})

--blank functions to be overridden
function Object:getDrawData() return {} end
function Object:onCreate(request) end --called once the object has been added to the game
function Object:initialise(request) end --called while the object is being created to add to the game
function Object:onTouches(object) end
function Object:onLeaves(object) end
function Object:setPos(pos) self.pos = pos end

function Object:create(request) --generic create function that calls the more specific obj function
  local object = self:obj(request)
  object.pos = request.pos or Vec()
  object.height = request.height or 1
  return object
end
function Object:getClientData()
  local data = self:getDrawData()
  data.trash = self.trash --include trash
  return data
end
function Object:touching(object)
  if self.hitEnd then
    if object.hitEnd then return false end --line - line collisions not currently supported
    return object.pos:distanceToLine(self.pos,self.hitEnd) < (object.hitR+self.hitR)
  end
  if object.hitEnd then return self.pos:distanceToLine(object.pos,object.hitEnd) < (object.hitR+self.hitR) end 
  return self.pos..object.pos < (object.hitR+self.hitR)
end
function Object:updateTouches()
  if not self.currentlyTouching then self.currentlyTouching = {} end --creates table if doesnt exist
  for i, object in ipairs(Objects) do --Add touching objects
      if self:touching(object) and (not utils.inList(object.id,self.currentlyTouching)) then
        table.insert(self.currentlyTouching,object.id)
        self:onTouches(object)
      end
  end
  for i=#self.currentlyTouching,1,-1 do --Remove touching objects
    local object = Objects[self.currentlyTouching[i]]
    if object==nil or (not self:touching(object)) then --no longer touching object if nil(removed) or not touching
      table.remove(self.currentlyTouching,i)
      self:onLeaves()
    end
  end
end

--Tile related:
function Object:touchingTile(tileCoords)
  local p = (tileCoords-VecSquare(1))*TileSize-VecSquare(CliffWidth)*self.height
  return self.pos.x+self.hitR > p.x and self.pos.x-self.hitR < p.x + TileSize and self.pos.y+self.hitR > p.y and self.pos.y-self.hitR < p.y + TileSize
end
function Object:touchingPillar()
  for x=1,GridSize.x do
    for y=1,GridSize.y do
      if Grid[x][y].h > self.height and self:touchingTile(Vec(x,y)) then return true end
    end
  end
  return false
end
function Object:onGround()
  for x=1,GridSize.x do
    for y=1,GridSize.y do
      if Grid[x][y].h == self.height and self:touchingTile(Vec(x,y)) then return true end
    end
  end
  return false
end
return Object
