local Spring = {}
Spring.__index = Spring

function Spring.new(mass, damping, constant, initialPos)
    local self = setmetatable({}, Spring)
    self.m = mass          
    self.d = damping      
    self.k = constant      
    self.x = initialPos    
    self.v = 0             
    self.target = initialPos
    return self
end

function Spring:Update(dt)
    local f = -self.k * (self.x - self.target) - self.d * self.v
    local a = f / self.m
    self.v = self.v + a * dt
    self.x = self.x + self.v * dt
    return self.x
end

return Spring
