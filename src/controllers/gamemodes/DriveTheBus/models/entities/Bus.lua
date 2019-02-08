local Bus = {}

Bus.__index = Bus

function Bus:new(world, x, y, componentConstructor)
    local segmentImages = {
        love.graphics.newImage("assets/sprites/DriveTheBus/bus_body_1.png"),
        love.graphics.newImage("assets/sprites/DriveTheBus/bus_body_2.png")
    }
    local this = {
        body = love.physics.newBody(world, x or 0, y or 0, "dynamic"),
        shape = love.physics.newRectangleShape(20, 40),
        fixture = nil,
        speed = 250,
        keys = {up = "up", down = "down", right = "right", left = "left"},
        orientations = {up = "vertical", down = "vertical", right = "horizontal", left = "horizontal"},
        currentDirection = nil,
        world = world,
        nextSegment = {segment = componentConstructor:new(world, x, y - 20, "down", segmentImages), joint = nil},
        segmentImages = segmentImages, image = love.graphics.newImage("assets/sprites/DriveTheBus/bus_head.png"),
        canMove = true,
        elapsedTime = 0
    }
    this.nextSegment.segment.fixture:setCategory(4)
    this.nextSegment.joint = love.physics.newRevoluteJoint(this.body, this.nextSegment.segment.body, x, y - 20)
    this.nextSegment.joint:setLimits(-0.1, 0.1)
    this.nextSegment.joint:setLimitsEnabled(true)
    --aplying physics
    this.body:setFixedRotation(true)
    this.fixture = love.physics.newFixture(this.body, this.shape, 1)
    this.fixture:setUserData("Bus")
    this.fixture:setCategory(1)
    this.fixture:setMask(1, 4)

    return setmetatable(this, Bus)
end

function Bus:increaseSize(componentConstructor)
    self.nextSegment.segment:addSegment(componentConstructor, self.world)
end

function Bus:rotate(direction)
    if direction then
        if direction == "right" then
            self.body:setAngle(self.body:getAngle() + (math.pi / 10 * 1))
        else
            self.body:setAngle(self.body:getAngle() + (math.pi / 10 * -1))
        end
    end
end

function Bus:getPosition()
    return self.body:getX(), self.body:getY()
end

function Bus:stop()
    self.body:setLinearVelocity(0, 0)
end

function Bus:keypressed(key, scancode, isrepeat)
    if self.keys[key] then
        if self.orientations[self.keys[key]] == "horizontal" then
            self.currentDirection = self.keys[key]
        end
    end
end

function Bus:keyreleased(key, scancode)
    if self.keys[key] == self.currentDirection then
        self.currentDirection = nil
    end
end

function Bus:update(dt)
    self.elapsedTime = self.elapsedTime + dt
    local xVelocity = -self.speed * math.sin(self.body:getAngle())
    local yVelocity = self.speed * math.cos(self.body:getAngle())
    
    self.body:setLinearVelocity(xVelocity, yVelocity)
    --[[if self.nextSegment then
        self.nextSegment.segment:update(dt)
    end--]]
    if self.elapsedTime >= 0.02 then
        self:rotate(self.currentDirection)
        self.elapsedTime = 0
    end
end

function Bus:draw()
    --love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    love.graphics.draw(self.image, self.body:getX(), self.body:getY(), self.body:getAngle(), 1, 1, 12, 20)
    if self.nextSegment then
        self.nextSegment.segment:draw()
    end
    --[[local x1, y1, x2, y2 = self.nextSegment.joint:getAnchors( )
    love.graphics.setColor(0.6, 1, 0.33)
    love.graphics.circle("fill", x1, y1, 5)
    love.graphics.circle("fill", x2, y2, 5)
    love.graphics.setColor(1, 1, 1)--]]
end

return Bus
