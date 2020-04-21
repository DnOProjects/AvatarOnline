local assets = {}

function assets.get(assetType,name)
  local asset = assets[name]
	if not asset then --Get new asset
    if assetType == 'image' then asset = love.graphics.newImage("assets/images/"..name..".png") end
	 	if assetType == 'sound' then asset = love.audio.newSource("assets/sounds/"..name..".wav","static") end
    assets[name] = asset
	end
	return asset
end

return assets
