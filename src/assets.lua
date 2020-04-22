local assets = {}

function assets.get(assetType, name, fontSize)
  local asset = assets[name]

	if not asset then --Get new asset
    if assetType == 'image' then asset = love.graphics.newImage("assets/images/"..name..".png") end
  	if assetType == 'sound' then asset = love.audio.newSource("assets/sounds/"..name..".wav", "static") end
  	if assetType == 'font' then asset = love.graphics.newFont("assets/fonts/"..name..".ttf", fontSize) end
    assets[name] = asset
	end
	return asset
end

function assets.draw(name,pos,r,size)
  local img = assets.get('image',name)
  love.graphics.draw(img,pos.x,pos.y,r,size,size,img:getWidth()/2,img:getHeight()/2)
end

return assets
