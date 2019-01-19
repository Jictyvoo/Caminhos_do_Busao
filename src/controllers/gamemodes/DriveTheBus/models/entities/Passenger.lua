local Passenger = {}

Passenger.__index = Passenger

function Passenger:new(world, x, y)
    local this = {
        body = love.physics.newBody(world, x or 0, y or 0, "static"),
        shape = love.physics.newCircleShape(10),
        fixture = nil
    }
    
    --aplying physics
    this.fixture = love.physics.newFixture(this.body, this.shape, 1)
    this.fixture:setUserData("Passenger")
    this.fixture:setCategory(2)
    this.fixture:setMask(2)

    return setmetatable(this, Passenger)
end

function Passenger:update(dt)

end

function Passenger:draw()
    love.graphics.circle("fill", self.body:getX(), self.body:getY(), 10)
end

return Passenger
