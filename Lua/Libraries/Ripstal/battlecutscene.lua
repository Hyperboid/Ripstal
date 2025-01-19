---@class BattleCutscene: Cutscene
local BattleCutscene, super = Class(Cutscene)
local in_text = false
function RipstalResumeCutscene()
    in_text = false
    if RipstalActiveCutsene then
        RipstalActiveCutsene:tryResume()
    end
end

BattleCutscene.PATH_PREFIX = "RipstalReg.BattleCutscenes."

function BattleCutscene:text(string, options)
    in_text = true
    BattleDialog({string, "[func:RipstalResumeCutscene][next]"})
    options = options or {}
    local wait = function ()
        return not in_text or GetCurrentState() ~= "DIALOGRESULT"
    end
    if options.wait == false then
        return wait
    else
        self:wait(wait)
    end
end

function BattleCutscene:battlerText(id, string, options)
    for index, value in ipairs(enemies) do
        value.setVar("currentdialogue", {})
    end
    in_text = true
    assert(enemies[id], "Attempt to assign text to a nonexistent enemy")
        .setVar("currentdialogue",({string, "[func:RipstalResumeCutscene][next]"}))
    options = options or {}
    local wait = function ()
        return not in_text or GetCurrentState() ~= "ENEMYDIALOGUE"
    end
    State("ENEMYDIALOGUE")
    if options.wait == false then
        return wait
    else
        self:wait(wait)
    end
end

function BattleCutscene:init(func)
    RipstalActiveCutsene = self
    super.init(self, func)
end

return BattleCutscene