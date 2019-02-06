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
        background = love.graphics.newImage("assets/sprites/BusStop/steering_wheel_background.png"),
        busStops = {}, x = 900, currentStop = 1, requestedStop = love.math.random(5),
        elapsedTime = 0, tries = 0, totalTime = 40,
        score = 0,
    }
    world:addCallback("BusStop", beginContact, "beginContact")
    world:changeCallbacks("BusStop")
    
    this = setmetatable(this, GameController)
    for count = 1, 5 do
        table.insert(this.busStops, love.graphics.newImage(string.format("assets/sprites/BusStop/stop_%d.png", count)))
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
    self.x = 900; self.currentStop = 1; self.requestedStop = love.math.random(5)
    self.elapsedTime = 0; self.tries = 0; self.score = 0
end

function GameController:setGamemodesController(gamemodeController)
    self.gamemodeController = gamemodeController
end

function GameController:finishGame()
    self.gamemodeController:exitGamemode()
    self:reset()
end

function GameController:keypressed(key, scancode, isrepeat)
    if key == "space" then
        self.tries = self.tries + 1
        if self.tries > 3 then
            self:finishGame()
        elseif self.x >= 296 - 10 and self.x <= 296 + 10 then
            if self.currentStop == self.requestedStop then
                self.requestedStop = love.math.random(1, #self.busStops); self.score = self.score + 1
            else
                self:finishGame()
            end
            self:resetStop()
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

function GameController:resetStop()
    self.x = 900
    if self.currentStop >= #self.busStops then self.currentStop = 1 else self.currentStop = self.currentStop + 1 end
end

function GameController:update(dt)
    self.elapsedTime = self.elapsedTime + dt
    self.totalTime = self.totalTime - dt
    if self.totalTime <= 0 then
        self:finishGame()
    elseif self.elapsedTime >= 0.01 then
        self.x = self.x - 5
        if self.x <= 140 then
            self:resetStop()
        end
        self.elapsedTime = 0
    end
end

function GameController:draw()
    love.graphics.setBackgroundColor(0.7098039, 0.94901960784, 0.95686274509)
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("line", 121, 264, 135)
    love.graphics.circle("line", 404, 119, 108)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.busStops[self.currentStop], self.x, 11, 0, 0.4, 0.4)
    love.graphics.setFont(gameDirector:getFonts().ledDigits)
    love.graphics.printf(string.format("Paradas realizadas: %d", self.score), 555, 264, 250, "center")
    love.graphics.setFont(gameDirector:getFonts().default)
    love.graphics.draw(self.busStops[self.requestedStop], -70, 240, -0.65, 0.5, 0.5)
    love.graphics.draw(self.background, 0, 0, 0)
end

return GameController
