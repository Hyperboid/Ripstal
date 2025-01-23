---@class Bullet.bouncybullet : Bullet
local bouncybullet, super = Class(Bullet)

function bouncybullet:init(x,y,sprite)
    super.init(self,x,y,sprite)
    self.relative = true
end

-- TODO: Make physics_table and rewrite this
function bouncybullet:update(dt)
    local newposy = self.y + self.physics.speed_y
    if(self.x > -Arena.width/2 and self.x < Arena.width/2) then
        if(self.y < -Arena.height/2 + 8) then
            newposy = -Arena.height/2 + 8
            self.physics.speed_y = 4
        end
    end
    self.physics.speed_y = self.physics.speed_y - (0.04*dt*60)
    super.update(self,dt)
    self:setPosition(self.x, newposy)
end

return bouncybullet