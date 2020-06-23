return Object:new('laser',
  {bullet=true,
  hitR=25,
  vel=Vec(),
  ownerID=nil,
  initialise = function(self,request)
    self.hitEnd = self.pos + request.dir*request.length
  end,
  onTouches=function(self,object)
    if object.player and self.ownerID~=object.id then object:damage(5) end
  end,
  getDrawData=function(self)
    return {pos=self.pos,h=self.height,light={col=Col(1,0,0),flash=0.6,intensity=10,spread=5,endPos=self.hitEnd}}
  end
  }
)
