local Bus = {}

Bus.__index = Bus

function Bus:new(world, x, y)
    local this = {
        body = love.physics.newBody(world, x or 0, y or 0, "kinematic"),
        shape = love.physics.newRectangleShape(50, 20),
        fixture = nil,
        keys = {up = "up", down = "down", right = "right", left = "left"},
        orientations = {up = "vertical", down = "vertical", right = "horizontal", left = "horizontal"},
        currentDirection = "right"
    }
    
    --aplying physics
    this.fixture = love.physics.newFixture(this.body, this.shape, 1)
    this.fixture:setUserData("Bus")
    this.fixture:setCategory(1)
    this.fixture:setMask(1)

    return setmetatable(this, Bus)
end

function Bus:rotate(previousDirection, newDirection)
    if self.orientations[previousDirection] == "horizontal" then
        if newDirection == "up" then
            self.body:setAngle(math.pi / 2 * (previousDirection == "right" and 1 or -1))
        else
            self.body:setAngle(math.pi / 2 * (previousDirection == "right" and -1 or 1))
        end
    else
        if newDirection == "right" then
            self.body:setAngle(math.pi * (previousDirection == "up" and 1 or -1))
        else
            self.body:setAngle(-math.pi * (previousDirection == "up" and 1 or -1))
        end
    end
end

function Bus:keypressed(key, scancode, isrepeat)
    if self.keys[key] then
        if self.orientations[self.currentDirection] ~= self.orientations[self.keys[key]] then
            self:rotate(self.currentDirection, self.keys[key])
            self.currentDirection = self.keys[key]
        end
    end
end

function Bus:keyreleased(key, scancode)
end

function Bus:update(dt)
    local xVelocity = 0
    local yVelocity = 0
    if self.orientations[self.currentDirection] == "vertical" then
        yVelocity = 100 * (self.currentDirection == "up" and -1 or 1)
    else
        xVelocity = 100 * (self.currentDirection == "left" and -1 or 1)
    end
    self.body:setLinearVelocity(xVelocity, yVelocity)
end

function Bus:draw()
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    --love.graphics.rectangle("fill", self.body:getX(), self.body:getY(), 50, 20)
end

return Bus
