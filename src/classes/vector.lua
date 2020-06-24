local Vector = Class:new('vector',{x=0,y=0,meta={
	__eq=function(a,b) return a.x==b.x and a.y==b.y end,
	__add=function(a,b) return Vec(a.x+b.x, a.y+b.y) end,
	__sub=function(a,b) return Vec(a.x-b.x, a.y-b.y) end,
	__mul=function(a,b)
		if type(b)=='number' then return Vec(a.x*b, a.y*b)
		elseif type(a)=='number' then return Vec(b.x*a, b.y*a)
		else error('Vectors can only be multiplied by numbers') end
	end,
	__div=function(a,b) return a*(1/b) end,
	__concat=function(a,b) return (a-b):getMag() end, --distance between
}})

function Vec(x,y)
	local x = x or 0
	local y = y or 0
	return Vector:obj({x=x,y=y})
end
function VecMouse() return Vec(love.mouse.getX(),love.mouse.getY())/gameRenderScale - Vec(xPadding,yPadding) end
function VecSquare(x) return Vec(x,x) end
function VecSize(object) return Vec(object:getWidth(),object:getHeight()) end
function VecWin() return VecSize(love.graphics) end
function VecPol(mag,dir) return Vec(math.cos(dir),math.sin(dir))*mag end
function ConstructVec(args) return Vec(args.x,args.y) end
Cardinals = {Vec(0,1),Vec(1,0),Vec(-1,0),Vec(0,-1)}

function Vector:print() print(self:getText()) end
function Vector:floor() return Vec(math.floor(self.x),math.floor(self.y)) end
function Vector:abs() return Vec(math.abs(self.x),math.abs(self.y)) end
function Vector:getMag() return math.sqrt(self.x^2+self.y^2) end
function Vector:setMag(x) return (self/self:getMag())*x end
function Vector:getDir() return math.atan2(self.y,self.x) end
function Vector:setDir(x) return VecPol(self:getMag(),x) end
function Vector:rotate(x) return self:setDir(self:getDir()+x) end
function Vector:getText() return 'x: '..self.x..', y: '..self.y end
function Vector:floor() return Vec(math.floor(self.x),math.floor(self.y)) end
function Vector:rotate(x) return self:setDir(self:getDir()+x) end
function Vector:drawPos(size) love.graphics.circle("fill",self.x,self.y,size or 5) end
function Vector:drawDir(pos)
	pos:drawPos()
	local stop = pos+self
	love.graphics.line(pos.x,pos.y,stop.x,stop.y)
	local arrowSize = 20
	local normal, tangent = self:setMag(-arrowSize), Vec(-self.y,self.x):setMag(arrowSize/2)
	local a,b,c = stop, stop+normal+tangent, stop+normal-tangent
	love.graphics.polygon("fill",a.x,a.y,b.x,b.y,c.x,c.y)
end
function Vector:dot(other) return self.x*other.x + self.y*other.y end
function Vector:angleAt(a,c) --returns the angle between points A,B&C where B is self
	local ba, bc = a-self, c-self
	return math.acos(ba:dot(bc)/(ba:getMag()*bc:getMag()))
end
function Vector:cardinalise()
	if self.y>self.x then return Vec(0,self.y) end
	return Vec(self.x,0)
end
function Vector:distanceToLine(a,b) -- line segment a-b (copied fctn from web), self is notated p
	--Edge cases where circle centered on the point p that just touches the line is not tangential
	if b:angleAt(a,self)>math.pi/2 then return b..self end
	if a:angleAt(b,self)>math.pi/2 then return a..self end

	local ap, ab = self-a, b-a
	local apMag, abMag = ap:getMag(), ab:getMag()
	return apMag * math.sin(math.acos(ap:dot(ab)/(apMag*abMag)))
end
