if Encounter == nil then
    require("Ripstal.ScriptScopes.encounter")
elseif CreateProjectile ~= nil then
    -- TODO: Wave ScriptScope
    require("Ripstal.ScriptScopes.enemy")
else
    require("Ripstal.ScriptScopes.enemy")
end
