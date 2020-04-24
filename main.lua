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
Hosting = true --True: runs a server and a client; False: runs just a client
Ip = 'localhost'
if not Hosting then
	Ip = '92.62.10.253'
end
Port = '25565'

function love.load()
	client.load()
end

function love.update(dt)
	scale.update()
	debugger.update(dt)
	server.update(dt)  --Gets clients' requests, runs the game, sends instructions to clients
	client.update(dt) --Gets server's instructions, sends requests to server
end

function love.draw()
	love.graphics.push()
	scale.draw()

	ui.drawBackgrounds()
	client.draw()
--	if Hosting then server.draw() end --for debug ONLY
  	debugger.draw()

	love.graphics.pop()
end
