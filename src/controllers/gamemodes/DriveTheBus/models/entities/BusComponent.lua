local BusComponent = {}

BusComponent.__index = BusComponent

function BusComponent:new(world, x, y, orientation)
    local this = {
        body = love.physics.newBody(world, x or 0, y or 0, "kinematic"),
        shape = love.physics.newRectangleShape(20, 20),
        fixture = nil,
        speed = 250,
        orientations = {up = "vertical", down = "vertical", right = "horizontal", left = "horizontal"},
        currentDirection = orientation,
        nextSegment = nil,
        lifetimeDirections = {},
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

function BusComponent:addSegment(componentConstructor, world)
    local x = 0; local y = 0
    if self.orientations[self.currentDirection] == "horizontal" then
        x = 10 * (self.currentDirection == "left" and -1 or 1)
    else
        y = 10 * (self.currentDirection == "up" and -1 or 1)
    end
    if self.nextSegment then
        self.nextSegment:addSegment(componentConstructor, world)
    else
        self.nextSegment = componentConstructor:new(world, self.body:getX() - x, self.body:getY() - y, self.currentDirection)
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

function BusComponent:changeDirection(to, untilArrive)
    if to then
        untilArrive.to = to
        table.insert(self.lifetimeDirections, untilArrive)
    end
end

function BusComponent:changeOrientationNow()
    if self.orientations[self.currentDirection] ~= self.orientations[self.lifetimeDirections[1].to] then
        self:rotate(self.currentDirection, self.lifetimeDirections[1].to)
    end
    print("Changed")
    self.currentDirection = self.lifetimeDirections[1].to
    if self.nextSegment then
        self.nextSegment:changeDirection(self.currentDirection, self.lifetimeDirections[1])
    end
    table.remove(self.lifetimeDirections)
end

function BusComponent:update(dt)
    local xVelocity = 0
    local yVelocity = 0
    if self.orientations[self.currentDirection] == "vertical" then
        yVelocity = self.speed * (self.currentDirection == "up" and -1 or 1)
    else
        xVelocity = self.speed * (self.currentDirection == "left" and -1 or 1)
    end
    if self.nextSegment then
        self.nextSegment:update(dt)
    end
    if self.lifetimeDirections[1] then
        if self.orientations[self.currentDirection] == "horizontal" then
            if (self.currentDirection == "right" and self.body:getX() >= self.lifetimeDirections[1].x) or (self.currentDirection == "left" and self.body:getX() <= self.lifetimeDirections[1].x) then
                self.body:setX(self.lifetimeDirections[1].x)
                self.body:setY(self.lifetimeDirections[1].y)
                self:changeOrientationNow()
            end
        else
            print(self.currentDirection, self.body:getY(), self.lifetimeDirections[1].y, self.lifetimeDirections[1].to)
            if (self.currentDirection == "down" and self.body:getY() >= self.lifetimeDirections[1].y) or (self.currentDirection == "up" and self.body:getY() <= self.lifetimeDirections[1].y) then
                self.body:setX(self.lifetimeDirections[1].x)
                self.body:setY(self.lifetimeDirections[1].y)
                self:changeOrientationNow()
            end
        end
    end
    self.body:setLinearVelocity(xVelocity, yVelocity)
end

function BusComponent:draw()
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    if self.nextSegment then
        self.nextSegment:draw()
    end
end

return BusComponent
