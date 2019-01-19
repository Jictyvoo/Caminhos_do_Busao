local BusComponent = {}

BusComponent.__index = BusComponent

function BusComponent:new(world, x, y)
    local this = {
        body = love.physics.newBody(world, x or 0, y or 0, "static"),
        shape = love.physics.newRectangleShape(50, 20),
        fixture = nil
    }
    
    --aplying physics
    this.fixture = love.physics.newFixture(this.body, this.shape, 1)
    this.fixture:setUserData("BusComponent")
    this.fixture:setCategory(2)
    this.fixture:setMask(2)

    return setmetatable(this, BusComponent)
end

function BusComponent:update(dt)
    self:body(update)
end

function BusComponent:draw()
    love.graphics.rectangle("fill", self.body:getX(), self.body:getY(), 50, 20)
end

return BusComponent
