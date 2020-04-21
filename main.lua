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
logic = require 'src/game/logic'

local host = true --True: runs a server and a client; False: runs just a client
local ip = 'localhost'--'92.62.10.253'
local port = '25565'

function love.load()
	mouseX = 0
	mouseY = 0
	gameRenderScale = love.graphics.getHeight()/1080
	if (gameRenderScale > love.graphics.getWidth()/1920) then
		gameRenderScale = love.graphics.getWidth()/1920
	end
	xPadding = (love.graphics.getWidth() - (1920 * gameRenderScale)) / 2
	yPadding = (love.graphics.getHeight() - (1080 * gameRenderScale)) / 2
	if host then server.start('*:'..port) end
	client.connect(ip..':'..port)
end

function love.update(dt)
	mouseX = love.mouse.getX() / gameRenderScale - xPadding
	mouseY = love.mouse.getY() / gameRenderScale - yPadding
	debug.update(dt)
	---  print("--------------server---------------")
	if host then server.update(dt) end --Gets clients' requests, runs the game, sends instructions to clients
	--  print("--------------client--------------")
	client.update(dt) --Gets server's instructions, sends requests to server
end

function love.draw()
	love.graphics.push()
	love.graphics.scale(gameRenderScale)
	love.graphics.translate(xPadding, yPadding)

	client.draw() --Draws the game from the client's incomplete store of game objects
	debug.draw()

	love.graphics.pop()
	
end
