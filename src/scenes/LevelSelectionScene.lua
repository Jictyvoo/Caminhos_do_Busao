local LevelSelectionScene = {}

LevelSelectionScene.__index = LevelSelectionScene

function LevelSelectionScene:new(world)
    local this = {
        levelMap = love.graphics.newImage("assets/levels_map.png")
    }
    scaleDimension:calculeScales("levels_map", this.levelMap:getWidth(), this.levelMap:getHeight(), 0, 0)
    return setmetatable(this, LevelSelectionScene)
end

function LevelSelectionScene:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        sceneDirector:previousScene()
    end
end

function LevelSelectionScene:keyreleased(key, scancode)
end

function LevelSelectionScene:reset()
end

function LevelSelectionScene:update(dt)
end

function LevelSelectionScene:draw()
    local scales = scaleDimension:getScale("levels_map")
    love.graphics.draw(self.levelMap, 0, 0, 0, scales.scaleX, scales.scaleY)
end

return LevelSelectionScene
