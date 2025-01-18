---@class Bullet: Class
local Bullet, super = Class()

Update = Utils.override(Update, function (orig)
    orig()
    for _, bullet in pairs(ALL_BULLETS) do
        if bullet.did_init ~= nil then
            bullet:update(1/60)
        end
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
    self.relative = false
    self.vel_x = 0
    self.vel_y = 0
    self.did_init = true
end

function Bullet:setPosition(x,y)
    self.x = x or 0; self.y = y or 0
    self:syncPosition()
end

---@param layer string?
function Bullet:spawn(layer)
    self:remove()
    table.insert(ALL_BULLETS, self)
    self.uobject = CreateProjectile(self.sprite, -100, -100, layer)
    self:syncPosition()
    self.uobject.setVar("BulletClass", self)
end

---@return boolean removed # Whether anything actually happened
function Bullet:remove()
    if not self.uobject then return false end
    self.uobject.Remove()
    self.uobject = nil
    Utils.removeFromTable(ALL_BULLETS, self)
    return true
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

function Bullet:update(dt)
    self.x = self.x + ((self.vel_x or 0) * dt)
    self.y = self.y + ((self.vel_y or 0) * dt)
    self:syncPosition()
end

function Bullet:onHit()
    -- TODO: Calculate value based on enemy attack
    Player.hurt(3)
end

return Bullet