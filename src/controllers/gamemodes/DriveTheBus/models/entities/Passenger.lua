local Passenger = {}

Passenger.__index = Passenger

function Passenger:new(world, x, y, sprite)
    local this = {
        body = love.physics.newBody(world, x or 0, y or 0, "static"),
        shape = love.physics.newCircleShape(10),
        sprite = sprite,
        fixture = nil
    }
    
    --aplying physics
    this.fixture = love.physics.newFixture(this.body, this.shape, 1)
    this.fixture:setUserData("Passenger")
    this.fixture:setCategory(3)
    this.fixture:setMask(2)

    return setmetatable(this, Passenger)
end

function Passenger:destroy()
    self.fixture:destroy()
    self.body:destroy()
end

function Passenger:getFixture()
    return self.fixture
end

function Passenger:update(dt)

end

function Passenger:draw()
    --love.graphics.circle("line", self.body:getX(), self.body:getY(), 10)
    love.graphics.draw(self.sprite, self.body:getX(), self.body:getY(), 0, 1 , 1, 10, 10)
end

return Passenger
