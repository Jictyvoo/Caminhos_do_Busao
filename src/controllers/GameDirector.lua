-- Controllers
local CameraController = require "controllers.CameraController"
local DataPersistence = require "controllers.DataPersistence"

-- Models
local LetterboardTimer = require "models.LetterboardTimer"
local World = require "models.business.World"
local Wall = require "models.business.Wall"

-- Game UI
local Button = require "util.ui.Button"
local ButtonManager = require "util.ui.ButtonManager"

-- Libraries
local Sanghost = require "libs.Sanghost.Sanghost"
local Pixelurite = require "libs.Pixelurite"
local MoonJohn = require "libs.MoonJohn"

local GameDirector = {}

GameDirector.__index = GameDirector

function GameDirector:new()
    local world = World:new()
    local this = {
        world = world,
        sanghost = Sanghost:new(),
        levelData = nil,
        dataPersistence = DataPersistence:new(),
        --Libraries
        libraries = {
            Sanghost = Sanghost, ButtonManager = ButtonManager, Button = Button, Pixelurite = Pixelurite,
            CameraController = CameraController, DataPersistence = DataPersistence,
            Wall = Wall, LetterboardTimer = LetterboardTimer, MoonJohn = MoonJohn
        },
        fonts = {
            default = love.graphics.getFont(),
            ledDigits = love.graphics.newFont("assets/fonts/DS-DIGII.ttf", 36),
            letterboard = love.graphics.newFont("assets/fonts/advanced_led_board-7.ttf", 36)
        }
    }

    return setmetatable(this, GameDirector)
end

function GameDirector:reset()
    self.levelData = self.dataPersistence:load()
end

function GameDirector:getLibrary(library)
    return self.libraries[library]
end

function GameDirector:keypressed(key, scancode, isrepeat)
    self.player:keypressed(key, scancode, isrepeat)
end

function GameDirector:keyreleased(key, scancode)
    self.player:keyreleased(key, scancode)
end

function GameDirector:getEntityByFixture(fixture)
    if fixture:getUserData() == "Player" then
        return self.characterController
    end
end

function GameDirector:getFonts()
    return self.fonts
end

function GameDirector:getWorld()
    return self.world
end

function GameDirector:update(dt)
    self.world:update(dt)
end

function GameDirector:draw()
    
end

return GameDirector
