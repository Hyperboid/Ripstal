---@class BattleCutscene: Cutscene
local BattleCutscene, super = Class(Cutscene)
local in_text = false
function RipstalResumeCutscene()
    in_text = false
    RipstalActiveCutsene:tryResume()
end

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

function BattleCutscene:init(func)
    RipstalActiveCutsene = self
    if type(func) == "string" then
        func = require('RipstalCutscenes.'..func)
    end
    super.init(self, func)
end

return BattleCutscene