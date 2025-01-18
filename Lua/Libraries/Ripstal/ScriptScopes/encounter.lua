function StartCutscene(id)
    RipstalActiveCutsene = BattleCutscene:new(id)
end

function Update()
    if RipstalActiveCutsene then
        RipstalActiveCutsene:update()
    end
end