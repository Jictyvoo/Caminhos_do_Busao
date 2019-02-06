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
        elapsedTime = 0, tx = 0, ty = 0,
        score = 0, currentState = 0,
        driverSprite = gameDirector:getLibrary("Pixelurite").configureSpriteSheet("driver", "assets/sprites/DeficientElevator/", true, nil, 1, 1, true)
    }
    world:addCallback("DeficientElevator", beginContact, "beginContact")
    world:changeCallbacks("DeficientElevator")
    
    this = setmetatable(this, GameController)
    return this
end

function GameController:getInstance(world)
    if not instance then
        instance = GameController:new(world)
    end
    return instance
end

function GameController:reset()
    self.currentState = 0; self.score = 0; self.elevatorPosition = 0; self.elapsedTime = 0
end

function GameController:setGamemodesController(gamemodeController)
    self.gamemodeController = gamemodeController
end

function GameController:keypressed(key, scancode, isrepeat)
    if key == "up" then
        if self.elevatorPosition > -38 then
            self.elevatorPosition = self.elevatorPosition - 4
        elseif self.elevatorPosition <= -38 and self.currentState == 1 then
            self.currentState = 0; self.score = self.score + 1
        end
    elseif key == "down" then
        if self.elevatorPosition < 40 then
            self.elevatorPosition = self.elevatorPosition + 4
        elseif self.elevatorPosition >= 40 and self.currentState == 0 then
            self.currentState = 1
        end
    end
end

function GameController:keyreleased(key, scancode)
end

function GameController:mousemoved(x, y, dx, dy, istouch)
    self.tx = x
    self.ty = y
    print(x, y)
end

function GameController:update(dt)
    self.elapsedTime = self.elapsedTime + dt
    self.driverSprite:update(dt)
    self.wheelchair:update(dt)
    if self.elapsedTime >= 10 then
        self.gamemodeController:exitGamemode()
        self:reset()
    end
end

function GameController:draw()
    love.graphics.draw(self.background, 0, 0, 0, 1, 1)
    love.graphics.draw(self.elevator, 106, 392 + self.elevatorPosition, 0, 1, 1)
    if self.currentState == 1 then
        self.wheelchair:draw(158, 430 + self.elevatorPosition)
    end
    self.driverSprite:draw(45, 467)
end

return GameController
