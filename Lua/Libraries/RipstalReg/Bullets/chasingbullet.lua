---@class Bullet.chasingbullet : Bullet
local chasingbullet, super = Class(Bullet)

function chasingbullet:init(x,y)
    super.init(self,x,y, "bullet")
    self.relative = true
    self.damage = 4
end

function chasingbullet:update(dt)
    super.update(self, dt)
    local xdifference = Player.x - self.x
    local ydifference = Player.y - self.y
    -- todo: restore accuracy
    self.vel_x = self.vel_x / 2 + xdifference * (60*dt*.75)
    self.vel_y = self.vel_y / 2 + ydifference * (60*dt*.75)
end

return chasingbullet