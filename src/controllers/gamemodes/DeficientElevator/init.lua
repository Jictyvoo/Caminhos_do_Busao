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
        world = world,
        elapsedTime = 0,
        score = 0,
    }
    world:addCallback("BusStop", beginContact, "beginContact")
    world:changeCallbacks("BusStop")
    
    this = setmetatable(this, GameController)
    for count = 1, 15 do
        this:addPassenger()
    end
    return this
end

function GameController:getInstance(world)
    if not instance then
        instance = GameController:new(world)
    end
    return instance
end

function GameController:reset()
    self = self:new(self.world)
end

function GameController:keypressed(key, scancode, isrepeat)
end

function GameController:keyreleased(key, scancode)
end

function GameController:update(dt)
end

function GameController:draw()
end

return GameController
