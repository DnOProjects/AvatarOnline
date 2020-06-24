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
  self.hitEnd = self.pos + self.dir*self.length
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
