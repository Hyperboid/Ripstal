function StartCutscene(id)
    RipstalActiveCutsene = BattleCutscene(id)
end

function Update()
    if RipstalActiveCutsene then
        RipstalActiveCutsene:update()
    end
end