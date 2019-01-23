local currentPath   = (...):gsub('%.init$', '') .. "."
local Bus = require(string.format("%smodels.entities.Bus", currentPath))
local BusComponent = require(string.format("%smodels.entities.BusComponent", currentPath))
local Passenger = require(string.format("%smodels.entities.Passenger", currentPath))
local GameController = {}
local instance = nil

GameController.__index = GameController

local function beginContact(a, b, col)
    if a:getUserData() == "Passenger" or b:getUserData() == "Passenger" then
        instance:removePassenger(a:getUserData() == "Passenger" and a or b)
        instance.score = instance.score + 1
        instance.growBus = true
    end
end

local function endContact(a, b, col)
end

function GameController:new(world)
    local this = {
        world = world,
        busHead = Bus:new(world.world, 50, 60, BusComponent),
        cameraController = nil,
        passengers = {},
        mapSize = {w = 2400, h = 1800},
        elapsedTime = 0,
        score = 0,
        growBus = false,
        walls = {},
        waitTime = love.math.random(1.5, 6)
    }
    this.cameraController = gameDirector:getLibrary("CameraController"):new(this.busHead, this.mapSize)
    world:addCallback("DriveTheBus", beginContact, "beginContact")
    world:changeCallbacks("DriveTheBus")
    
    --[[Adding walls to game --]]
    table.insert(this.walls, gameDirector:getLibrary("Wall"):new(world.world, 1200, 0, {w = 2400, h = 10}))
    table.insert(this.walls, gameDirector:getLibrary("Wall"):new(world.world, 1200, 1800, {w = 2400, h = 10}))
    table.insert(this.walls, gameDirector:getLibrary("Wall"):new(world.world, 0, 900, {w = 10, h = 1800}))
    table.insert(this.walls, gameDirector:getLibrary("Wall"):new(world.world, 2400, 900, {w = 10, h = 1800}))

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

function GameController:removePassenger(fixture)
    if self.passengers[fixture] then
        self.passengers[fixture]:destroy()
        self.passengers[fixture] = nil
    end
end

function GameController:addPassenger()
    local passenger = Passenger:new(self.world.world, love.math.random(self.mapSize.w), love.math.random(self.mapSize.h))
    self.passengers[passenger:getFixture()] = passenger
end

function GameController:increaseBusSize()
    self.busHead:increaseSize(BusComponent)
end

function GameController:keypressed(key, scancode, isrepeat)
    self.busHead:keypressed(key, scancode, isrepeat)
end

function GameController:keyreleased(key, scancode)
    self.busHead:keyreleased(key, scancode)
end

function GameController:update(dt)
    self.elapsedTime = self.elapsedTime + dt
    self.cameraController:update(dt)
    self.busHead:update(dt)
    if self.elapsedTime >= self.waitTime then
        self.elapsedTime = 0
        self.waitTime = love.math.random(1.5, 6)
        self:addPassenger()
    end
    if self.growBus then
        self.growBus = false
        self:increaseBusSize()
    end
end

function GameController:draw()
    self.cameraController:draw(function()
        for _, wall in pairs(self.walls) do wall:draw() end
        self.busHead:draw()
        for _, passenger in pairs(self.passengers) do
            passenger:draw()
        end
    end)
end

return GameController
