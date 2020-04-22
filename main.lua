--Global classes
require 'src/classes/class'
require 'src/classes/vector'
require 'src/classes/color'
Constructors = {vector = ConstructVec, color = ConstructCol}
--Global modules
enet = require 'enet' --built-in module
assets = require 'src/assets'
debug, input, objMan, utils = require 'src/debugger', require 'src/input', require 'src/objectManager', require 'src/utils'
client, server, bitser, net = require 'src/network/client', require 'src/network/server', require 'src/network/bitser', require 'src/network/net'
graphics = require 'src/graphics/graphics'
scale = require 'src/graphics/scale'
ui = require 'src/graphics/ui'
Object, Player = require 'src/game/object', require 'src/game/player'
game = require 'src/game/game'
--Global variables
Objects = 'unbound' --a reference to the active node's objects list

local host = false --True: runs a server and a client; False: runs just a client
local ip = 'localhost'
if not host then
	ip = 'localhost'--'92.62.10.253'
end
local port = '25565'

function love.load()
	scale.load()
	if host then server.start('*:'..port) end
	client.connect(ip..':'..port)
	ui.load()
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

	ui.drawBackgrounds()
	if currentPage =="inGame" then client.draw() end
--	if host then server.draw() end --for debug ONLY
  debug.draw()
  ui.draw()

	love.graphics.pop()
end
