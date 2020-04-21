local Color = Class:new("color",{r=0,g=0,b=0,a=0,
	meta = {__eq = function(a,b)
		return a.r==b.r and a.g==b.g and a.b==b.b and a.a==b.a
	end},
})

function Col(r,g,b,a)
	local a = a or 1
	return Color:obj({r=r,g=g,b=b,a=a})
end
Colors = {white=Col(1,1,1),black=Col(0,0,0)}
function ConstructCol(args) return Col(args.r,args.g,args.b,args.a) end
function ColMix(a,b,p) -- x: 1=fully a, 0=fullyb, 0.5=50:50 mix
	return Col(b.r+(a.r-b.r)*p,b.g+(a.g-b.g)*p,b.b+(a.b-b.b)*p,b.a+(a.a-b.a)*p)
end

function Color:list() return {self.r,self.g,self.b,self.a} end
function Color:use() love.graphics.setColor(self.r,self.g,self.b,self.a) end
function Color:setBackground() love.graphics.setBackgroundColor(self.r,self.g,self.b,self.a) end
function Color:equals(col) return self.r==col.r and self.g==col.g and self.b==col.b and self.a==col.a end
