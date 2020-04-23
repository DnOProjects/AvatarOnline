local hud = {}

local elements = {}
local elementTypes = {
  meter = Class:new('hudMeter',{p=0,col=Col(1,1,1),pos=Vec(),roundedness=1,border=0.1,size=Vec(100,30),
  draw=function(self)
    --Outline
    local r = self.roundedness * self.size.y * 0.4
    Col():use()
    love.graphics.rectangle('fill',self.pos.x,self.pos.y,self.size.x,self.size.y,r,r,100)
    --Internal bar
    local b = self.size.y*self.border
    local r = self.roundedness * (self.size.y-2*b) * 0.4
    Col(0.2,0.2,0.2):use()
    love.graphics.rectangle('fill',self.pos.x+b,self.pos.y+b,self.size.x-2*b,self.size.y-2*b,r,r,100)
    self.col:use()
    love.graphics.rectangle('fill',self.pos.x+b,self.pos.y+b,(self.size.x-2*b)*self.p,self.size.y-2*b,r,r,100)
    Col(1,1,1):use()
  end})
}

function hud.add(args)
  local element = elementTypes[args.type]:obj(args)
  table.insert(elements,element)
  return element
end
function hud.remove(element) element.trash = true end

function hud.update(dt)
  for i=#elements,1,-1 do
    if hud[i].trash then table.remove(elements,i) end
  end
end
function hud.draw()
  for i, element in ipairs(elements) do element:draw() end
end

return hud
