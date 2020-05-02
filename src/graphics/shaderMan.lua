local shaderMan = {} --manages shaders

local numLights = 0

function shaderMan.light(pos,args)
  local isPoint = (args.type or 'point') == 'point'
  local lightString = 'lights['..tostring(numLights)..'].'

  Shader:send(lightString..'isPoint', isPoint)
  Shader:send(lightString..'a', {pos.x,pos.y})
  Shader:send(lightString..'color', {args.col.r,args.col.g,args.col.b})
  Shader:send(lightString..'intensity', args.intensity)
  Shader:send(lightString..'spread', args.spread)

  if not isPoint then --send line segment info
    local b = args.endPos or pos+VecPol(args.length,args.dir)
    Shader:send(lightString..'b',{b.x,b.y})
  end

  numLights = numLights + 1
end

function shaderMan.send() --must be called after all calls to shaderMan.light
  Shader:send('screenSize', {
			love.graphics.getWidth(),
			love.graphics.getHeight()
	})
	Shader:send("numLights", numLights)
  numLights = 0 --reset for next send
end

return shaderMan
