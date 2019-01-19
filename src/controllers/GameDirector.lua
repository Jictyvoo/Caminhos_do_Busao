-- Controllers
local DataPersistence = require "controllers.DataPersistence"

-- Models
local World = require "models.business.World"

-- Game UI
local ButtonManager = require "util.ui.ButtonManager"

-- Libraries
local Sanghost = require "libs.Sanghost.Sanghost"
local Pixelurite = require "libs.Pixelurite"

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
            Sanghost = Sanghost, ButtonManager = ButtonManager, Pixelurite = Pixelurite,
            DataPersistence = DataPersistence
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

function GameDirector:getWorld()
    return self.world
end

function GameDirector:update(dt)
    self.world:update(dt)
end

function GameDirector:draw()
    
end

return GameDirector
