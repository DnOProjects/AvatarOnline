local shaderMan = {} --manages shaders

local numLights = 0

function shaderMan.light(pos,col,intensity,spread)
  local lightString = 'lights['..tostring(numLights)..'].'
  Shader:send(lightString..'position', {pos.x,pos.y})
  Shader:send(lightString..'color', {col.r,col.g,col.b})
  Shader:send(lightString..'intensity', intensity)
  Shader:send(lightString..'spread', spread)
  numLights = numLights + 1
end

function shaderMan.update(dt) --must be called after all calls to shaderMan.light
  Shader:send('screenSize', {
			love.graphics.getWidth(),
			love.graphics.getHeight()
	})
	Shader:send("numLights", numLights)
  numLights = 0 --reset for next frame
end

return shaderMan
