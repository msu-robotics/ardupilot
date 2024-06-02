-- Позволяет управлять двумя сервоприводами отвечающим за положение камер, вниз смотрящей и фронатльной.
-- Управление производится по 13 и 14 RC каналам


local PARAM_TABLE_KEY = 88
PARAM_TABLE_PREFIX = "MSUR_"
local MAV_SEVERITY = {EMERGENCY=0, ALERT=1, CRITICAL=2, ERROR=3, WARNING=4, NOTICE=5, INFO=6, DEBUG=7}

assert(param:add_table(PARAM_TABLE_KEY, PARAM_TABLE_PREFIX, 9), 'could not add param table')

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
  // @Param: MSUR_CAM_FT_RC
  // @DisplayName: Front camera rc channel
  // @Description: Number of rc channel for control
  // @Range: 8 16
  // @Units: ch
  // @User: Standard
--]]
local FRONT_CAMERA_RC = bind_add_param('CAM_FT_RC', 1, 14)

--[[
  // @Param: MSUR_CAM_BTM_RC
  // @DisplayName: Bottom camera rc channel
  // @Description: Number of rc channel for control
  // @Range: 8 16
  // @Units: ch
  // @User: Standard
--]]
local BOTTOM_CAMERA_RC = bind_add_param('CAM_BTM_RC', 2, 13)

-- Минимальное и максимальное значение PWM для камер
--[[
  // @Param: MSUR_CAM_PWM_MIN
  // @DisplayName: Minimal PWM value for cameras
  // @Description: Minimum angle of camera rotation
  // @Range: 1000 2000
  // @Units: int
  // @User: Standard
--]]
local PWM_MIN = bind_add_param('CAM_PWM_MIN', 3, 1000)

--[[
  // @Param: MSUR_CAM_PWM_MAX
  // @DisplayName: Maximal PWM value for cameras
  // @Description: Maximum angle of camera rotation
  // @Range: 1000 2000
  // @Units: int
  // @User: Standard
--]]
local PWM_MAX = bind_add_param('CAM_PWM_MAX', 4, 2000)

--[[
  // @Param: MSUR_CAM_FT_FCN
  // @DisplayName: Front camera rc channel
  // @Description: Servo function number for front camera (Script1 - Script16)
  // @Range: 94 109
  // @Units: int
  // @User: Standard
--]]
local FRONT_FCN = bind_add_param('CAM_FT_FCN', 5, 96)

--[[
  // @Param: MSUR_CAM_BTM_FCN
  // @DisplayName: Bottom camera function number
  // @Description: Servo function number for bottom camera
  // @Range: 94 109
  // @Units: int
  // @User: Standard
--]]
local BUTTOM_FCN = bind_add_param('CAM_BTM_FCN', 6, 97)

--[[
  // @Param: MSUR_CAM_ROT_SPD
  // @DisplayName: Cameras rotation speed
  // @Description: Rotation speed of cameras
  // @Range: 1 200
  // @Units: int
  // @User: Standard
--]]
local SPEED = bind_add_param('CAM_ROT_SPD', 7, 70)

--[[
  // @Param: MSUR_CAM_FT_INI
  // @DisplayName: Front camera initial position
  // @Description: Initial position of front camera
  // @Range: 1000 2000
  // @Units: ch
  // @User: Standard
--]]
local INIT_FRONT_POSITION = bind_add_param('CAM_FT_INI', 8, 1900)
--[[
  // @Param: MSUR_CAM_BTM_INI
  // @DisplayName: Bottom camera initial position
  // @Description: Initial position of bottom camera
  // @Range: 1000 2000
  // @Units: ch
  // @User: Standard
--]]
local INIT_BUTTOM_POSITION = bind_add_param('CAM_BTM_INI', 9, 1900)

local FRONT_POSITION = INIT_FRONT_POSITION:get()
local BUTTOM_POSITION = INIT_BUTTOM_POSITION:get()

local BTM_CAMERA_STATE = 'NONE'
local FRONT_CAMERA_STATE = 'NONE'

function update()

    BOTTOM_PWM = rc:get_pwm(BOTTOM_CAMERA_RC:get())
    FRONT_PWM = rc:get_pwm(FRONT_CAMERA_RC:get())

    if BOTTOM_PWM < 1500 then
        BUTTOM_POSITION = BUTTOM_POSITION - SPEED:get()
        -- Для отладки, нет надобности писать лог каждые 50мс, достаточно делать
        -- это при смене направления движения
        if BTM_CAMERA_STATE ~= 'DOWN' then
            BTM_CAMERA_STATE = 'DOWN'
            gcs:send_text(MAV_SEVERITY.INFO, "BTTM CAM MOVE DOWN")
        end
    elseif BOTTOM_PWM > 1500 then
        BUTTOM_POSITION = BUTTOM_POSITION + SPEED:get()
        if BTM_CAMERA_STATE ~= 'UP' then
            BTM_CAMERA_STATE = 'UP'
            gcs:send_text(MAV_SEVERITY.INFO, "BTTM CAM MOVE UP")
        end
    end

    if FRONT_PWM < 1500 then
        FRONT_POSITION = FRONT_POSITION - SPEED:get()
        if FRONT_CAMERA_STATE ~= 'DOWN' then
            FRONT_CAMERA_STATE = 'DOWN'
            gcs:send_text(MAV_SEVERITY.INFO, "FRONT CAM MOVE DOWN")
        end
    elseif FRONT_PWM > 1500 then
        FRONT_POSITION = FRONT_POSITION + SPEED:get()
        if FRONT_CAMERA_STATE ~= 'UP' then
            FRONT_CAMERA_STATE = 'UP'
            gcs:send_text(MAV_SEVERITY.INFO, "FRONT CAM MOVE UP")
        end
    end

    if BUTTOM_POSITION > PWM_MAX:get() then
        BUTTOM_POSITION = PWM_MAX:get()
    end

    if BUTTOM_POSITION < PWM_MIN:get() then
        BUTTOM_POSITION = PWM_MIN:get()
    end

    if FRONT_POSITION > PWM_MAX:get() then
        FRONT_POSITION = PWM_MAX:get()
    end

    if FRONT_POSITION < PWM_MIN:get() then
        FRONT_POSITION = PWM_MIN:get()
    end

    SRV_Channels:set_output_pwm(FRONT_FCN:get(), FRONT_POSITION)
    SRV_Channels:set_output_pwm(BUTTOM_FCN:get(), BUTTOM_POSITION)

    return update, 50
end

return update()