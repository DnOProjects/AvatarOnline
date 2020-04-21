--Global classes
require 'class'
require 'vector'
require 'color'
Constructors = {vector = ConstructVec, color = ConstructCol}
--Global modules
debug, enet, bitser, utils = require 'debugger', require 'enet', require 'bitser', require 'utils'
client, server = require 'client', require 'server'

local host = true --True: runs a server and a client; False: runs just a client
local ip = --[['localhost']]'92.62.10.253'
local port = '25565'

function love.load()
  if host then server.start('*:'..port) end
  client.connect(ip..':'..port)
end

function love.update(dt)
  debug.update(dt)
  if host then server.update(dt) end --Gets clients' requests, runs the game, sends instructions to clients
  client.update(dt) --Gets server's instructions, sends requests to server
end

function love.draw()
  client.draw() --Draws the game from the client's incomplete store of game objects
  debug.draw()
end
