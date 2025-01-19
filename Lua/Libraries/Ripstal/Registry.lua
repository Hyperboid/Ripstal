local Registry = {}
local self = Registry

Registry.data = {bullets = {}}

---@generic T:Bullet
---@param id Bullet.`T`
---@return T|fun(...):T
function Registry.getBullet(id)
    if self.data.bullets[id] then return self.data.bullets[id] end
    self.data.bullets[id] = require("RipstalReg.Bullets."..id)
    return self.data.bullets[id]
end

---@generic T:Bullet
---@param id Bullet.`T`
---@return T
function Registry.spawnBullet(id, ...)
    local bullet_class = Registry.getBullet(id)
    local bullet = bullet_class(...)
    bullet:spawn()
    return bullet
end

return Registry