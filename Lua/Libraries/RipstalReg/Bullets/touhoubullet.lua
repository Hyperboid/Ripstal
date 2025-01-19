-- Kristal adaptaptation from Dark Place: Legacy, made by BrendaK7200, Dobby223Liu, and JARU (not the piles one).
-- https://github.com/darkplace-dr/Dark-Place/blame/main/scripts/battle/bullets/poseur/touhoubullet.lua

---@class Bullet.touhoubullet : Bullet
local TouhouBullet, super = Class(Bullet)

function TouhouBullet:init(x, y, y_offset)
    -- Last argument = sprite path
    super.init(self, x, y, "bullet")
    -- self:setScale(1, 1)

    self.destroy_on_hit = false
    self.remove_offscreen = true

    self.y_offset = y_offset or 100
    self.timer = 0
    self.offset = 0
	self.lerp = 0
    self.negmult = 0
end

function TouhouBullet:update(dt)
    local dtmult60 = dt * 60

    local posx = (70 * self.lerp) * math.sin(self.timer * self.negmult + self.offset)
    local posy = (70 * self.lerp) * math.cos(self.timer + self.offset) + self.y_offset - self.lerp * 50
    self:setPosition(posx, posy + self.y_offset)
    self.timer = self.timer + 1/40 * dtmult60
    self.lerp = Utils.approach(self.lerp, 4, 1/90 * dtmult60)

    super.update(self, dt)
end

return TouhouBullet
