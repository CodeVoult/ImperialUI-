local Spring = {}
Spring.__index = Spring

function Spring.new(mass, damping, constant, initialPos)
    assert(type(mass) == "number" and mass > 0, "Spring mass must be positive")
    assert(type(damping) == "number" and damping >= 0, "Spring damping cannot be negative")
    assert(type(constant) == "number" and constant > 0, "Spring stiffness must be positive")
    assert(type(initialPos) == "number", "Spring initial position must be a number")
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
    dt = math.clamp(tonumber(dt) or 0, 0, 0.1)
    if dt == 0 then return self.x end

    -- Exact damped-oscillator integration stays stable at low frame rates.
    local displacement = self.x - self.target
    local dampingRatio = self.d / (2 * math.sqrt(self.m * self.k))
    local angular = math.sqrt(self.k / self.m)
    local decay = dampingRatio * angular
    local nextDisplacement, nextVelocity

    if dampingRatio < 0.999 then
        local frequency = angular * math.sqrt(1 - dampingRatio * dampingRatio)
        local phase = frequency * dt
        local envelope = math.exp(-decay * dt)
        local cosine, sine = math.cos(phase), math.sin(phase)
        nextDisplacement = envelope * (displacement * cosine + (self.v + decay * displacement) * sine / frequency)
        nextVelocity = envelope * (self.v * cosine - (decay * self.v + angular * angular * displacement) * sine / frequency)
    elseif dampingRatio > 1.001 then
        local root = math.sqrt(dampingRatio * dampingRatio - 1)
        local slow = -angular * (dampingRatio - root)
        local fast = -angular * (dampingRatio + root)
        local coefficientSlow = (self.v - fast * displacement) / (slow - fast)
        local coefficientFast = displacement - coefficientSlow
        local slowPart = coefficientSlow * math.exp(slow * dt)
        local fastPart = coefficientFast * math.exp(fast * dt)
        nextDisplacement = slowPart + fastPart
        nextVelocity = slow * slowPart + fast * fastPart
    else
        local coefficient = self.v + angular * displacement
        local envelope = math.exp(-angular * dt)
        nextDisplacement = (displacement + coefficient * dt) * envelope
        nextVelocity = (self.v - angular * coefficient * dt) * envelope
    end

    self.x = self.target + nextDisplacement
    self.v = nextVelocity
    return self.x
end

return Spring
