local Color = Class:new("color",{r=0,g=0,b=0,a=0,
	meta = {__eq = function(a,b)
		return a.r==b.r and a.g==b.g and a.b==b.b and a.a==b.a
	end},
})
local function randDec() return math.random(0,100)/100 end

function Col(r,g,b,a)
	local a = a or 1
	return Color:obj({r=r,g=g,b=b,a=a})
end
function ColRand() return Col(randDec(),randDec(),randDec()) end
Colors = {white=Col(1,1,1),black=Col(0,0,0)}
function ConstructCol(args) return Col(args.r,args.g,args.b,args.a) end

function Color:list() return {self.r,self.g,self.b,self.a} end
function Color:use() love.graphics.setColor(self.r,self.g,self.b,self.a) end
function Color:setBackground() love.graphics.setBackgroundColor(self.r,self.g,self.b,self.a) end
function Color:equals(col) return self.r==col.r and self.g==col.g and self.b==col.b and self.a==col.a end

--Modifiers
function Color:setR(r) return Col(r,self.g,self.b,a) end
function Color:setG(g) return Col(self.r,g,self.b,a) end
function Color:setB(b) return Col(self.r,self.g,b,a) end
function Color:setA(a) return Col(self.r,self.g,self.b,a) end
function Color:setBrightness(x) return Col(self.r*x,self.g*x,self.b*x,self.a) end
function Color.mix(a,b,r)
	return Col(b.r+(a.r-b.r)*r,b.g+(a.g-b.g)*r,b.b+(a.b-b.b)*r,b.a+(a.a-b.a)*r)
end
