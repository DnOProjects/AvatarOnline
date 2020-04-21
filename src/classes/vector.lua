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
function VecMouse() return Vec(love.mouse.getX(),love.mouse.getY()) end
function VecSize(object) return Vec(object:getWidth(),object:getHeight()) end
function VecWin() return VecSize(love.graphics) end
function VecPol(mag,dir) return Vec(math.cos(dir),math.sin(dir))*mag end
function ConstructVec(args) return Vec(args.x,args.y) end
Cardinals = {Vec(0,1),Vec(1,0),Vec(-1,0),Vec(0,-1)}

function Vector:print() print('x: '..self.x..', y: '..self.y) end
function Vector:floor() return Vec(math.floor(self.x),math.floor(self.y)) end
function Vector:abs() return Vec(math.abs(self.x),math.abs(self.y)) end
function Vector:getMag() return math.sqrt(self.x^2+self.y^2) end
function Vector:setMag(x) return (self/self:getMag())*x end
function Vector:getDir() return math.atan2(self.y,self.x) end
function Vector:setDir(x) return VecPol(self:getMag(),x) end
function Vector:rotate(x) return self:setDir(self:getDir()+x) end
