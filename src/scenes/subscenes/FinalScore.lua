local GameOver = {}

GameOver.__index = GameOver

function GameOver:new(score, time)
    local this = {
        score = score, time = time or 0,
        scoreSprite = love.graphics.newImage("assets/sprites/misc/mission_menu.png")
    }

    return setmetatable(this, GameOver)
end

function GameOver:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        sceneDirector:exitSubscene()
        sceneDirector:previousScene()
        sceneDirector:previousScene()
    end
end

function GameOver:draw()
    love.graphics.setColor(0, 0, 0)
    local width, height = self.scoreSprite:getWidth(), self.scoreSprite:getHeight()
    love.graphics.rectangle("fill", (love.graphics.getWidth() / 2) - 120, 80, width, height)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.scoreSprite, (love.graphics.getWidth() / 2) - 120, 80)
    love.graphics.setFont(gameDirector:getFonts().letterboard)
    love.graphics.print(string.format("%d", self.score), 500, 320)
    love.graphics.print(string.format("%d", self.time), 450, 380)
    love.graphics.setFont(gameDirector:getFonts().default)
end

return GameOver
