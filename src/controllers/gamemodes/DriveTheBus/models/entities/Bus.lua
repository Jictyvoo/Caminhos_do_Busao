local Bus = {}

Bus.__index = Bus

function Bus:new(world, x, y)
    local this = {
        body = love.physics.newBody(world, x or 0, y or 0, "dynamic"),
        shape = love.physics.newRectangleShape(50, 20),
        fixture = nil,
        speed = 250,
        keys = {up = "up", down = "down", right = "right", left = "left"},
        orientations = {up = "vertical", down = "vertical", right = "horizontal", left = "horizontal"},
        currentDirection = "right",
        world = world,
        nextSegment = nil
    }
    
    --aplying physics
    this.body:setFixedRotation(true)
    this.fixture = love.physics.newFixture(this.body, this.shape, 1)
    this.fixture:setUserData("Bus")
    this.fixture:setCategory(1)
    this.fixture:setMask(1)

    return setmetatable(this, Bus)
end

function Bus:increaseSize(componentConstructor)
    local x = 0; local y = 0
    if self.orientations[self.currentDirection] == "horizontal" then
        x = 60 * (self.currentDirection == "left" and -1 or 1)
    else
        y = 50 * (self.currentDirection == "up" and -1 or 1)
    end
    local newComponent = componentConstructor:new(self.world, self.body:getX() - x, self.body:getY() - y, self.currentDirection)
    if self.nextSegment then
        self.nextSegment:addSegment(newComponent)
    else
        self.nextSegment = newComponent
    end
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

function Bus:getPosition()
    return self.body:getX(), self.body:getY()
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
        yVelocity = self.speed * (self.currentDirection == "up" and -1 or 1)
    else
        xVelocity = self.speed * (self.currentDirection == "left" and -1 or 1)
    end
    self.body:setLinearVelocity(xVelocity, yVelocity)
    if self.nextSegment then
        self.nextSegment:update(dt)
    end
end

function Bus:draw()
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    if self.nextSegment then
        self.nextSegment:draw()
    end
    --love.graphics.rectangle("fill", self.body:getX(), self.body:getY(), 50, 20)
end

return Bus
