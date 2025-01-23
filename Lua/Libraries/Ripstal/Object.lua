--- Base class for anything that physically exists.
---@class Object: Class
local Object, super = Class()

Update = Utils.override(Update, function (orig)
    orig()
    for _, object in pairs(ALL_OBJECTS) do
        object:update(1/60)
        object:syncPosition()
    end
end)

---@type Object[]
ALL_OBJECTS = {}

function Object:init(x,y)
    self.x = x or 0
    self.y = y or 0
    self:resetPhysics()
end

function Object:setPosition(x,y)
    self.x = x or 0; self.y = y or 0
    self:syncPosition()
end

function Object:remove()
    Utils.removeFromTable(ALL_OBJECTS, self)
    return true
end

--- *Override* 
function Object:update(dt)
    self:updatePhysicsTransform(dt)
end

function Object:resetPhysics()
    self.physics = {
        -- The speed this object moves (pixels per frame, at 30 fps)
        speed_x = 0,
        speed_y = 0,
        -- The speed this object moves, in the angle of its direction (pixels per frame, at 30 fps)
        speed = 0,
        direction = 0, -- right

        -- The amount this object should slow down (also per frame at 30 fps)
        friction = 0,
        -- The amount this object should accelerate in the gravity direction (also per frame at 30 fps)
        gravity = 0,
        gravity_direction = math.pi / 2, -- down

        -- The amount this object's direction rotates (per frame at 30 fps)
        spin = 0,

        -- Whether direction should be based on rotation instead
        match_rotation = false,

        -- Movement target for Object:slideTo
        move_target = nil,
        -- Movement target for Object:slidePath
        move_path = nil,
    }
end

---@class physics_table
---@field speed_x           number  The horizontal speed of the object, in pixels per frame at 30FPS.
---@field speed_y           number  The vertical speed of the object, in pixels per frame at 30FPS.
---@field speed             number  The speed the object will move in the angle of its direction, in pixels per frame at 30FPS.
---@field direction         number  The angle at which the object will move, in radians.
---@field friction          number  The amount the object's speed will slow down, per frame at 30FPS.
---@field gravity           number  The amount the object's speed will accelerate towards its gravity direction, per frame at 30FPS.
---@field gravity_direction number  The angle at which the object's gravity will accelerate towards, in radians.
---@field spin              number  The amount this object's direction will change, in radians per frame at 30FPS.
---@field match_rotation    boolean Whether the object's rotation should also define its direction. (Defaults to false)
---@field move_target?      table   A table containing data defined by `Object:slideTo()` or `Object:slideToSpeed()`.
---@field move_path?        table   A table containing data defined by `Object:slidePath()`.

---@param physics physics_table A table of values to set for the object's physics.
function Object:setPhysics(physics)
    self:resetPhysics()
    for k, v in pairs(physics) do
        self.physics[k] = v
    end
end

function Object:updatePhysicsTransform(dt)
    local dtmult = dt * 30
    local physics = self.physics

    if not physics then return end

    local direction = (physics.match_rotation and self.rotation or physics.direction) or physics.gravity_direction or 0

    if physics.gravity and physics.gravity ~= 0 then
        if physics.speed and physics.speed ~= 0 then
            local speed_x, speed_y = math.cos(direction) * physics.speed, math.sin(direction) * physics.speed
            local new_speed_x = speed_x + math.cos(physics.gravity_direction) * (physics.gravity * dtmult)
            local new_speed_y = speed_y + math.sin(physics.gravity_direction) * (physics.gravity * dtmult)
            if physics.match_rotation then
                self.rotation = math.atan2(new_speed_y, new_speed_x)
            else
                physics.direction = math.atan2(new_speed_y, new_speed_x)
            end
            physics.speed = math.sqrt(new_speed_x * new_speed_x + new_speed_y * new_speed_y)
        else
            physics.speed_x = physics.speed_x or 0
            physics.speed_y = physics.speed_y or 0
            physics.speed_x = physics.speed_x + math.cos(physics.gravity_direction) * (physics.gravity * dtmult)
            physics.speed_y = physics.speed_y + math.sin(physics.gravity_direction) * (physics.gravity * dtmult)
        end
    end

    if physics.spin and physics.spin ~= 0 then
        if physics.match_rotation then
            self.rotation = self.rotation + physics.spin * dtmult
        else
            physics.direction = physics.direction + physics.spin * dtmult
        end
    end

    if physics.speed and physics.speed ~= 0 then
        physics.speed = Utils.approach(physics.speed, 0, (physics.friction or 0) * dtmult)
        self:move(math.cos(direction), math.sin(direction), physics.speed * dtmult)
    end

    if (physics.speed_x and physics.speed_x ~= 0) or (physics.speed_y and physics.speed_y ~= 0) then
        physics.speed_x = Utils.approach(physics.speed_x or 0, 0, (physics.friction or 0) * dtmult)
        physics.speed_y = Utils.approach(physics.speed_y or 0, 0, (physics.friction or 0) * dtmult)
        self:move(physics.speed_x, physics.speed_y, dtmult)
    end

    if physics.move_target then
        local next_x, next_y = self.x, self.y
        if physics.move_target.speed then
            local angle = Utils.angle(self.x, self.y, physics.move_target.x, physics.move_target.y)
            next_x = Utils.approach(self.x, physics.move_target.x,
                physics.move_target.speed * math.abs(math.cos(angle)) * dtmult)
            next_y = Utils.approach(self.y, physics.move_target.y,
                physics.move_target.speed * math.abs(math.sin(angle)) * dtmult)
        elseif physics.move_target.time then
            physics.move_target.timer = Utils.approach(physics.move_target.timer, physics.move_target.time, dt)

            next_x = Utils.ease(physics.move_target.start_x, physics.move_target.x,
                (physics.move_target.timer / physics.move_target.time), physics.move_target.ease)
            next_y = Utils.ease(physics.move_target.start_y, physics.move_target.y,
                (physics.move_target.timer / physics.move_target.time), physics.move_target.ease)
        end
        if physics.move_target.move_func then
            physics.move_target.move_func(self, next_x - self.x, next_y - self.y)
        else
            self:setPosition(next_x, next_y)
        end
        if next_x == physics.move_target.x and next_y == physics.move_target.y then
            local after = physics.move_target.after
            physics.move_target = nil
            if after then after() end
        end
    elseif physics.move_path then
        if physics.move_path.speed then
            physics.move_path.progress = physics.move_path.progress + (physics.move_path.speed * dtmult)
        elseif physics.move_path.time then
            physics.move_path.timer = physics.move_path.timer + dt
            physics.move_path.progress = (physics.move_path.timer / physics.move_path.time) * physics.move_path.length
        end
        if not physics.move_path.loop then
            physics.move_path.progress = Utils.clamp(physics.move_path.progress, 0, physics.move_path.length)
        else
            physics.move_path.progress = physics.move_path.progress % physics.move_path.length
        end
        local eased_progress = Utils.ease(0, physics.move_path.length,
            (physics.move_path.progress / physics.move_path.length), physics.move_path
            .ease)
        local target_x, target_y = Utils.getPointOnPath(physics.move_path.path, eased_progress)
        if physics.move_path.move_func then
            physics.move_path.move_func(self, target_x - self.x, target_y - self.y)
        else
            self:setPosition(target_x, target_y)
        end
        if not physics.move_path.loop and physics.move_path.progress >= physics.move_path.length then
            local after = physics.move_path.after
            physics.move_path = nil
            if after then after() end
        end
    end
end

function Object:move(x, y, speed)
    self.x = self.x + (x or 0) * (speed or 1)
    self.y = self.y + (y or 0) * (speed or 1)
end

function Object:syncPosition() end

return Object