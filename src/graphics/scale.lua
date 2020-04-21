local scale = {}

function scale.load()
    mouseX = 0
    mouseY = 0
    gameRenderScale = love.graphics.getHeight()/1080
    if (gameRenderScale > love.graphics.getWidth()/1920) then
        gameRenderScale = love.graphics.getWidth()/1920
    end
    xPadding = (love.graphics.getWidth() - (1920 * gameRenderScale)) / 2
    yPadding = (love.graphics.getHeight() - (1080 * gameRenderScale)) / 2
end

function scale.update()
    mouseX = love.mouse.getX() / gameRenderScale - xPadding
    mouseY = love.mouse.getY() / gameRenderScale - yPadding
end

function scale.draw()
    love.graphics.scale(gameRenderScale)
    love.graphics.translate(xPadding, yPadding)
end

return scale
