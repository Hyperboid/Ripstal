---@type table<string, fun(cutscene: BattleCutscene)>
local poseur = {
    intro =  function(cutscene)
        cutscene:wait()
        cutscene:text("Poseur strikes a pose!")
        
        if not GetRealGlobal("ripstal_example_dodge") then
            SetRealGlobal("ripstal_example_dodge", true)
            Player.hurt(5)
            cutscene:text("And gets a first hit on you!\n[w:5]Ouch!")
            cutscene:battlerText(1, "Mwahaha!")
        else
            cutscene:text("And tries to get a first hit\ron you!")
            cutscene:text("Thankfully, having already played\rthe mod, you saw this coming.")
            cutscene:battlerText(1, "Bros got hacks >:(")
            cutscene:text("Unfortunately for Poseur, you're\rThe Anomaly.")
        end
    
        State("ACTIONSELECT")
        cutscene:endCutscene()
    end,
    example = function(cutscene)
        cutscene:wait()
        cutscene:text("* Bepis")
        cutscene:text("* Bepis two")

        Player.hurt(4, .1)
        cutscene:text("Painful Bepis.")
        Player.heal(6)
        cutscene:text("Comforting Bepis.")
    end,
    taunt = function (cutscene)
        cutscene:text("You make a rude gesture towards\rPoseur.")
        Audio.PlaySound("boost")
        enemies[1]["atk"] = enemies[1]["atk"] + 2
        cutscene:text("Poseur's ATK increased to "..enemies[1]["atk"].."!")
        cutscene:battlerText(1, "Do you wanna take that back?")
        cutscene:text("Since choicers aren't implemented,\rpress C+Z to take it back.")
        if Input.menu > 0 then
            enemies[1]["atk"] = enemies[1]["atk"] - 1
            Audio.PlaySound("unboost")
            cutscene:text("Poseur's ATK decreased to "..enemies[1]["atk"]..".")
            cutscene:battlerText(1, "Yeah, that's right, punk.")
        else
            Audio.PlaySound("boost")
            enemies[1]["atk"] = enemies[1]["atk"] + 2
            cutscene:text("Poseur's ATK increased to "..enemies[1]["atk"].."!")
            cutscene:battlerText(1, "Course not.")
        end
    end
}

return poseur