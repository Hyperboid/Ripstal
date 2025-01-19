---@class Cutscene: Class
local Cutscene, super = Class()

Cutscene.PATH_PREFIX = "RipstalReg.Cutscenes"

function Cutscene:init(func, ...)
    assert(Encounter == nil, "Attempt to run a cutscene from outside the Encounter script. Use a call()!")
    self.coroutine = coroutine.create(Utils.xpwrap(self:getter(func)))
    self.wait_timer = 0
    self:resume(self, ...)
end

function Cutscene:update()
    if coroutine.status(self.coroutine) == "suspended" then
        self:tryResume()
    elseif coroutine.status(self.coroutine) == "dead" and self:canEnd() then
        self:endCutscene()
    end
end

function Cutscene:getter(id)
    local func = id
    if type(id) == "string" then
        local split = Utils.split(id, ".")
        func = require(self.PATH_PREFIX..split[1])
        if type(func) == "table" and split[2] then
            func = func[split[2]]
        end
    end
    return func
end

function Cutscene:endCutscene()
    RipstalActiveCutsene = nil
end

function Cutscene:canEnd()
    return true
end

function Cutscene:tryResume()
    local result, a,b,c,d,e,f = self:canResume()
    if result then
        self:resume(a,b,c,d,e,f)
        return true
    end
    return false
end

function Cutscene:canResume()
    if self.wait_timer > 0 or self.paused then
        return false
    end
    if self.wait_func then
        return self.wait_func(self)
    end
    return true
end

function Cutscene:resume(...)
    self.paused = false
    self.wait_func = nil
    local ok, msg = coroutine.resume(self.coroutine, ...)
    if not ok then
        error(msg)
    end
end

function Cutscene:wait(seconds)
    if type(seconds) == "function" then
        self.wait_func = seconds
    else
        self.wait_timer = seconds or 0
    end
    coroutine.yield()
end

return Cutscene