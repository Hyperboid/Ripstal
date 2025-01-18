---@class Class
local PrimitaveClass = {
    is_class = true,
    init = function(self) end,
    __call = function (self, ...)
        local instance = setmetatable({}, {__index = self})
        instance:init(...)
        return instance
    end
}

setmetatable(PrimitaveClass, PrimitaveClass)

PrimitaveClass.new = PrimitaveClass.__call

---@generic T : Class|function
---
---@param include? T         # The class to extend from.
---@param id? string|boolean # The id of the class. In this hellish world, 
---
---@return T|Class class     # The new class, extended from `include` if provided.
---@return T? super  # Allows calling methods from the base class. `self` must be passed as the first argument to each method.
return function (include, id)
    local class = {
        __super = include or PrimitaveClass,
        __index = include or PrimitaveClass,
        __call = PrimitaveClass.__call
    }

    setmetatable(class, class)
    
    return class, include or PrimitaveClass
end