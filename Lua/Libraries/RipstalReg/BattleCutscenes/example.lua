---@param cutscene BattleCutscene
return function(cutscene)
    cutscene:wait()
    cutscene:text("* Bepis")
    cutscene:text("* Bepis two")

    Player.hurt(4, .1)
    cutscene:text("Painful Bepis.")
    Player.heal(4)
    cutscene:text("Comforting Bepis.")
end