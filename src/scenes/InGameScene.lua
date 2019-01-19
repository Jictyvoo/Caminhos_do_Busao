local InGameScene = {}

InGameScene.__index = InGameScene

function InGameScene:new(world)
    local this = {
    }

    sceneDirector:addSubscene("pause", require "scenes.subscenes.PauseGame":new())
    return setmetatable(this, InGameScene)
end

function InGameScene:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        sceneDirector:switchSubscene("pause")
    end
end

function InGameScene:keyreleased(key, scancode)
end

function InGameScene:reset()
    gameDirector:reset()
end

function InGameScene:update(dt)
    gameDirector:update(dt)
end

function InGameScene:draw()
end

return InGameScene
