local World ={}

World.__index = World

local function beginContact(a, b, col)
end

local function endContact(a, b, col)
end

function World:new()
    love.physics.setMeter(32)
    local world = love.physics.newWorld(0, 0)

    world:setCallbacks(beginContact, endContact)

    return setmetatable({
        world = world
    }, World)
end

function World:update(dt)
    self.world:update(dt)
end

return World
