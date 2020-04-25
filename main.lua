--Global classes
require 'src/classes/class'
require 'src/classes/vector'
require 'src/classes/color'
Constructors = {vector = ConstructVec, color = ConstructCol}
--Global modules
enet = require 'enet' --built-in module
assets = require 'src/assets'
debugger, input, objMan, utils = require 'src/debugger', require 'src/input', require 'src/objectManager', require 'src/utils'
graphics, scale, hud, ui = require 'src/graphics/graphics', require 'src/graphics/scale', require 'src/graphics/hud', require 'src/graphics/ui'
client, server, bitser, net = require 'src/network/client', require 'src/network/server', require 'src/network/bitser', require 'src/network/net'
Object, Player = require 'src/game/object', require 'src/game/player'
game = require 'src/game/game'
--Global variables
Objects = 'unbound' --a reference to the active node's objects list
Hosting = false --True: runs a server and a client; False: runs just a client
Ip = 'localhost'
if not Hosting then
	Ip = 'localhost'--'92.62.10.253'
end
Port = '25565'

function love.load()
	love.window.setFullscreen(true)
	client.load()
end

function love.update(dt)
	scale.update()
	debugger.update(dt)
	server.update(dt)  --Gets clients' requests, runs the game, sends instructions to clients
	client.update(dt) --Gets server's instructions, sends requests to server
end

local function circle(pos,fillCol,lineCol,r) --temp
	fillCol:use()
	love.graphics.circle("fill",pos.x,pos.y,r)
	lineCol:use()
	love.graphics.circle("line",pos.x,pos.y,r)
end
local z=0
local function drawTestPi()
	z=z+2
	if z>100 then z=100 end
	local pos, r1,r2,r3, a, w = Vec(800,400), z^0.84,z^1.15,z^1.23, 0.5, z/10
	circle(pos,Col(0.2,0.2,0.2,a),Col(1,1,1,a),r3)
	for dir=1/12,1,1/12 do
		if dir%(1/3)>0 then
			local a = pos+VecPol(r2+w/2,dir*math.pi*2)
			local b = pos+VecPol(r3,dir*math.pi*2)
			love.graphics.line(a.x,a.y,b.x,b.y)
		end
	end
	love.graphics.setLineWidth(w)
	circle(pos,Col(0,0,0,0),Col(1,1,1,a),r2)
	for dir=1/3,1,1/3 do
		local a = pos+VecPol(r1+w/2,dir*math.pi*2)
		local b = pos+VecPol(r3,dir*math.pi*2)
		love.graphics.line(a.x,a.y,b.x,b.y)
	end
	circle(pos,Col(0,0,0,0),Col(1,1,1,a),r1)
	love.graphics.setLineWidth(1)
	Col(1,1,1):use()
end


function love.draw()
	love.graphics.push()
	scale.draw()

	ui.drawBackgrounds()
	client.draw()
--	if Hosting then server.draw() end --for debug ONLY
  	debugger.draw()

		--drawTestPi()--just a thing for testing:



	love.graphics.pop()

end
