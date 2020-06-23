return Object:new('bubble',
  {bullet=true,
  hitR=12,
  vel=Vec(),
  ownerID=nil,
  onTouches=function(self,object)
    if object.player and self.ownerID~=object.id then object:damage(5) end
  end,
  getDrawData=function(self)
    return {path={start=self.pos,vel=self.vel,time=0},img='water',h=self.height,light={col=Col(0.5,0.5,1),intensity=1,spread=50}}
  end
  }
)
