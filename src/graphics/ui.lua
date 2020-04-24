local ui = {}

-- Requires
local utils = require "src/utils"
local assets = require "src/assets"

local IGPages = {}
local backgrounds = {}
local buttons = {}
local sliders = {}
local prints = {}

local canClick = true
local canSlide = true

-- Loads
local function addIGPage(page, key)
	key = key or "noKey"
	IGPages[#IGPages+1] = {page = page, key = key}
end

local function addBackgroundImage(pages, image)
	backgrounds[#backgrounds+1] = {pages = pages, image = image}
end

local function addButton(page, pageToGo, text, x, y, width, height, textSize, r, g, b, a, onPress) --on press is an optional arguement
	buttons[#buttons+1] = {page = page, pageToGo = pageToGo, text = text, x = x, y = y, width = width, height = height, textSize = textSize, font = "IMMORTAL", color = {r, g, b, a}, mouseOver = false, onPress = onPress or function() end}
end

local function addSlider(page, text, x, y, width, height, textSize, r, g, b, a, value, sliderWidth, sliderHeight)
	-- sliderWidth must be even as it is halved
	-- sliderHeight must be odd as the 3 from the slider line is odd
	sliders[#sliders+1] = {page = page, text = text, x = x, y = y, width = width, height = height, textSize = textSize, font = "IMMORTAL", color = {r, g, b, a}, value = value, sliderWidth = sliderWidth, sliderHeight = sliderHeight}
end

local function addPrint(pages, text, x, y, limit, textSize, r, g, b, a, align)
	prints[#prints+1] = {pages = pages, text = text, x = x, y = y, limit = limit, textSize = textSize, font = "TropicalAsian", color = {r, g, b, a}, align = align}
end

local function initUI()
	addIGPage("inGame")
	addIGPage("deathScreen")

	addBackgroundImage({1, 2}, assets.get("image", "dirt"))
	addPrint({1, 2}, "Elements Online", 0, 50, 1920, 150, 0, 0.1, 0.15, 1, "center")

	addButton(1, "inGame", "Play", 200, 250, 500, 140, 70, 0.1, 0.1, 0.1, 0.6, function()
		if Hosting then
			server.start('*:'..Port) -- Starts the server once button pushed
		end
		client.connect(Ip..':'..Port) -- Connects the client once the button is pushed
	end)
	addButton(1, 2, "Options", 200, 450, 500, 140, 70, 0.1, 0.1, 0.1, 0.6)
	addButton(1, "exit", "Exit", 200, 650, 500, 140, 70, 0.1, 0.1, 0.1, 0.6, function()
		love.event.quit()
	end)

	addSlider(2, "Master", 200, 250, 500, 140, 70, 0.1, 0.1, 0.1, 0.6, volume, 6, 11)
	addButton(2, 1, "Back", 200, 650, 500, 140, 70, 0.1, 0.1, 0.1, 0.6)

	addButton("deathScreen", "inGame", "Respawn", 710, 470, 500, 140, 70, 0.1, 0.1, 0.1, 0.6, function()
		client.request({id=client.playerID},'respawn')
	end)
end

function ui.load()
	volume = 100

	currentPage = 1
	initUI()
end

-- Updates
local function updateButtons()
	for i, button in pairs(buttons) do
		if (button.page == currentPage) then
			button.mouseOver = utils.inBounds({mouseX, mouseY}, {button.x, button.y, button.width, button.height})
			if (button.mouseOver and love.mouse.isDown(1) and canClick == true) then
				currentPage = button.pageToGo
				button.onPress()
				canSlide = false
			end
		end
	end
end

local function updateSliders()
	for i, slider in pairs(sliders) do
		if (slider.page == currentPage) then
			if love.mouse.isDown(1) == true then
				if canSlide == true then
					if utils.inBounds({mouseX, mouseY}, {slider.x, slider.y+slider.height-(((slider.sliderHeight-3)/2)+40), slider.width, slider.sliderHeight + 50}) then
						slider.value = utils.round((mouseX-(slider.x+20))/((slider.width-40)/100))
						if slider.value < 0 then
							slider.value = 0
						elseif slider.value > 100 then
							slider.value = 100
						end
					end
				end
			end
		end
	end
end

function ui.update()
	updateButtons()
	updateSliders()
	if love.mouse.isDown(1) == true then
		canClick = false
	else
		canClick = true
		canSlide = true
	end
end

-- Drawing
function ui.drawBackgrounds()
	for i, background in pairs(backgrounds) do
		if (utils.inList(currentPage, background.pages)) then
			for x=0,10 do
				for y=0,10 do
					love.graphics.draw(background.image,x*200,y*200)
				end
			end
		end
	end
end

local function drawButtons()
	for i, button in pairs(buttons) do
	    if (button.page == currentPage) then
			if (button.mouseOver == false) then
				love.graphics.setColor(button.color)
			else
				love.graphics.setColor(button.color[1] - button.color[1]/4, button.color[2] - button.color[2]/4, button.color[3] - button.color[3]/4, button.color[4] - button.color[4]/4)
			end
			love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)
			love.graphics.setColor(1, 1, 1, 0.95)
			love.graphics.setFont(assets.get("font", button.font, button.textSize))
			love.graphics.printf(button.text, button.x, button.y + (button.height/2) - (button.textSize/1.8), button.width, "center")
		end
	end
end

local function drawSliders()
	for i, slider in pairs(sliders) do
		if (slider.page == currentPage) then
		    love.graphics.setColor(slider.color)
		    love.graphics.rectangle("fill", slider.x, slider.y, slider.width, slider.height)
		    love.graphics.setColor(1, 1, 1)
		    love.graphics.setFont(assets.get("font", slider.font, slider.textSize))
		    love.graphics.printf(slider.text.." : "..slider.value, slider.x, slider.y + slider.height/2 - slider.textSize/1.5, slider.width, "center")
			love.graphics.rectangle("line", slider.x+20, slider.y+slider.height-20, slider.width-40, 3)
			love.graphics.rectangle("fill", slider.x+20+((slider.width-40)/100)*slider.value-slider.sliderWidth/2, slider.y+slider.height-(((slider.sliderHeight-3)/2)+20), slider.sliderWidth, slider.sliderHeight)
		end
	end
end

local function drawPrints()
	for i, printText in pairs(prints) do
		if (utils.inList(currentPage, printText.pages)) then
			love.graphics.setFont(assets.get("font", printText.font, printText.textSize))
			love.graphics.setColor(printText.color)
			love.graphics.printf(printText.text, printText.x, printText.y, printText.limit, printText.align)
			love.graphics.setColor(1, 1, 1)
		end
	end
end

function ui.draw()
	drawButtons()
	drawSliders()
	drawPrints()
end

-- Other functions
function ui.getIGPages()
	local IGOnlyPages = {}
	for i=1, #IGPages do
		IGOnlyPages[i] = IGPages[i].page
	end
	return IGOnlyPages
end

return ui
