function StartCutscene(id)
    RipstalActiveCutsene = BattleCutscene(id)
end

function Update()
    if RipstalActiveCutsene then
        RipstalActiveCutsene:update()
    end
end

-- TODO: Do this in Bullet:onHit?
function RipstalInternalHurtPlayerFrom(id)
    local dmg = enemies[id]["atk"]
    Player.hurt(dmg or 1)
end