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
        elapsedTime = 0,
        score = 0,
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
end

function GameController:setGamemodesController(gamemodeController)
    self.gamemodeController = gamemodeController
end

function GameController:keypressed(key, scancode, isrepeat)
    if key == "up" then
        self.elevatorPosition = self.elevatorPosition + 0.5
    elseif key == "down" then
        self.elevatorPosition = self.elevatorPosition - 0.5
    end
end

function GameController:keyreleased(key, scancode)
end

function GameController:update(dt)
    self.elapsedTime = self.elapsedTime + dt
    print(self.elevatorPosition)
end

function GameController:draw()
end

return GameController
