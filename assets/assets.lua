local assets = {}

function assets.get(assetType,name)
  local asset = Assets[name]
	if not asset then --Get new asset
    if assetType == 'image' then asset = love.graphics.newImage("assets/images/"..name..".png") end
	 	if assetType == 'sound' then asset = love.audio.newSource("assets/sounds/"..name..".wav","static") end
    Assets[name] = asset
	end
	return asset
end

return assets
