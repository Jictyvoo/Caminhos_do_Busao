local currentPath   = (...):gsub('%.init$', '') .. "."
local GameController = {}
local instance = nil

GameController.__index = GameController

local function beginContact(a, b, col)
end

local function endContact(a, b, col)
end

function GameController:new(world)
    local this = {
        world = world, gamemodeController = nil, elevatorPosition = 0,
        background = love.graphics.newImage("assets/sprites/DeficientElevator/bus_background.png"),
        elevator = love.graphics.newImage("assets/sprites/DeficientElevator/elevator.png"),
        wheelchair = gameDirector:getLibrary("Pixelurite").configureSpriteSheet("wheelchair", "assets/sprites/DeficientElevator/", true, nil, 1, 1, true),
        controlPanel = love.graphics.newImage("assets/sprites/DeficientElevator/control_panel.png"),
        panelButton = {}, buttonSprite = gameDirector:getLibrary("Pixelurite").getSpritesheet():new("button", "assets/sprites/DeficientElevator/"),
        elapsedTime = 0, totalTime = 20,
        score = 0, currentState = 0, movingWheelchair = {x = 458},
        driverSprite = gameDirector:getLibrary("Pixelurite").configureSpriteSheet("driver", "assets/sprites/DeficientElevator/", true, nil, 1, 1, true)
    }
    world:addCallback("DeficientElevator", beginContact, "beginContact")
    world:changeCallbacks("DeficientElevator")
    
    this = setmetatable(this, GameController)
    
    local spriteQuads = this.buttonSprite:getQuads()
    local buttonQuads = {
        normal = spriteQuads["normal"], hover = spriteQuads["normal"],
        pressed = spriteQuads["pressed"], disabled = spriteQuads["pressed"]
    }
    local button = gameDirector:getLibrary("Button"):new(nil, 580, 180, 120, 120, buttonQuads, this.buttonSprite:getAtlas())
    button:setCallback(function(self) this:elevatorMovement("up") end)
    table.insert(this.panelButton, button)
    button = gameDirector:getLibrary("Button"):new(nil, 580, 420, 120, 120, buttonQuads, this.buttonSprite:getAtlas())
    button:setCallback(function(self) this:elevatorMovement("down") end)
    button:setScale(1, -1)
    button:setOffset(0, 60)
    table.insert(this.panelButton, button)
    return this
end

function GameController:getInstance(world)
    if not instance then
        instance = GameController:new(world)
    end
    return instance
end

function GameController:reset()
    self.currentState = 0; self.score = 0; self.elevatorPosition = 0; self.elapsedTime = 0; self.totalTime = 20
    self.movingWheelchair.x = 458
end

function GameController:setGamemodesController(gamemodeController)
    self.gamemodeController = gamemodeController
end

function GameController:elevatorMovement(key)
    if key == "up" then
        if self.elevatorPosition > -38 then
            self.elevatorPosition = self.elevatorPosition - 4
        elseif self.elevatorPosition <= -38 and self.currentState == 1 then
            self.currentState = 0; self.score = self.score + 1; self.movingWheelchair.x = 458
        end
    elseif key == "down" then
        if self.elevatorPosition < 40 then
            self.elevatorPosition = self.elevatorPosition + 4
        elseif self.elevatorPosition >= 40 and self.currentState == 0 then
            self.currentState = 1
        end
    end
end

function GameController:keypressed(key, scancode, isrepeat)
    self:elevatorMovement(key)
end

function GameController:keyreleased(key, scancode)
end

function GameController:mousemoved(x, y, dx, dy, istouch)
    for _, button in pairs(self.panelButton) do
        button:mousemoved(x, y, dx, dy, istouch)
    end
end

function GameController:mousepressed(x, y, button, istouch)
    for _, button in pairs(self.panelButton) do
        button:mousepressed(x, y, button, istouch)
    end
end

function GameController:mousereleased(x, y, button, istouch)
    for _, button in pairs(self.panelButton) do
        button:mousereleased(x, y, button, istouch)
    end
end

function GameController:update(dt)
    self.elapsedTime = self.elapsedTime + dt
    self.totalTime = self.totalTime - dt
    self.driverSprite:update(dt)
    self.wheelchair:update(dt)
    if self.elapsedTime >= 0.02 then
        if self.currentState == 0 and self.movingWheelchair.x > 154 then
            self.movingWheelchair.x = self.movingWheelchair.x - 5
        end
        self.elapsedTime = 0
    end
    if self.totalTime <= 0 then
        self.gamemodeController:increaseScore(self.score)
        self.gamemodeController:exitGamemode()
        self:reset()
    end
end

function GameController:draw()
    love.graphics.draw(self.background, 0, 0, 0, 1, 1)
    love.graphics.draw(self.elevator, 106, 392 + self.elevatorPosition, 0, 1, 1)
    if self.currentState == 1 then
        self.wheelchair:draw(158, 430 + self.elevatorPosition)
    else
        self.wheelchair:draw(self.movingWheelchair.x, 470, -1)
    end
    love.graphics.draw(self.controlPanel, 517, 113, 0, 1, 1)
    for _, button in pairs(self.panelButton) do button:draw() end
    self.driverSprite:draw(45, 467)
    gameDirector:getLibrary("LetterboardTimer"):draw(self.totalTime)
end

return GameController
