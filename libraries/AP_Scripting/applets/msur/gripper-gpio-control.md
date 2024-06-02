# MSUR Gripper GPIO control

Allows to control a gripper with 2 degrees of freedom 
(gripping and rotating) using L298N or similar driver.

## Parameter Descriptions

- `MSUR_GRIP_CTH_RC` : Gripper catch RC channel
- `MSUR_GRIP_ROT_RC` : Gripper rotation RC channel
- `MSUR_GRIP_A1_REL` : Gripper A1 relay number
- `MSUR_GRIP_A2_REL` : Gripper A2 relay number
- `MSUR_GRIP_B1_REL` : Gripper B1 relay number
- `MSUR_GRIP_B2_REL` : Gripper B2 relay number

## How to use

Connect driver inputs a1, a2, b1, b2 to AUX pins 1-6, 
set the GPIO function for the corresponding outputs 
