local currentPath   = (...):gsub('%.init$', '') .. "."
local GameController = {}
local instance = nil
local updateStates = {}

GameController.__index = GameController

local function beginContact(a, b, col)
end

local function endContact(a, b, col)
end

updateStates[2] = function(dt)
    if instance.currentState == 2 then
        instance.gateAngle = instance.gateAngle - dt
        if instance.gateAngle <= -math.pi / 2 then
            instance.currentState = 0
            instance.gateAngle = 0
            instance.updateFunction = updateStates[1]
        end
    end
end

updateStates[1] = function(dt)
    if instance.elapsedTime >= 0.02 then
        instance.hand.y = instance.hand.y + 8 * (instance.currentState == 0 and 1 or -1)
        instance.hand.x = instance.hand.x + 1 * (instance.currentState == 0 and -1 or 1)
        instance.elapsedTime = 0
    end
    if instance.currentState == 0 and instance.hand.y >= 280 then
        instance.waitTime = 1.5
        instance.currentState = 1
        instance.hand.currentQuad = instance.hand.spritesheet:getQuads()["hand0001"]
        instance.moneyValue = instance.probableValues[love.math.random(#instance.probableValues)]
    elseif instance.currentState == 1 and instance.hand.y <= -60 then
        instance.currentState = 0
        instance.hand.currentQuad = instance.hand.spritesheet:getQuads()["hand0000"]
        instance.updateFunction = updateStates[2]
    end
end

function GameController:new(world)
    local this = {
        world = world,
        gamemodeController = nil, gateAngle = 0, totalTime = 0,
        elapsedTime = 0, waitTime = 0, ticketGate = love.graphics.newImage("assets/sprites/HowMuchMoneyBack/ticket_gate.png"),
        hand = {spritesheet = nil, x = 660, y = -60, currentQuad = nil}, button = nil,
        buttonSprite = gameDirector:getLibrary("Pixelurite").getSpritesheet():new("button", "assets/sprites/HowMuchMoneyBack/"),
        arrowButtonSprite = gameDirector:getLibrary("Pixelurite").getSpritesheet():new("arrow_button", "assets/sprites/HowMuchMoneyBack/"),
        score = 0,
        updateFunction = updateStates[1], currentState = 0,
        background = love.graphics.newImage("assets/sprites/HowMuchMoneyBack/background.png"),
        table_background = love.graphics.newImage("assets/sprites/HowMuchMoneyBack/table_background.png"),
        exchangeImage = {
            ["10"] = love.graphics.newImage("assets/sprites/HowMuchMoneyBack/money_10.png"),
            ["20"] = love.graphics.newImage("assets/sprites/HowMuchMoneyBack/money_20.png"),
            ["5"] = love.graphics.newImage("assets/sprites/HowMuchMoneyBack/money_5.png"),
            ["2"] = love.graphics.newImage("assets/sprites/HowMuchMoneyBack/money_2.png"),
            ["0.50"] = love.graphics.newImage("assets/sprites/HowMuchMoneyBack/money_0.50.png"),
            ["0.25"] = love.graphics.newImage("assets/sprites/HowMuchMoneyBack/money_0.25.png"),
            ["0.10"] = love.graphics.newImage("assets/sprites/HowMuchMoneyBack/money_0.10.png"),
            ["0.05"] = love.graphics.newImage("assets/sprites/HowMuchMoneyBack/money_0.05.png")
        }, probableValues = {10, 20, 5}, moneyValue = 0, exchangeValue = 0, arrowButtons = {}
    }
    world:addCallback("HowMuchMoneyBack", beginContact, "beginContact")
    world:changeCallbacks("HowMuchMoneyBack")
    
    this = setmetatable(this, GameController)
    this.hand.spritesheet = gameDirector:getLibrary("Pixelurite").getSpritesheet():new("hands", "assets/sprites/HowMuchMoneyBack/")
    this.hand.currentQuad = this.hand.spritesheet:getQuads()["hand0000"]
    local spriteQuads = this.buttonSprite:getQuads()
    local buttonQuads = {
        normal = spriteQuads["normal"], hover = spriteQuads["normal"],
        pressed = spriteQuads["pressed"], disabled = spriteQuads["pressed"]
    }
    this.button = gameDirector:getLibrary("Button"):new(nil, 40, 420, 60, 80, buttonQuads, this.buttonSprite:getAtlas())
    this.button:setCallback(function(self)
        if tostring(this.exchangeValue) == tostring(this.moneyValue - 3.8) then
            this.currentState = 2; this.moneyValue = 0; this.exchangeValue = 0; this.score = this.score + 1
        else
            sceneDirector:switchSubscene("gameOver")
        end
    end)

    this:addArrowButton(575, 300, 5, true)
    this:addArrowButton(575, 470, -5, false)
    this:addArrowButton(435, 300, 2, true)
    this:addArrowButton(435, 470, -2, false)
    this:addArrowButton(275, 300, 0.50, true)
    this:addArrowButton(275, 470, -0.50, false)
    this:addArrowButton(125, 300, 0.10, true)
    this:addArrowButton(125, 470, -0.10, false)
    return this
end

function GameController:getInstance(world)
    if not instance then
        instance = GameController:new(world)
    end
    return instance
end

function GameController:reset()
    self.moneyValue = 0; self.totalTime = 0; self.elapsedTime = 0; self.exchangeValue = 0; self.score = 0;
    self.updateFunction = updateStates[1]; self.gateAngle = 0; self.currentState = 0
end

function GameController:setGamemodesController(gamemodeController)
    self.gamemodeController = gamemodeController
end

function GameController:addArrowButton(x, y, value, angle)
    local spriteQuads = self.arrowButtonSprite:getQuads()
    local buttonQuads = {
        normal = spriteQuads["normal"], hover = spriteQuads["normal"],
        pressed = spriteQuads["pressed"], disabled = spriteQuads["pressed"]
    }
    local button = gameDirector:getLibrary("Button"):new(nil, x, y, 100, 50, buttonQuads, self.arrowButtonSprite:getAtlas())
    table.insert(self.arrowButtons, button)
    button:setCallback(function(this) self.exchangeValue = self.exchangeValue + value end)
    if angle then
        button:setScale(1, -1)
        button:setOffset(0, 50)
    end
end

function GameController:keypressed(key, scancode, isrepeat)
end

function GameController:keyreleased(key, scancode)
end

function GameController:mousemoved(x, y, dx, dy, istouch)
    self.button:mousemoved(x, y, dx, dy, istouch)
    for _, button in pairs(self.arrowButtons) do
        button:mousemoved(x, y, dx, dy, istouch)
    end
end

function GameController:mousepressed(x, y, button, istouch)
    self.button:mousepressed(x, y, button, istouch)
    for _, button in pairs(self.arrowButtons) do
        button:mousepressed(x, y, button, istouch)
    end
end

function GameController:mousereleased(x, y, button, istouch)
    self.button:mousereleased(x, y, button, istouch)
    for _, button in pairs(self.arrowButtons) do
        button:mousereleased(x, y, button, istouch)
    end
end

function GameController:update(dt)
    if self.waitTime > 0 then
        self.waitTime = self.waitTime - dt
    else
        self.totalTime = self.totalTime + dt
        if self.totalTime > 15 then
            self.gamemodeController:exitGamemode()
            self:reset()
        else
        self.elapsedTime = self.elapsedTime + dt
        self.updateFunction(dt)
        end
    end
end

function GameController:draw()
    love.graphics.draw(self.background, 0, 0, 0, sx, sy, ox, oy)
    love.graphics.draw(self.ticketGate, love.graphics.getWidth() / 2, -90, self.gateAngle, 1, 1, self.ticketGate:getWidth() / 2, self.ticketGate:getHeight() / 2)
    if self.moneyValue > 0 then
        love.graphics.draw(self.exchangeImage[tostring(self.moneyValue)], 510, 210, -math.pi / 3, 0.33, 0.33, ox, oy)
    end
    love.graphics.draw(self.hand.spritesheet:getAtlas(), self.hand.currentQuad, self.hand.x, self.hand.y, 3.66519)
    self.button:draw()
    --[[ Drawing exchanges --]]
    love.graphics.draw(self.exchangeImage["5"], 670, 310, math.pi / 2, 0.5, 0.5)
    love.graphics.draw(self.exchangeImage["2"], 530, 310, math.pi / 2, 0.5, 0.5)
    love.graphics.draw(self.exchangeImage["0.50"], 270, 360, 0, 1, 1)
    love.graphics.draw(self.exchangeImage["0.10"], 130, 360, 0, 1, 1)
    love.graphics.draw(self.table_background, 83, 277)
    --[[ Drawing Buttons --]]
    for _, button in pairs(self.arrowButtons) do
        button:draw()
    end

    love.graphics.setFont(gameDirector:getFonts().ledDigits)
    love.graphics.print(string.format("Troco Atual: %f", self.exchangeValue), 210, 240, 0)
    love.graphics.setFont(gameDirector:getFonts().default)
end

return GameController
