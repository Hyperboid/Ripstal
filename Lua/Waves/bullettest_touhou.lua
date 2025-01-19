require("Ripstal.main")

-- You've seen this one in the trailer (if you've seen the trailer).
spawntimer = 0
bullets = {}
yOffset = 180
mult = 0.5

Update = Utils.override(Update, function(orig)
    orig()
    if(spawntimer % 30 == 0) then
        local numbullets = 10
        for i=1,numbullets+1 do
            local bullet = Registry.getBullet("touhoubullet")(0, yOffset, 180 - 80)
            bullet.relative = true
            bullet.offset = math.pi * 2 * i / numbullets
            bullet.negmult = mult
            bullet.relative = true
            bullet:spawn()
        end
        mult = mult + 0.05
    end
    spawntimer = spawntimer + 1
end)