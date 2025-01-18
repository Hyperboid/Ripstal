require("Ripstal.main")

-- The chasing attack from the documentation example.
---@type Bullet
chasingbullet = Bullet:new(Arena.width/2, Arena.height/2)
chasingbullet.relative = true
chasingbullet.onHit = function (self)
    self:remove()
    Player.hurt(14)
end

function chasingbullet:update(dt)
    Bullet.update(self, dt)
    local xdifference = Player.x - self.x
    local ydifference = Player.y - self.y
    -- todo: restore accuracy
    self.vel_x = self.vel_x / 2 + xdifference * (60*dt*1)
    self.vel_y = self.vel_y / 2 + ydifference * (60*dt*1)
end

chasingbullet:spawn()
