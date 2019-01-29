local currentPath   = (...):gsub('%.init$', '') .. "."
local GameController = {}
local instance = nil

GameController.__index = GameController

local function beginContact(a, b, col)
end

local function endContact(a, b, col)
end

local function state_2(dt)
    if instance.currentState == 2 then
        instance.gateAngle = instance.gateAngle + dt
        if instance.gateAngle >= math.pi / 2 then
            instance.currentState = 0
            instance.gateAngle = 0
        end
    end
end

local function state_1(dt)
    if instance.elapsedTime >= 0.02 then
        instance.hand.y = instance.hand.y + 5 * (instance.currentState == 0 and 1 or -1)
        instance.hand.x = instance.hand.x + 1 * (instance.currentState == 0 and -1 or 1)
        instance.elapsedTime = 0
    end
    if instance.currentState == 0 and instance.hand.y >= 280 then
        instance.waitTime = 1.5
        instance.currentState = 1
    elseif instance.currentState == 1 and instance.hand.y <= -60 then
        instance.currentState = 0
        instance.updateFunction = state_2
    end
end

function GameController:new(world)
    local this = {
        world = world,
        gamemodeController = nil, gateAngle = 0,
        elapsedTime = 0, waitTime = 0, ticketGate = love.graphics.newImage("assets/sprites/HowMuchMoneyBack/ticket_gate.png"),
        hand = {spritesheet = nil, x = 660, y = -60, currentQuad = nil}, button = nil,
        buttonSprite = gameDirector:getLibrary("Pixelurite").getSpritesheet():new("button", "assets/sprites/HowMuchMoneyBack/"),
        score = 0,
        updateFunction = state_1, currentState = 0,
        background = love.graphics.newImage("assets/sprites/HowMuchMoneyBack/background.png")
    }
    world:addCallback("HowMuchMoneyBack", beginContact, "beginContact")
    world:changeCallbacks("HowMuchMoneyBack")
    
    this = setmetatable(this, GameController)
    this.hand.spritesheet = gameDirector:getLibrary("Pixelurite").getSpritesheet():new("hands", "assets/sprites/HowMuchMoneyBack/")
    this.hand.currentQuad = this.hand.spritesheet:getQuads()["hand0001"]
    local spriteQuads = this.buttonSprite:getQuads()
    local buttonQuads = {
        normal = spriteQuads["normal"], hover = spriteQuads["normal"],
        pressed = spriteQuads["pressed"], disabled = spriteQuads["pressed"]
    }
    this.button = gameDirector:getLibrary("Button"):new(nil, 40, 420, 60, 80, buttonQuads, this.buttonSprite:getAtlas())
    this.button:setCallback(function(self) this.currentState = 2 end)
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

function GameController:setGamemodesController(gamemodeController)
    self.gamemodeController = gamemodeController
end

function GameController:keypressed(key, scancode, isrepeat)
end

function GameController:keyreleased(key, scancode)
end

function GameController:mousemoved(x, y, dx, dy, istouch)
    self.button:mousemoved(x, y, dx, dy, istouch)
end

function GameController:mousepressed(x, y, button, istouch)
    self.button:mousepressed(x, y, button, istouch)
end

function GameController:mousereleased(x, y, button, istouch)
    self.button:mousereleased(x, y, button, istouch)
end

function GameController:update(dt)
    if self.waitTime > 0 then
        self.waitTime = self.waitTime - dt
    else
        self.elapsedTime = self.elapsedTime + dt
        self.updateFunction(dt)
    end
end

function GameController:draw()
    love.graphics.draw(self.background, 0, 0, 0, sx, sy, ox, oy)
    love.graphics.draw(self.ticketGate, love.graphics.getWidth() / 2, -90, self.gateAngle, 1, 1, self.ticketGate:getWidth() / 2, self.ticketGate:getHeight() / 2)
    love.graphics.draw(self.hand.spritesheet:getAtlas(), self.hand.currentQuad, self.hand.x, self.hand.y, 3.66519)
    self.button:draw()
end

return GameController
