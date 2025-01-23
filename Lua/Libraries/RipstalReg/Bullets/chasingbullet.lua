---@class Bullet.chasingbullet : Bullet
local chasingbullet, super = Class(Bullet)

function chasingbullet:init(x,y)
    super.init(self,x,y, "bullet")
    self.relative = true
end

function chasingbullet:update(dt)
    super.update(self, dt)
    local xdifference = Player.x - self.x
    local ydifference = Player.y - self.y
    -- todo: restore accuracy
    self.physics.speed_x = ((self.physics.speed_x * 15) + xdifference) * (.75/30)
    self.physics.speed_y = ((self.physics.speed_y * 15) + ydifference) * (.75/30)
end

return chasingbullet