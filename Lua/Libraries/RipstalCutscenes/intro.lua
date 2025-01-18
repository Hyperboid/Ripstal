---@param cutscene BattleCutscene
return function(cutscene)
    cutscene:wait()
    cutscene:text("Poseur strikes a pose!")
    
    if not GetRealGlobal("ripstal_example_dodge") then
        SetRealGlobal("ripstal_example_dodge", true)
        Player.hurt(5)
        cutscene:text("And gets a first hit on you!\n[w:5]Ouch!")
    else
        cutscene:text("And tries to get a first hit\ron you!")
        cutscene:text("Thankfully, having already played\rthe mod, you saw this coming.")
    end

    State("ACTIONSELECT")
    cutscene:endCutscene()
end