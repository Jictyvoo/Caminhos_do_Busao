local LevelSelectionScene = {}

LevelSelectionScene.__index = LevelSelectionScene

local addButton = function(this, buttonName, buttonDimensions, originalSize, callback)
    local scaleButtonName = "levelSelection" .. buttonName
    scaleDimension:calculeScales(scaleButtonName, unpack(buttonDimensions))
    scaleDimension:relativeScale(scaleButtonName, originalSize)
    local scales = scaleDimension:getScale(scaleButtonName)

    --buttonName, x, y, width, height, image, originalImage, animation, 70
    local button = this.buttonManager:addButton(buttonName, scales.x, scales.y, scales.width, scales.height, this.buttonImage)
    button.callback = callback or function(self) sceneDirector:switchScene("inGame") end
    button:setScale(scales.relative.x, scales.relative.y)
    
    this.buttonNames[scaleButtonName] = button
end

function LevelSelectionScene:new(world)
    local this = {
        levelMap = love.graphics.newImage("assets/sprites/levels_map.png"),
        buttonManager = gameDirector:getLibrary("ButtonManager"):new(),
        buttonImage = love.graphics.newImage("assets/sprites/misc/pin.png"),
        buttonNames = {}
    }
    scaleDimension:calculeScales("levels_map", this.levelMap:getWidth(), this.levelMap:getHeight(), 0, 0)
    local width, height = this.buttonImage:getWidth(), this.buttonImage:getHeight()
    local originalSize = {width = width, height = height}
    addButton(this, "level_1", {75, 75, 100, 100}, originalSize)
    return setmetatable(this, LevelSelectionScene)
end

function LevelSelectionScene:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        sceneDirector:previousScene()
    end
    self.buttonManager:keypressed(key, scancode, isrepeat)
end

function LevelSelectionScene:keyreleased(key, scancode)
    self.buttonManager:keyreleased(key, scancode)
end

function LevelSelectionScene:mousemoved(x, y, dx, dy, istouch)
    self.buttonManager:mousemoved(x, y, dx, dy, istouch)
end

function LevelSelectionScene:mousepressed(x, y, button)
    self.buttonManager:mousepressed(x, y, button)
end

function LevelSelectionScene:mousereleased(x, y, button)
    self.buttonManager:mousereleased(x, y, button)
end

function LevelSelectionScene:reset()
end

function LevelSelectionScene:update(dt)
end

function LevelSelectionScene:draw()
    local scales = scaleDimension:getScale("levels_map")
    love.graphics.draw(self.levelMap, 0, 0, 0, scales.scaleX, scales.scaleY)
    self.buttonManager:draw()
end

return LevelSelectionScene
