local currentPath   = (...):gsub('%.init$', '') .. "."
local Bus = require(string.format("%smodels.entities.Bus", currentPath))
local BusComponent = require(string.format("%smodels.entities.BusComponent", currentPath))
local Passenger = require(string.format("%smodels.entities.Passenger", currentPath))
local GameController = {}

GameController.__index = GameController

function GameController:new(world)
    local this = {
        world = world,
        busHead = Bus:new(world, 50, 60),
        passengers = {}
    }

    return setmetatable(this, GameController)
end

function GameController:reset()
    self = self:new(self.world)
end

function GameController:keypressed(key, scancode, isrepeat)
    self.busHead:keypressed(key, scancode, isrepeat)
end

function GameController:keyreleased(key, scancode)
    self.busHead:keyreleased(key, scancode)
end

function GameController:update(dt)
    self.busHead:update(dt)
end

function GameController:draw()
    self.busHead:draw()
end

return GameController
