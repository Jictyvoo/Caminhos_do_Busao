local CameraController = {}
CameraController.__index = CameraController

function CameraController:new(player, mapSize, scale)
    local this = {
        player = player,
        gamera = require "libs.gamera".new(mapSize.offsetX or 0, mapSize.offsetY or 0, mapSize.w, mapSize.h)
    }
    this.gamera:setScale(scale or 1)
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
