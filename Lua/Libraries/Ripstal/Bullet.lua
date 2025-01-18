---@class Bullet: Class
local Bullet, super = Class()

Update = Utils.override(Update, function (orig)
    orig()
    for _, bullet in pairs(ALL_BULLETS) do
        bullet:update(1/60)
    end
end)

---@type Bullet[]
ALL_BULLETS = {}
function OnHit(bullet)
    if bullet.getVar("BulletClass") then
        bullet.getVar("BulletClass"):onHit()
    else
        Player.hurt(3)
    end
end

function Bullet:init(x,y, sprite)
    self.sprite = sprite or "bullet"
    self:setPosition(x,y)
end

function Bullet:setPosition(x,y)
    self.x = x or 0; self.y = y or 0
    self:update(0)
end

---@param layer string?
function Bullet:spawn(layer)
    self:remove()
    table.insert(ALL_BULLETS, self)
    self.uobject = CreateProjectile(self.sprite, -100, -100, layer)
    self:update(0)
end

---@return boolean removed # Whether anything actually happened
function Bullet:remove()
    if not self.uobject then return false end
    self.uobject.Remove()
    self.uobject = nil
    return true
end

function Bullet:update(dt)
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
    -- TODO: Calculate value based on enemy attack
    Player.hurt(3)
end

return Bullet