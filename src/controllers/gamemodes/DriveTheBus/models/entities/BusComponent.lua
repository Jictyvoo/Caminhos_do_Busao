local BusComponent = {}

BusComponent.__index = BusComponent

function BusComponent:new(world, x, y, orientation, segmentImages)
    local this = {
        body = love.physics.newBody(world, x or 0, y or 0, "dynamic"),
        shape = love.physics.newRectangleShape(20, 20),
        fixture = nil,
        segmentImages = segmentImages,
        image = segmentImages[love.math.random(1, 2)],
        speed = 250,
        orientations = {up = "vertical", down = "vertical", right = "horizontal", left = "horizontal"},
        currentDirection = orientation,
        nextSegment = {}
    }
    
    --aplying physics
    this.fixture = love.physics.newFixture(this.body, this.shape, 1)
    this.fixture:setUserData("BusComponent")
    this.fixture:setCategory(2)
    this.fixture:setMask(3)

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

function BusComponent:addSegment(componentConstructor, world)
    if self.nextSegment.segment then
        self.nextSegment.segment:addSegment(componentConstructor, world)
    else
        --[[ can change y position from -10 to -20 --]]
        self.nextSegment.segment = componentConstructor:new(world, self.body:getX(), self.body:getY() - 10, self.currentDirection, self.segmentImages)
        self.nextSegment.joint = love.physics.newRevoluteJoint(self.body, self.nextSegment.segment.body, self.body:getX(), self.body:getY(), true)
        --[[self.nextSegment.joint:setLimits(-2, 2)
        self.nextSegment.joint:setLimitsEnabled(true)--]]
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
    if self.nextSegment.segment then
        self.nextSegment.segment:update(dt)
    end
    self.body:setLinearVelocity(xVelocity, yVelocity)
end

function BusComponent:debugDraw()
    local x1, y1, x2, y2 = self.nextSegment.joint:getAnchors( )
    love.graphics.setColor(0.6, 1, 0.33)
    love.graphics.circle("fill", x1, y1, 5)
    love.graphics.circle("fill", x2, y2, 5)
    love.graphics.setColor(1, 1, 1)
end

function BusComponent:draw()
    --love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    love.graphics.draw(self.image, self.body:getX(), self.body:getY(), self.body:getAngle(), 0.5, 0.5, self.image:getWidth() / 2, self.image:getHeight() / 2)
    if self.nextSegment.segment then
        self.nextSegment.segment:draw()
    end
end

return BusComponent
