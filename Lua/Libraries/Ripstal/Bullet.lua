---@class Bullet: Object
local Bullet, super = Class(Object)

function OnHit(bullet)
    if bullet.getVar("BulletClass") then
        bullet.getVar("BulletClass"):onHit()
    else
        Player.hurt(3)
    end
end

function Bullet:init(x,y, sprite)
    super.init(self,x,y)
    self.sprite = sprite or "bullet"
    self.relative = false
    self.remove_on_hit = "always"
    self.damage = nil
end

---@param layer string?
function Bullet:spawn(layer)
    self:remove()
    table.insert(ALL_OBJECTS, self)
    self.uobject = CreateProjectile(self.sprite, -100, -100, layer)
    self:syncPosition()
    self.uobject.setVar("BulletClass", self)
end

---@return boolean removed # Whether anything actually happened
function Bullet:remove()
    if not self.uobject then return false end
    self.uobject.Remove()
    self.uobject = nil
    return super.remove(self)
end

function Bullet:syncPosition()
    if self.uobject then
        if self.relative then
            self.uobject.x = self.x
            self.uobject.y = self.y
        else
            self.uobject.absx = self.x
            self.uobject.absy = self.y
        end
    end
end

function Bullet:onHit()
    if (not Player.ishurting or (self.remove_on_hit == "always")) and self.remove_on_hit then
        self:remove()
    end
    -- TODO: Calculate value based on enemy attack
    if self.damage then
        Player.hurt(self.damage)
    elseif Encounter then
        Encounter.call("RipstalInternalHurtPlayerFrom", 1)
    else
        RipstalInternalHurtPlayerFrom(1)
    end
end

function Bullet:getPPCollision()
    if not self.uobject.ppchanged then return nil end
    return self.uobject.ppcollision
end

---@param value boolean?
function Bullet:setPPCollision(value)
    if value == nil then
        self.uobject.ResetCollisionSystem()
    else
        self.uobject.ppcollision = value
    end
end

return Bullet