local Laser = Object:new('laser',
  {bullet=true,
  hitR=25,
  vel=Vec(),
  ownerID=nil,
  removeOOB=false,
  dps = 20,

  dir, length = 0,1,

  onCreate=function(self,request)
    self:setDir(request.dir)
    self:setLength(request.length)
    self:updateEnd()
  end,
  updateTouch=function(self,object,dt)
    if object.player and self.ownerID~=object.id and (self.activation or 1)==1 then object:damage(self.dps*dt) end
  end,
  getDrawData=function(self)
    local scaler = (self.activation^5 or 1)
    return {pos=self.pos,h=self.height,light={col=Col(1,0,0),flash=0.6,intensity=10*scaler,spread=3*scaler + 2,endPos=self.hitEnd}}
  end
  }
)

function Laser:updateEnd()
  self.hitEnd = self.pos + self.dir*self.length --set end to max
  --Generate list of possible colliders (cliff walls)
  local colliders = {}
  for x=1,GridSize.x do
    for y=1,GridSize.y do
      if Grid[x][y].h>self.height then
        --Find corners a,b,c&d
        local a = Vec(x-1,y-1)*200
        local b,c,d = a+Vec(200,0), a+Vec(0,200), a+Vec(200,200)
        colliders[#colliders+1] = Line(a,b)
        colliders[#colliders+1] = Line(a,c)
        colliders[#colliders+1] = Line(b,d)
        colliders[#colliders+1] = Line(c,d)
      end
    end
  end
  local collision = Line(self.pos,self.hitEnd):closestIntersection(colliders)
  if collision then self.hitEnd = collision end
  server.updateClientData(self)
end
function Laser:setDir(dir)
  self.dir = dir:setMag(1)
  self:updateEnd()
end
function Laser:setLength(length)
  self.length = length
  self:updateEnd()
end

return Laser
