local PauseGame = {}

PauseGame.__index = PauseGame

function PauseGame:new()
    local this = {
        clipboard = love.graphics.newImage("assets/sprites/misc/clipboard.png"),
        args = ""
    }

    return setmetatable(this, PauseGame)
end

function PauseGame:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        sceneDirector:exitSubscene()
    end
end

function PauseGame:draw()
    love.graphics.draw(self.clipboard, 0, 0, 0)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(self.args, 300, 150, 200, "center")
    love.graphics.setColor(1, 1, 1)
end

return PauseGame
