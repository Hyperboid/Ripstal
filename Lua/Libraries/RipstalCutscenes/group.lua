---@type table<string, fun(cutscene: BattleCutscene)>
local group = {
    test = function (cutscene)
        cutscene:text("Cutscene group.")
    end,
    test2 = function (cutscene)
        cutscene:text("Cutscene twoup.")
    end
}
return group