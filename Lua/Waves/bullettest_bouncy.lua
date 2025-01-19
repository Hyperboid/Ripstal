require("Ripstal.main")

-- The bouncing bullets attack from the documentation example.
spawntimer = 0

Update = Utils.override(Update, function(orig)
    orig()
    spawntimer = spawntimer + 1
    if spawntimer%30 == 0 then
        local posx = 30 - math.random(60)
        local posy = Arena.height/2
        -- local bullet = CreateProjectile('bullet', posx, posy)
        -- bullet.SetVar('velx', 1 - 2*math.random())
        -- bullet.SetVar('vely', 0)
        -- table.insert(bullets, bullet)
        local bullet = Registry.getBullet("bouncybullet")(0, posy)
        bullet.vel_x = 1 - 2*math.random()
        bullet:spawn()
    end
end)