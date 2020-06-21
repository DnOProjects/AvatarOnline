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

local itemSize = Vec(200,50)
local function drawMenu(menu,pos)
  local pos = pos or menu.pos
  for i=1,#menu.items do
    local item, itemPos = menu.items[i], pos + Vec(0,(i-1)*itemSize.y)
    if item.selected and item.items then drawMenu(item,itemPos+Vec(itemSize.x,0)) end
    Col(0.2):use()
    if item.selected then Col(0.3):use() end
    love.graphics.rectangle("fill", itemPos.x, itemPos.y, itemSize.x, itemSize.y)
    Col(1):use()
    love.graphics.rectangle("line", itemPos.x, itemPos.y, itemSize.x, itemSize.y)
    local name = item.name
    if item.triggerEvent then
      if item.triggerEvent~=true then name = name..' ('..(item.triggerEvent.key or item.triggerEvent.button)..')'
      else name = name..' [unset]' end
    end
    love.graphics.print(name,itemPos.x,itemPos.y)
  end
end
local function updateMenu(menu,pos)
  local pos = pos or menu.pos
  local m = VecMouse()
  for i=1,#menu.items do
    local item, itemPos = menu.items[i], pos + Vec(0,(i-1)*itemSize.y)
    if item.items then updateMenu(item,itemPos+Vec(itemSize.x,0)) end
    local inCollumn, inRow = m.x>=pos.x and m.x<=pos.x+itemSize.x, m.y>=itemPos.y and m.y<=itemPos.y+itemSize.y
    item.selected = (item.selected and m.x>=pos.x+itemSize.x) or (inCollumn and inRow)
  end
end

local selectionMenu = {pos = Vec(400,400), items={
  {name="attack",items={
    {name="water", items={{name="bubble"}, {name="waterSpray"}, {name="Ice shards"}}},
    {name="earth",items={{name="Bullets"}, {name="Pebbles"}, {name="Idk im running out of fake names"}}},
    {name="fire",items={{name="Laser"}, {name="charge"}, {name="C"}}},
    {name="air",items={{name="A"}, {name="B"}, {name="C"}}}
  }},
  {name="defend",items={
    {name="water",items={{name="A"}, {name="B"}, {name="C"}}},
    {name="earth",items={{name="A"}, {name="B"}, {name="C"}}},
    {name="fire",items={{name="A"}, {name="B"}, {name="C"}}},
    {name="air",items={{name="A"}, {name="B"}, {name="C"}}}
  }},
  {name="special",items={
    {name="water",items={{name="A"}, {name="B"}, {name="C"}}},
    {name="earth",items={{name="A"}, {name="B"}, {name="C"}}},
    {name="fire",items={{name="A"}, {name="B"}, {name="C"}}},
    {name="air",items={{name="A"}, {name="B"}, {name="C"}}}
  }}
}}

function hud.draw()
  meter(client.player.hpP,Vec(0,1030),Vec(600,50),Col(1,0,0))
  meter(1,Vec(0,985),Vec(400,50),Col(0.2,0.64,0.95))

  for i, obj in ipairs(Objects) do
    if obj.hpP and i~=client.playerID and (not obj.dead) then
      meter(obj.hpP,obj.pos+Vec(-60,50),Vec(120,20),Col(1,0,0))
    end
  end

  if currentPage=="switchMove" then drawMenu(selectionMenu) end
end

function hud.update()
  if currentPage=="switchMove" then updateMenu(selectionMenu) end
end

function hud.handleInputEvent(event)
  for i=1,#selectionMenu.items do
    for j=1,#selectionMenu.items[i].items do
      for k=1,#selectionMenu.items[i].items[j].items do
        local item = selectionMenu.items[i].items[j].items[k]
        if not item.triggerEvent then item.triggerEvent = true end
        if currentPage=="switchMove" and item.selected then
          item.triggerEvent = event
        elseif item.triggerEvent~=true and event.key==item.triggerEvent.key and event.button==item.triggerEvent.button then
          if event.type == 'mouserelease' then input.abilityTriggered(item.name,false)
          else input.abilityTriggered(item.name,true) end
        end
      end
    end
  end
end

return hud
