require("Ripstal.main")

accumulator = 1
Update = Utils.override(Update, function (orig, ...)
    orig(...)
    accumulator = accumulator + (1/60)
    while accumulator > 1 do
        accumulator = accumulator - 1
        Registry.spawnBullet("chasingbullet", Arena.width/2, Arena.height/2)
    end
end)