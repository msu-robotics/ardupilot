
local PARAM_TABLE_KEY = 87
PARAM_TABLE_PREFIX = "MSUR_"
local MAV_SEVERITY = {EMERGENCY=0, ALERT=1, CRITICAL=2, ERROR=3, WARNING=4, NOTICE=5, INFO=6, DEBUG=7}

-- bind a parameter to a variable
function bind_param(name)
  local p = Parameter()
  assert(p:init(name), string.format('could not find %s parameter', name))
  return p
end

-- add a parameter and bind it to a variable
local function bind_add_param(name, idx, default_value)
  assert(param:add_param(PARAM_TABLE_KEY, idx, name, default_value), string.format('could not add param %s', name))
  return bind_param(PARAM_TABLE_PREFIX .. name)
end

--[[
  // @Param: MSUR_GRIP_CTH_RC
  // @DisplayName: Gripper catch RC channel
  // @Description: RC channel bumber for the gripper axis
  // @Range: 8-16
  // @User: Standard
--]]
local GRIPPER_CATCH_RC = bind_add_param('GRIP_CTH_RC', 1, 15)

--[[
  // @Param: MSUR_GRIP_ROT_RC
  // @DisplayName: Gripper rotation RC channel
  // @Description: RC channel number for rotation axis
  // @Range: 8-16
  // @User: Standard
--]]
local GRIPPER_ROTATE_RC = bind_add_param('GRIP_ROT_RC', 2, 16)

--[[
  // @Param: MSUR_GRIP_A1_REL
  // @DisplayName: Gripper A1 relay number
  // @Description: Relay number for A1 L298N Driver channel
  // @Range: 0-32
  // @User: Standard
--]]
local A1_GRIP_RELAY = bind_add_param('GRIP_A1_REL', 3, 0)

--[[
  // @Param: MSUR_GRIP_A2_REL
  // @DisplayName: Gripper A2 relay number
  // @Description: Relay number for A2 L298N Driver channel
  // @Range: 0-32
  // @User: Standard
--]]
local A2_GRIP_RELAY = bind_add_param('GRIP_A2_REL', 4, 1)

--[[
  // @Param: MSUR_GRIP_B1_REL
  // @DisplayName: Gripper B1 relay number
  // @Description: Relay number for B1 L298N Driver channel
  // @Range: 0-32
  // @User: Standard
--]]
local B1_GRIP_RELAY = bind_add_param('GRIP_B1_REL', 5, 2)

--[[
  // @Param: MSUR_GRIP_B2_REL
  // @DisplayName: Gripper B2 relay number
  // @Description: Relay number for B2 L298N Driver channel
  // @Range: 0-32
  // @User: Standard
--]]
local B2_GRIP_RELAY = bind_add_param('GRIP_B2_REL', 6, 3)

local ROTATE_STATE = 'NONE'
local GRIP_STATE = 'NONE'

function update()

    local catch_pwm = rc:get_pwm(GRIPPER_CATCH_RC:get())
    local rotate_pwm = rc:get_pwm(GRIPPER_ROTATE_RC:get())

    if arming:is_armed() and catch_pwm > 0 and rotate_pwm > 0 then

        if catch_pwm > 1500 then
            relay:off(A1_GRIP_RELAY:get())
            relay:on(A2_GRIP_RELAY:get())
            if GRIP_STATE ~= "CATCH" then
            	GRIP_STATE = "CATCH"
            	gcs:send_text(MAV_SEVERITY.INFO, "GRIPPER CATCH")
            end
        elseif catch_pwm < 1500 then
            relay:off(A2_GRIP_RELAY:get())
            relay:on(A1_GRIP_RELAY:get())
            if GRIP_STATE ~= "RELISE" then
                GRIP_STATE = "RELISE"
                gcs:send_text(MAV_SEVERITY.INFO, "GRIPPER RELISE")
            end
        else
            relay:off(A1_GRIP_RELAY:get())
            relay:off(A2_GRIP_RELAY:get())
        end

        if rotate_pwm > 1500 then
            relay:off(B1_GRIP_RELAY:get())
            relay:on(B2_GRIP_RELAY:get())
            if ROTATE_STATE ~= "CLOCK" then
                ROTATE_STATE = "CLOCK"
                gcs:send_text(MAV_SEVERITY.INFO, "GRIPPER ROTATE CLOCK")
            end
        elseif rotate_pwm < 1500 then
            relay:off(B2_GRIP_RELAY:get())
            relay:on(B1_GRIP_RELAY:get())
            if ROTATE_STATE ~= "ANTI CLOCK" then
                ROTATE_STATE = "ANTI CLOCK"
                gcs:send_text(MAV_SEVERITY.INFO, "GRIPPER ROTATE ANTI CLOCK")
            end
        else
            relay:off(B1_GRIP_RELAY:get())
            relay:off(B2_GRIP_RELAY:get())
        end

    end

    return update, 50
end

return update()