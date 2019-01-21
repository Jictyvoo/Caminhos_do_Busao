local InGameScene = {}

InGameScene.__index = InGameScene

function InGameScene:new(world)
    local this = {
        gamemodes = {
            DriveTheBus = require "controllers.gamemodes.DriveTheBus"
        },
        currentGamemode = nil
    }
    this.currentGamemode = this.gamemodes.DriveTheBus:getInstance(world)
    sceneDirector:addSubscene("pause", require "scenes.subscenes.PauseGame":new())
    return setmetatable(this, InGameScene)
end

function InGameScene:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        sceneDirector:switchSubscene("pause")
    end
    self.currentGamemode:keypressed(key, scancode, isrepeat)
end

function InGameScene:keyreleased(key, scancode)
    self.currentGamemode:keyreleased(key, scancode)
end

function InGameScene:reset()
    gameDirector:reset()
    self.currentGamemode:reset()
end

function InGameScene:update(dt)
    gameDirector:update(dt)
    self.currentGamemode:update(dt)
end

function InGameScene:draw()
    self.currentGamemode:draw()
end

return InGameScene
