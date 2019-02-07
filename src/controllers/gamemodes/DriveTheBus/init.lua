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
        instance.gamemodeController:changeGamemode()
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
        elapsedTime = 0,
        score = 0,
        growBus = false,
        walls = {}, invisibleWall = {},
        gamemodeController = nil,
        waitTime = love.math.random(1.5, 6)
    }
    this.cameraController = gameDirector:getLibrary("CameraController"):new(this.busHead, this.mapSize, 1)
    world:addCallback("DriveTheBus", beginContact, "beginContact")
    world:changeCallbacks("DriveTheBus")
    
    local Wall = gameDirector:getLibrary("Wall")
    --[[ Adding walls to game --]]
    table.insert(this.walls, Wall:new(world.world, 1200, 0, {w = 2400, h = 10}))
    table.insert(this.walls, Wall:new(world.world, 1200, 1800, {w = 2400, h = 10}))
    table.insert(this.walls, Wall:new(world.world, 0, 900, {w = 10, h = 1800}))
    table.insert(this.walls, Wall:new(world.world, 2400, 900, {w = 10, h = 1800}))

    --[[ Adding invisible wall --]]
    table.insert(this.invisibleWall, Wall:new(world.world, 80, 600, {w = 10, h = 900}))
    table.insert(this.invisibleWall, Wall:new(world.world, 200, 600, {w = 10, h = 900}))
    table.insert(this.invisibleWall, Wall:new(world.world, 110, 80, {w = 10, h = 130}, nil, 0.653599))
    table.insert(this.invisibleWall, Wall:new(world.world, 720, 40, {w = 1100, h = 10}))
    table.insert(this.invisibleWall, Wall:new(world.world, 720, 150, {w = 1000, h = 10}))
    table.insert(this.invisibleWall, Wall:new(world.world, 1320, 90, {w = 10, h = 150}, nil, -0.553599))
    table.insert(this.invisibleWall, Wall:new(world.world, 1300, 320, {w = 1300, h = 10}))
    table.insert(this.invisibleWall, Wall:new(world.world, 1300, 430, {w = 1300, h = 10}))
    table.insert(this.invisibleWall, Wall:new(world.world, 1650, 180, {w = 600, h = 10}))
    table.insert(this.invisibleWall, Wall:new(world.world, 1650, 290, {w = 600, h = 10}))
    table.insert(this.invisibleWall, Wall:new(world.world, 1150, 620, {w = 520, h = 10}))
    table.insert(this.invisibleWall, Wall:new(world.world, 1150, 730, {w = 480, h = 10}))
    table.insert(this.invisibleWall, Wall:new(world.world, 400, 1330, {w = 520, h = 10}))
    table.insert(this.invisibleWall, Wall:new(world.world, 450, 1450, {w = 480, h = 10}))
    table.insert(this.invisibleWall, Wall:new(world.world, 580, 1480, {w = 740, h = 10}))
    table.insert(this.invisibleWall, Wall:new(world.world, 580, 1580, {w = 740, h = 10}))
    table.insert(this.invisibleWall, Wall:new(world.world, 1730, 1630, {w = 740, h = 10}))
    table.insert(this.invisibleWall, Wall:new(world.world, 1730, 1730, {w = 740, h = 10}))
    table.insert(this.invisibleWall, Wall:new(world.world, 1580, 1340, {w = 450, h = 10}))
    table.insert(this.invisibleWall, Wall:new(world.world, 1580, 1440, {w = 450, h = 10}))
    table.insert(this.invisibleWall, Wall:new(world.world, 520, 650, {w = 10, h = 440}))
    table.insert(this.invisibleWall, Wall:new(world.world, 620, 650, {w = 10, h = 440}))
    table.insert(this.invisibleWall, Wall:new(world.world, 810, 950, {w = 10, h = 440}))
    table.insert(this.invisibleWall, Wall:new(world.world, 910, 950, {w = 10, h = 440}))
    table.insert(this.invisibleWall, Wall:new(world.world, 950, 1390, {w = 10, h = 170}))
    table.insert(this.invisibleWall, Wall:new(world.world, 1050, 1390, {w = 10, h = 170}))
    table.insert(this.invisibleWall, Wall:new(world.world, 1240, 1020, {w = 10, h = 280}))
    table.insert(this.invisibleWall, Wall:new(world.world, 1340, 1020, {w = 10, h = 280}))
    table.insert(this.invisibleWall, Wall:new(world.world, 1240, 1540, {w = 10, h = 200}))
    table.insert(this.invisibleWall, Wall:new(world.world, 1340, 1540, {w = 10, h = 180}))
    table.insert(this.invisibleWall, Wall:new(world.world, 1530, 800, {w = 10, h = 440}))
    table.insert(this.invisibleWall, Wall:new(world.world, 1630, 800, {w = 10, h = 440}))
    table.insert(this.invisibleWall, Wall:new(world.world, 1670, 800, {w = 10, h = 440}))
    table.insert(this.invisibleWall, Wall:new(world.world, 1770, 800, {w = 10, h = 440}))
    table.insert(this.invisibleWall, Wall:new(world.world, 2240, 870, {w = 10, h = 310}))
    table.insert(this.invisibleWall, Wall:new(world.world, 2350, 870, {w = 10, h = 310}))
    table.insert(this.invisibleWall, Wall:new(world.world, 2100, 1450, {w = 10, h = 310}))
    table.insert(this.invisibleWall, Wall:new(world.world, 2210, 1450, {w = 10, h = 310}))
    table.insert(this.invisibleWall, Wall:new(world.world, 1820, 1250, {w = 10, h = 150}))
    table.insert(this.invisibleWall, Wall:new(world.world, 1920, 1250, {w = 10, h = 150}))
    table.insert(this.invisibleWall, Wall:new(world.world, 1960, 510, {w = 10, h = 150}))
    table.insert(this.invisibleWall, Wall:new(world.world, 2070, 510, {w = 10, h = 150}))
    table.insert(this.invisibleWall, Wall:new(world.world, 2210, 505, {w = 10, h = 150}))
    table.insert(this.invisibleWall, Wall:new(world.world, 2110, 515, {w = 10, h = 150}))
    table.insert(this.invisibleWall, Wall:new(world.world, 1590, 1160, {w = 180, h = 10}))
    table.insert(this.invisibleWall, Wall:new(world.world, 420, 895, {w = 180, h = 10}))
    table.insert(this.invisibleWall, Wall:new(world.world, 435, 1045, {w = 180, h = 10}))
    table.insert(this.invisibleWall, Wall:new(world.world, 2080, 1045, {w = 320, h = 10}))
    table.insert(this.invisibleWall, Wall:new(world.world, 345, 1155, {w = 320, h = 10}))
    table.insert(this.invisibleWall, Wall:new(world.world, 1725, 470, {w = 320, h = 10}))
    table.insert(this.invisibleWall, Wall:new(world.world, 425, 1015, {w = 160, h = 10}))
    table.insert(this.invisibleWall, Wall:new(world.world, 2165, 1155, {w = 160, h = 10}))
    table.insert(this.invisibleWall, Wall:new(world.world, 585, 1090, {w = 160, h = 10}, nil, 0.653599))
    table.insert(this.invisibleWall, Wall:new(world.world, 580, 350, {w = 160, h = 10}, nil, -0.503599))
    table.insert(this.invisibleWall, Wall:new(world.world, 835, 670, {w = 160, h = 10}, nil, -0.8035))
    table.insert(this.invisibleWall, Wall:new(world.world, 1280, 800, {w = 160, h = 10}, nil, -0.8035))
    table.insert(this.invisibleWall, Wall:new(world.world, 1430, 1080, {w = 160, h = 10}, nil, -0.8035))
    table.insert(this.invisibleWall, Wall:new(world.world, 1855, 1105, {w = 160, h = 10}, nil, -0.8035))
    table.insert(this.invisibleWall, Wall:new(world.world, 1290, 1380, {w = 160, h = 10}, nil, -0.8035))
    table.insert(this.invisibleWall, Wall:new(world.world, 2710, 955, {w = 160, h = 10}, nil, -0.8035))
    table.insert(this.invisibleWall, Wall:new(world.world, 105, 1400, {w = 160, h = 10}, nil, -0.8035))
    table.insert(this.invisibleWall, Wall:new(world.world, 1555, 530, {w = 160, h = 10}, nil, -0.8035))
    table.insert(this.invisibleWall, Wall:new(world.world, 1885, 1405, {w = 160, h = 10}, nil, -0.8035))
    table.insert(this.invisibleWall, Wall:new(world.world, 2180, 1695, {w = 160, h = 10}, nil, -0.8035))
    table.insert(this.invisibleWall, Wall:new(world.world, 2030, 675, {w = 160, h = 10}, nil, -0.8035))
    table.insert(this.invisibleWall, Wall:new(world.world, 1745, 1095, {w = 160, h = 10}, nil, -0.8035))
    table.insert(this.invisibleWall, Wall:new(world.world, 1455, 1240, {w = 160, h = 10}, nil, -0.8035))
    table.insert(this.invisibleWall, Wall:new(world.world, 1010, 1540, {w = 160, h = 10}, nil, -0.8035))
    table.insert(this.invisibleWall, Wall:new(world.world, 585, 960, {w = 160, h = 10}, nil, -0.8035))
    table.insert(this.invisibleWall, Wall:new(world.world, 2315, 1105, {w = 160, h = 10}, nil, -0.8035))
    table.insert(this.invisibleWall, Wall:new(world.world, 710, 1225, {w = 160, h = 10}, nil, 0.6535))
    table.insert(this.invisibleWall, Wall:new(world.world, 1000, 1230, {w = 160, h = 10}, nil, 0.6535))
    table.insert(this.invisibleWall, Wall:new(world.world, 1290, 1695, {w = 160, h = 10}, nil, 0.6535))
    table.insert(this.invisibleWall, Wall:new(world.world, 130, 1540, {w = 160, h = 10}, nil, 0.6535))
    table.insert(this.invisibleWall, Wall:new(world.world, 560, 1260, {w = 160, h = 10}, nil, 0.6535))
    table.insert(this.invisibleWall, Wall:new(world.world, 135, 1115, {w = 160, h = 10}, nil, 0.6535))
    table.insert(this.invisibleWall, Wall:new(world.world, 855, 1260, {w = 160, h = 10}, nil, 0.6535))
    table.insert(this.invisibleWall, Wall:new(world.world, 1270, 235, {w = 160, h = 10}, nil, 0.6535))
    table.insert(this.invisibleWall, Wall:new(world.world, 1865, 680, {w = 160, h = 10}, nil, 0.6535))
    table.insert(this.invisibleWall, Wall:new(world.world, 2155, 680, {w = 160, h = 10}, nil, 0.6535))
    table.insert(this.invisibleWall, Wall:new(world.world, 1275, 1250, {w = 160, h = 10}, nil, 0.6535))
    table.insert(this.invisibleWall, Wall:new(world.world, 2005, 1255, {w = 160, h = 10}, nil, 0.6535))
    table.insert(this.invisibleWall, Wall:new(world.world, 2155, 1220, {w = 160, h = 10}, nil, 0.6535))
    table.insert(this.invisibleWall, Wall:new(world.world, 1460, 670, {w = 160, h = 10}, nil, 0.6535))
    table.insert(this.invisibleWall, Wall:new(world.world, 2020, 220, {w = 160, h = 10}, nil, 0.6535))
    table.insert(this.invisibleWall, Wall:new(world.world, 2295, 640, {w = 160, h = 10}, nil, 0.6535))
    table.insert(this.invisibleWall, Wall:new(world.world, 2160, 360, {w = 160, h = 10}, nil, 0.6535))
    table.insert(this.invisibleWall, Wall:new(world.world, 1900, 530, {w = 160, h = 10}, nil, 0.7535))
    table.insert(this.invisibleWall, Wall:new(world.world, 745, 1365, {w = 160, h = 10}, nil, 1.8535))
    table.insert(this.invisibleWall, Wall:new(world.world, 260, 960, {w = 160, h = 10}, nil, 2.2535))
    table.insert(this.invisibleWall, Wall:new(world.world, 1440, 820, {w = 160, h = 10}, nil, 2.2535))

    this = setmetatable(this, GameController)
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
end

function GameController:setGamemodesController(gamemodeController)
    self.gamemodeController = gamemodeController
end

function GameController:removePassenger(fixture)
    if self.passengers[fixture] then
        self.passengers[fixture]:destroy()
        self.passengers[fixture] = nil
    end
end

function GameController:addPassenger()
    local passenger = Passenger:new(self.world.world, love.math.random(self.mapSize.w), love.math.random(self.mapSize.h), self.passengerSprite)
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
        love.graphics.draw(self.background, 0, 0)
        for _, wall in pairs(self.walls) do wall:draw() end
        --for _, wall in pairs(self.invisibleWall) do wall:draw() end
        self.busHead:draw()
        for _, passenger in pairs(self.passengers) do
            passenger:draw()
        end
    end)
end

return GameController
