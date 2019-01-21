local BusComponent = {}

BusComponent.__index = BusComponent

function BusComponent:new(world, x, y, orientation)
    local this = {
        body = love.physics.newBody(world, x or 0, y or 0, "kinematic"),
        shape = love.physics.newRectangleShape(50, 20),
        fixture = nil,
        speed = 250,
        orientations = {up = "vertical", down = "vertical", right = "horizontal", left = "horizontal"},
        currentDirection = orientation,
        nextSegment = nil
    }
    
    --aplying physics
    this.fixture = love.physics.newFixture(this.body, this.shape, 1)
    this.fixture:setUserData("BusComponent")
    this.fixture:setCategory(2)
    this.fixture:setMask(2, 3)

    this = setmetatable(this, BusComponent)
    if orientation ~= "right" then
        if orientation == "left" then
            this.body:setAngle(math.pi)
        else
            this:rotate("right", orientation)
        end
    end
    return this
end

function BusComponent:addSegment(segment)
    if self.nextSegment then
        self.nextSegment:addSegment(segment)
    else
        self.nextSegment = segment
    end
end

function BusComponent:rotate(previousDirection, newDirection)
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

function BusComponent:update(dt)
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

function BusComponent:draw()
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    if self.nextSegment then
        self.nextSegment:draw()
    end
end

return BusComponent
