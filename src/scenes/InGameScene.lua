local InGameScene = {}

InGameScene.__index = InGameScene

function InGameScene:new(world)
    local this = {
        DriveTheBus = require "controllers.gamemodes.DriveTheBus",
        gamemodes = {
            names = {"HowMuchMoneyBack"},
            HowMuchMoneyBack = require "controllers.gamemodes.HowMuchMoneyBack"
        },
        fonts = {
            letterboard = love.graphics.newFont("assets/fonts/advanced_led_board-7.ttf", 36),
            default = love.graphics.getFont()
        },
        letterboardImage = love.graphics.newImage("assets/sprites/misc/letterboard.png"),
        world = world,
        currentGamemode = nil
    }
    this.currentGamemode = this.DriveTheBus:getInstance(world)
    this.currentGamemode:setGamemodesController(this)
    sceneDirector:addSubscene("pause", require "scenes.subscenes.PauseGame":new())
    return setmetatable(this, InGameScene)
end

function InGameScene:changeGamemode()
    local gamemodeName = self.gamemodes.names[love.math.random(#self.gamemodes.names)]
    self.currentGamemode = self.gamemodes[gamemodeName]:getInstance(self.world)
    self.currentGamemode:setGamemodesController(this)
    sceneDirector:addSubscene("letterboard", require "scenes.subscenes.Letterboard":new(self.letterboardImage, self.fonts, gamemodeName), true)
    sceneDirector:switchSubscene("letterboard")
end

function InGameScene:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        sceneDirector:switchSubscene("pause")
    end
    self.currentGamemode:keypressed(key, scancode, isrepeat)
end

function InGameScene:keyreleased(key, scancode)
    self.currentGamemode:keyreleased(key, scancode)
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
