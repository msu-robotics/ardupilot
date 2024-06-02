# MSUR Cameras control

Allows you to control the position of the cameras using PWM outputs

## Parameter Descriptions

- `MSUR_CAM_FT_RC` : Front camera rc channel
- `MSUR_CAM_BTM_RC` : Bottom camera rc channel
- `MSUR_CAM_PWM_MIN` : Minimal PWM value for cameras
- `MSUR_CAM_PWM_MAX`: Maximal PWM value for cameras
- `MSUR_CAM_FT_FCN` : Front camera rc channel
- `MSUR_CAM_BTM_FCN` : Bottom camera function number
- `MSUR_CAM_ROT_SPD` : Cameras rotation speed
- `MSUR_CAM_FT_INI` : Front camera initial position
- `MSUR_CAM_BTM_INI` : Bottom camera initial position

## How to use

Connect the servo drive to outputs AUX 1-6, then select the 
Script1 - Script16 function for the corresponding output in `SERVOx_FUNCTION`. 
Specify the function values corresponding to the script 
numbers according to the table 
https://ardupilot.org/copter/docs/parameters.html#servo1-function.
