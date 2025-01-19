require("Ripstal.main")
-- The bouncing bullets attack from the documentation example.

spawntimer = Timer()

spawntimer:every(.5, function ()
    local posx = 30 - math.random(60)
    local posy = Arena.height/2
    local bullet = Registry.getBullet("bouncybullet")(posx, posy)
    bullet.vel_x = 1 - 2*math.random()
    bullet:spawn()
end)