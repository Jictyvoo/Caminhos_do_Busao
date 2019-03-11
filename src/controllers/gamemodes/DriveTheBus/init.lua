local currentPath   = (...):gsub('%.init$', '') .. "."
local Bus = require(string.format("%smodels.entities.Bus", currentPath))
local BusComponent = require(string.format("%smodels.entities.BusComponent", currentPath))
local Passenger = require(string.format("%smodels.entities.Passenger", currentPath))
local GameController = {}
local instance = nil

GameController.__index = GameController

local function beginContact(a, b, col)
    if a:getUserData() == "Passenger" or b:getUserData() == "Passenger" then
        if totalPassengers == 1 then
            instance.score = instance.score + instance.totalTime
        end
        instance:removePassenger(a:getUserData() == "Passenger" and a or b)
        instance.score = instance.score + 1
        instance.gamemodeController:changeGamemode()
        instance.busHead:stop()
        instance.growBus = true
    end
end

local function endContact(a, b, col)
end

function GameController:new(world)
    local this = {
        world = world,
        busHead = Bus:new(world.world, 200, 150, BusComponent),
        background = love.graphics.newImage("assets/sprites/DriveTheBus/background.png"),
        cameraController = nil,
        passengers = {}, passengerSprite = love.graphics.newImage("assets/sprites/DriveTheBus/bus_stop.png"),
        mapSize = {w = 2400, h = 1800},
        elapsedTime = 0, totalTime = 110,
        score = 0, totalPassengers = 0,
        mapData = require(string.format("%smodels.business.MapData", currentPath)),
        growBus = false,
        walls = {}, invisibleWall = {},
        gamemodeController = nil,
        waitTime = love.math.random(1.5, 6)
    }
    this.cameraController = gameDirector:getLibrary("CameraController"):new(this.busHead, this.mapSize, 1)
    world:addCallback("DriveTheBus", beginContact, "beginContact")
    world:changeCallbacks("DriveTheBus")
    
    this = setmetatable(this, GameController)
    this.mapData(this, world, gameDirector:getLibrary("Wall"), true)
    for count = 1, 6 do
        this:increaseBusSize()
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
    self.mapData(self, self.world, gameDirector:getLibrary("Wall"), true)
    self.score = 0; self.totalTime = 110
end

function GameController:setGamemodesController(gamemodeController)
    self.gamemodeController = gamemodeController
end

function GameController:finishGame()
    self.gamemodeController:increaseScore(self.score)
    self.gamemodeController:exitGamemode(true)
    self:reset()
end

function GameController:removePassenger(fixture)
    if self.passengers[fixture] then
        self.passengers[fixture]:destroy()
        self.passengers[fixture] = nil
    end
end

function GameController:addPassenger(x, y)
    local passenger = Passenger:new(self.world.world, x, y, self.passengerSprite)
    self.passengers[passenger:getFixture()] = passenger
end

function GameController:increaseBusSize()
    self.busHead:increaseSize(BusComponent)
end

function GameController:mousepressed(x, y, button)
    self.busHead:mousepressed(x, y, button)
end

function GameController:mousereleased(x, y, button)
    self.busHead:mousereleased(x, y, button)
end

function GameController:keypressed(key, scancode, isrepeat)
    self.busHead:keypressed(key, scancode, isrepeat)
end

function GameController:keyreleased(key, scancode)
    self.busHead:keyreleased(key, scancode)
end

function GameController:update(dt)
    self.elapsedTime = self.elapsedTime + dt
    self.totalTime = self.totalTime - dt
    if self.totalTime <= 0 then
        self:finishGame()
    end
    self.cameraController:update(dt)
    self.busHead:update(dt)
    if self.elapsedTime >= self.waitTime then
        self.elapsedTime = 0
        self.waitTime = love.math.random(1.5, 6)
    end
    if self.growBus then
        self.growBus = false
        self:increaseBusSize()
    end
end

function GameController:draw()
    self.cameraController:draw(function()
        love.graphics.draw(self.background, 0, 0)
        for _, wall in pairs(self.walls) do wall:draw() end
        --for _, wall in pairs(self.invisibleWall) do wall:draw() end
        self.busHead:draw()
        local count = 0
        for _, passenger in pairs(self.passengers) do
            count = count + 1
            passenger:draw()
        end
        self.totalPassengers = count
    end)
    gameDirector:getLibrary("LetterboardTimer"):draw(self.totalTime)
end

return GameController
