---@class Timer: Class
---
---@overload fun(): Timer
---@diagnostic disable-next-line: assign-type-mismatch
local Timer, super = Class()

---@type Timer[]
ALL_TIMERS = {}

Update = Utils.override(Update, function (orig)
    RUNTIME = (RUNTIME or 0) + (1/60)
    for _, timer in pairs(ALL_TIMERS) do
        timer:update(1/60)
    end
    orig()
end)

function Timer:init()
    table.insert(ALL_TIMERS, self)

    ---@type table<function, number>
    self.handles = {}
end

--- BUG: might cause a stack overflow? Not sure.
--- TODO: Rewrite please oh for all that is good in this world
function Timer:every(seconds, callback, count)
    assert(seconds > 1/30, "Every too small, expected > "..(1/30)..", got "..seconds..".")
    count = count or math.huge
    local next
    function next(result, remaining)
        if result == false or remaining <= 0 then return end
        self:after(seconds, function ()
            next(callback(), remaining - 1)
        end)
    end
    next(true, count)
end

function Timer:everyInstant(seconds, callback, count)
    count = count or math.huge
    callback()
    self:every(seconds, callback, count - 1)
end

function Timer:after(seconds, callback)
    self.handles[function ()
        callback()
    end] = seconds
end

function Timer:remove()
    Utils.removeFromTable(ALL_TIMERS, self)
end

function Timer:update(dt)
    for func in pairs(self.handles) do
        self.handles[func] = self.handles[func] - dt
        if self.handles[func] <= 0 then
            func()
            self.handles[func] = nil
        end
    end
end

return Timer