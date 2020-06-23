local Laser = Object:new('laser',
  {bullet=true,
  hitR=25,
  vel=Vec(),
  ownerID=nil,
  removeOOB=false,
  initialise = function(self,request) self:newEnd(request.dir,request.length) end,
  onTouches=function(self,object)
    if object.player and self.ownerID~=object.id then object:damage(5) end
  end,
  getDrawData=function(self)
    return {pos=self.pos,h=self.height,light={col=Col(1,0,0),flash=0.6,intensity=10,spread=5,endPos=self.hitEnd}}
  end
  }
)

function Laser:newEnd(dir,length)
  self.hitEnd = self.pos + dir*length
end

return Laser
