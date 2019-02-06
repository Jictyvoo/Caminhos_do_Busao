local InGameScene = {}

InGameScene.__index = InGameScene

function InGameScene:new(world)
    local this = {
        DriveTheBus = require "controllers.gamemodes.DriveTheBus",
        gamemodes = {
            names = {
                "HowMuchMoneyBack",
                "DeficientElevator"
            },
            instructions = {
                DriveTheBus = "Você deve dirigir o busão para pegar passeiros",
                HowMuchMoneyBack = "Você deve contar o valor do troco corretamente para o passageiro",
                DeficientElevator = "Aperte os botões para cima e para baixo o mais rápido que conseguir"
            },
            HowMuchMoneyBack = require "controllers.gamemodes.HowMuchMoneyBack",
            DeficientElevator = require "controllers.gamemodes.DeficientElevator"
        },
        fonts = {
            letterboard = love.graphics.newFont("assets/fonts/advanced_led_board-7.ttf", 36),
            default = love.graphics.getFont()
        },
        letterboardImage = love.graphics.newImage("assets/sprites/misc/letterboard.png"),
        world = world,
        currentGamemode = nil, gamemodeName = "DriveTheBus"
    }
    this.currentGamemode = this.DriveTheBus:getInstance(world)
    this.currentGamemode:setGamemodesController(this)
    sceneDirector:addSubscene("pause", require "scenes.subscenes.PauseGame":new())
    sceneDirector:addSubscene("gameOver", require "scenes.subscenes.GameOver":new())
    return setmetatable(this, InGameScene)
end

function InGameScene:changeGamemode()
    self.gamemodeName = self.gamemodes.names[love.math.random(#self.gamemodes.names)]
    self.currentGamemode = self.gamemodes[self.gamemodeName]:getInstance(self.world)
    self.currentGamemode:setGamemodesController(self)
    self.currentGamemode:reset()
    sceneDirector:addSubscene("letterboard", require "scenes.subscenes.Letterboard":new(self.letterboardImage, self.fonts, self.gamemodeName), true)
    sceneDirector:switchSubscene("letterboard")
end

function InGameScene:exitGamemode()
    self.currentGamemode = self.DriveTheBus:getInstance(self.world)
    self.gamemodeName = "DriveTheBus"
    self.world:changeCallbacks("DriveTheBus")
end

function InGameScene:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        sceneDirector:switchSubscene("pause", self.gamemodes.instructions[self.gamemodeName])
    end
    self.currentGamemode:keypressed(key, scancode, isrepeat)
end

function InGameScene:keyreleased(key, scancode)
    self.currentGamemode:keyreleased(key, scancode)
end

function InGameScene:mousemoved(x, y, dx, dy, istouch)
    if self.currentGamemode.mousemoved then
        self.currentGamemode:mousemoved(x, y, dx, dy, istouch)
    end
end

function InGameScene:mousepressed(x, y, button, istouch)
    if self.currentGamemode.mousepressed then
        self.currentGamemode:mousepressed(x, y, button, istouch)
    end
end

function InGameScene:mousereleased(x, y, button, istouch)
    if self.currentGamemode.mousereleased then
        self.currentGamemode:mousereleased(x, y, button, istouch)
    end
end

function InGameScene:reset()
    gameDirector:reset()
    self.currentGamemode:reset()
end

function InGameScene:update(dt)
    gameDirector:update(dt)
    self.currentGamemode:update(dt)
end

function InGameScene:draw()
    self.currentGamemode:draw()
end

return InGameScene
