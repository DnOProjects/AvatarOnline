--TODO:
--fix bug where pushing against a pillar thinks your a different ypos to the pillar so pushes you up so oob
--change cliff height to e.g. 30

--Global classes
require 'src/classes/class'
require 'src/classes/vector'
require 'src/classes/color'
Constructors = {vector = ConstructVec, color = ConstructCol}
--Global modules
enet = require 'enet' --built-in module
assets = require 'src/assets'
debugger, input, objMan, utils = require 'src/debugger', require 'src/input', require 'src/objectManager', require 'src/utils'
graphics, scale, hud, ui, shaderMan, map = require 'src/graphics/graphics', require 'src/graphics/scale', require 'src/graphics/hud', require 'src/graphics/ui', require 'src/graphics/shaderMan', require 'src/graphics/map'
client, server, bitser, net = require 'src/network/client', require 'src/network/server', require 'src/network/bitser', require 'src/network/net'
Object, Ability = require 'src/game/object', require 'src/game/ability'
game = require 'src/game/game'
--Global variables
Objects = 'unbound' --a reference to the active node's objects list
Grid = 'unbound' --a reference to the active node's grid
Shader = love.graphics.newShader("src/graphics/pixelshader.frag","src/graphics/vertexshader.vert")
Hosting = false --True: runs a server and a client; False: runs just a client
Ip = 'localhost'
if not Hosting then
	Ip = 'localhost'--'92.62.10.253'
end
Port = '25565'
DEBUG = {
	drawGrid=false, --wheather to draw an overlay showing tile positions
}
enableShaders = true

function love.load()
	love.window.setFullscreen(false)
	client.load()
end

function love.update(dt)
	scale.update()
	debugger.update(dt)
	server.update(dt)  --Gets clients' requests, runs the game, sends instructions to clients
	client.update(dt) --size, errormsg = love.filesystem.getSize(filename) server's instructions, sends requests to server
end

function love.draw()
	scale.drawStart()

	ui.drawBackgrounds()
	client.draw()
--	if Hosting then server.draw() end --for debug ONLY
  	debugger.draw()

	scale.drawEnd()
end
