local hud = {}

local function meter(p,pos,size,col,args)
  local args = args or {}
  local args = {alpha = args.alpha or 1/2, roundedness = args.roundedness or 1, border=args.border or 0.1}

  local shortestSide = math.min(size.x,size.y)
  --Outline
  local r = args.roundedness * shortestSide * 0.4
  Col(0,0,0,args.alpha):use()
  love.graphics.rectangle('fill',pos.x,pos.y,size.x,size.y,r,r,100)
  --Internal bar
  local b = shortestSide*args.border
  local r = args.roundedness * (shortestSide-2*b) * 0.4
  Col(0.2,0.2,0.2,args.alpha):use()
  love.graphics.rectangle('fill',pos.x+b,pos.y+b,size.x-2*b,size.y-2*b,r,r,100)
  if p~=0 then
    col:setA(args.alpha):use()
    love.graphics.rectangle('fill',pos.x+b,pos.y+b,(size.x-2*b)*p,size.y-2*b,r,r,100)
  end
  Col(1,1,1):use()
end

function hud.draw()
  meter(client.player.hpP,Vec(0,1030),Vec(600,50),Col(1,0,0))
  meter(1,Vec(0,985),Vec(400,50),Col(0.2,0.64,0.95))

  for i, obj in ipairs(Objects) do
    if obj.hpP and i~=client.playerID and (not obj.dead) then
      meter(obj.hpP,obj.pos+Vec(-60,50),Vec(120,20),Col(1,0,0))
    end
  end
end

return hud
