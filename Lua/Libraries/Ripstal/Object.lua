--- Base class for anything that physically exists.
---@class Object: Class
local Object, super = Class()

Update = Utils.override(Update, function (orig)
    orig()
    for _, object in pairs(ALL_OBJECTS) do
        object:update(1/60)
        object:syncPosition()
    end
end)

---@type Object[]
ALL_OBJECTS = {}

function Object:init(x,y)
    self.x = x or 0
    self.y = y or 0
    self.vel_x = 0
    self.vel_y = 0
end

function Object:setPosition(x,y)
    self.x = x or 0; self.y = y or 0
    self:syncPosition()
end

function Object:remove()
    Utils.removeFromTable(ALL_OBJECTS, self)
    return true
end

--- *Override* 
function Object:update(dt)
    self:updatePhysicsTransform(dt)
end

function Object:updatePhysicsTransform(dt)
    self.x = self.x + ((self.vel_x or 0) * dt)
    self.y = self.y + ((self.vel_y or 0) * dt)
end

function Object:syncPosition() end

return Object