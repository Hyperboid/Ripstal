require("Ripstal.main")
-- The bouncing bullets attack from the documentation example.

spawntimer = Timer()

spawntimer:everyInstant(1.5, function ()
    local posx = 30 - math.random(60)
    local posy = Arena.height/2
    spawntimer:every(.05, function ()
        local bullet = Registry.getBullet("bouncybullet")(posx, posy)
        bullet.vel_x = 1 - 2*math.random()
        bullet:spawn()
    end, 10)
end)