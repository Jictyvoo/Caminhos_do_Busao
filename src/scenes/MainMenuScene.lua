local MainMenuScene = {}

MainMenuScene.__index = MainMenuScene

local addButton = function(this, buttonName, sceneName, buttonDimensions, originalSize, callback)
    local scaleButtonName = "menu" .. buttonName
    scaleDimension:calculeScales(scaleButtonName, unpack(buttonDimensions))
    scaleDimension:relativeScale(scaleButtonName, originalSize)
    local scales = scaleDimension:getScale(scaleButtonName)

    --buttonName, x, y, width, height, image, originalImage, animation, 70
    local button = this.buttonManager:addButton(buttonName, scales.x, scales.y, scales.width, scales.height, this.buttonsQuads, this.buttonsImage)
    button.callback = callback or function(self) sceneDirector:switchScene(sceneName); sceneDirector:reset(sceneName); this.music:pause() end
    button:setScale(scales.relative.x, scales.relative.y)
    
    this.buttonNames[scaleButtonName] = button
end

function MainMenuScene:new()
    local this = {
        background = love.graphics.newImage("assets/background.png"),
        music = love.audio.newSource("assets/sounds/menu_sound.wav", "static"),
        buttonManager = gameDirector:getLibrary("ButtonManager"):new(),
        driverSprite = gameDirector:getLibrary("Pixelurite").configureSpriteSheet("Driver_Menu", "assets/sprites/Driver/", true, nil, 1, 1, true),
        collectorSprite = gameDirector:getLibrary("Pixelurite").configureSpriteSheet("Collector_Menu", "assets/sprites/Collector/", true, nil, 1, 1, true),
        buttonsImage = nil, buttonsQuads = nil,
        buttonNames = {}
    }
    this.music:setLooping(true)
    scaleDimension:calculeScales("menuBackground", this.background:getWidth(), this.background:getHeight(), 0, 0)
    scaleDimension:calculeScales("driverSprite", 120, 140, 640, 470)
    scaleDimension:calculeScales("collectorSprite", 120, 140, 500, 470)
    local spriteSheet = gameDirector:getLibrary("Pixelurite").getSpritesheet():new("buttons", "assets/gui/", nil)
    local spriteQuads = spriteSheet:getQuads()
    this.buttonsQuads = {
        normal = spriteQuads["normal"],
        hover = spriteQuads["hover"],
        pressed = spriteQuads["pressed"],
        disabled = spriteQuads["disabled"]
    }
    this.buttonsImage = spriteSheet:getAtlas()

    local x, y, width, height = this.buttonsQuads["normal"]:getViewport()
    local originalSize = {width = width, height = height}
    addButton(this, 'Start Game', "levelSelection", {160, 60, 500, 200}, originalSize)
    addButton(this, 'Credits', "credits", {160, 60, 500, 280}, originalSize)

    return setmetatable(this, MainMenuScene)
end

function MainMenuScene:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    end
    self.buttonManager:keypressed(key, scancode, isrepeat)
end

function MainMenuScene:keyreleased(key, scancode)
    self.buttonManager:keyreleased(key, scancode)
end

function MainMenuScene:mousemoved(x, y, dx, dy, istouch)
    self.buttonManager:mousemoved(x, y, dx, dy, istouch)
end

function MainMenuScene:mousepressed(x, y, button)
    self.buttonManager:mousepressed(x, y, button)
end

function MainMenuScene:mousereleased(x, y, button)
    self.buttonManager:mousereleased(x, y, button)
end

function MainMenuScene:wheelmoved(x, y)
end

function MainMenuScene:update(dt)
    self.music:play()
    self.driverSprite:update(dt)
    self.collectorSprite:update(dt)
    self.buttonManager:update(dt)
end

function MainMenuScene:draw()
    local width, height = love.graphics.getDimensions()
    local scales = scaleDimension:getScale("menuBackground")
    love.graphics.draw(self.background, 0, 0, 0, scales.scaleX, scales.scaleY)
    self.buttonManager:draw()
    scales = scaleDimension:getScale("driverSprite")
    self.driverSprite:draw(scales.x, scales.y, scales.scaleX, scales.scaleY)
    scales = scaleDimension:getScale("collectorSprite")
    self.collectorSprite:draw(scales.x, scales.y, scales.scaleX, scales.scaleY)
end

function MainMenuScene:resize(w, h)
    for index, value in pairs(self.buttonNames) do
        local scales = scaleDimension:getScale(index)
        value:setXY(scales.x, scales.y)
        value:setDimensions(scales.width, scales.height)
        value:setScale(scales.relative.x, scales.relative.y)
    end
end

return MainMenuScene
