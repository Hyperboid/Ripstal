---@class Bullet.bouncybullet : Bullet
local bouncybullet, super = Class(Bullet)

function bouncybullet:init(x,y,sprite)
    super.init(self,x,y,sprite)
    self.relative = true
end

-- TODO: Make physics_table and rewrite this
function bouncybullet:update(dt)
    local newposx = self.x + self.vel_x
    local newposy = self.y + self.vel_y
    if(self.x > -Arena.width/2 and self.x < Arena.width/2) then
        if(self.y < -Arena.height/2 + 8) then
            newposy = -Arena.height/2 + 8
            self.vel_y = 4
        end
    end
    self.vel_y = self.vel_y - (0.04*dt*60)
    self:setPosition(newposx, newposy)
    super.update(self,dt)
end
return bouncybullet