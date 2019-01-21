local CameraController = {}
CameraController.__index = CameraController

function CameraController:new(player, mapSize)
    local this = {
        player = player,
        gamera = require "libs.gamera".new(0, 0, mapSize.w, mapSize.h)
    }
    this.gamera:setScale(1)
    this.gamera:setPosition(0, 570)
    return setmetatable(this, CameraController)
end

function CameraController:update(dt)
    local x, y = self.player:getPosition()
    self.gamera:setPosition(x, y)
end

function CameraController:draw(drawFunction)
    self.gamera:draw(drawFunction)
end

return CameraController
