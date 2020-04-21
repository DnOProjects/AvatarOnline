--Global classes
require 'src/classes/class'
require 'src/classes/vector'
require 'src/classes/color'
Constructors = {vector = ConstructVec, color = ConstructCol}
--Global modules
enet = require 'enet' --built-in module
assets = require 'assets/assets'
debug, input, objMan, utils = require 'src/debugger', require 'src/input', require 'src/objectManager', require 'src/utils'
client, server, bitser, net = require 'src/network/client', require 'src/network/server', require 'src/network/bitser', require 'src/network/net'
graphics = require 'src/graphics/graphics'
scale = require 'src/graphics/scale'
game = require 'src/game/game'

local host = true --True: runs a server and a client; False: runs just a client
local ip = 'localhost'
if (host == false) then
	ip = '92.62.10.253'
end
local port = '25565'

function love.load()
	scale.load()
	if host then server.start('*:'..port) end
	client.connect(ip..':'..port)
end

function love.update(dt)
	scale.update()
	debug.update(dt)
	if host then server.update(dt) end --Gets clients' requests, runs the game, sends instructions to clients
	client.update(dt) --Gets server's instructions, sends requests to server
end

function love.draw()
	love.graphics.push()
	scale.draw()

	client.draw() --Draws the game from the client's incomplete store of game objects
  	debug.draw()

	love.graphics.pop()
end
