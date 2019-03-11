local Letterboard = {}

Letterboard.__index = Letterboard

function Letterboard:new(image, fonts, text)
    local this = {
        state = false,
        image = image,
        fonts = fonts,
        text = text,
        y = -40, elapsedTime = 0, waitTime = 0
    }
    
    scaleDimension:calculeScales("letterboardImage", this.image:getWidth(), this.image:getHeight(), 0, 0)
    scaleDimension:centralize("letterboardImage", true, false, false)
    return setmetatable(this, Letterboard)
end

function Letterboard:update(dt)
    self.elapsedTime = self.elapsedTime + dt
    if self.waitTime > 0 then
        self.waitTime = self.waitTime - dt
    elseif self.elapsedTime >= 0.02 then
        self.y = self.y + 5 * (self.state and -1 or 1)
        self.elapsedTime = 0
    end
    if self.state then
        if self.y <= -80 then
            sceneDirector:exitSubscene()
        end
    else
        if self.y >= 0 then
            self.state = true
            self.waitTime = 2.5
        end
    end
end

function Letterboard:draw()
    love.graphics.setFont(self.fonts.letterboard)
    local scales = scaleDimension:getScale("letterboardImage")
    love.graphics.draw(self.image, scales.x, self.y, 0)
    love.graphics.printf(self.text, scales.x, self.y + 10, self.image:getWidth() - 20, "center")
    --love.graphics.print(self.text, (love.graphics.getWidth() / 2) - 160, self.y + 20, 0)
    love.graphics.setFont(self.fonts.default)
end

return Letterboard
