--Models
local World = require "models.business.World"
local GameState = require "models.business.GameState"
local LevelLoader = require "models.business.LevelLoader"

--Actors
local Player = require "models.actors.Player"

--Util
local SpriteSheet = require "util.SpriteSheet"
local SpriteAnimation = require "util.SpriteAnimation"

--Controllers
local CharacterController = require "controllers.CharacterController"
local EnemiesController = require "controllers.EnemiesController"
local CameraController = require "controllers.CameraController"

--Gui Components
local ButtonManager = require "util.ui.ButtonManager"
local ProgressBar = require "util.ui.ProgressBar"

local GameDirector = {}

GameDirector.__index = GameDirector

function GameDirector:configureSpriteSheet(jsonFile, directory, looping, duration, scaleX, scaleY, centerOrigin)
    local newSprite = SpriteSheet:new(jsonFile, directory, nil)
    local frameTable, frameStack = newSprite:getFrames()
    local newAnimation = SpriteAnimation:new(frameTable, newSprite:getAtlas(), duration)
    if centerOrigin then
        newAnimation:setOrigin(newSprite:getCenterOrigin())
    end
    newAnimation:setType(looping)
    newAnimation:setScale(scaleX, scaleY)
    return newAnimation
end

function GameDirector:new()
    local world = World:new()
    local this = {
        bulletsInWorld = {},
        world = world,
        player = Player:new(playerAnimation, world.world),
        lifeBar = ProgressBar:new(20, 20, 200, 40, {1, 0, 0}, 15, 15),
        characterController = CharacterController:new(LifeForm),
        enemiesController = EnemiesController:new(world),
        cameraController = CameraController:new(),
        gameState = GameState:new(),
        --Libraries
        libraries = {
            SpriteSheet = SpriteSheet, LevelLoader = LevelLoader, sti = STI,
            SpriteAnimation = SpriteAnimation, Stack = Stack, LifeForm = LifeForm,
            ProgressBar = ProgressBar, GameState = GameState, ButtonManager = ButtonManager
        }
    }

    this.gameState:save(this.characterController, "characterController")
    return setmetatable(this, GameDirector)
end

function GameDirector:reset()
    self.characterController = self.gameState:load("characterController")
    self.player:reset()
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
    return self.enemiesController:getEnemyByFixture(fixture)
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
