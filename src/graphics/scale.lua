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

function scale.drawStart()
    love.graphics.push()
    love.graphics.scale(gameRenderScale)
    love.graphics.translate(xPadding, yPadding)
end

function scale.drawEnd()
    love.graphics.pop()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, xPadding, love.graphics.getHeight())
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), yPadding)
    love.graphics.rectangle("fill", love.graphics.getWidth() - xPadding, 0, xPadding, love.graphics.getHeight())
    love.graphics.rectangle("fill", 0, love.graphics.getHeight() - yPadding, love.graphics.getWidth(), yPadding)
    love.graphics.setColor(1, 1, 1)
end

return scale
