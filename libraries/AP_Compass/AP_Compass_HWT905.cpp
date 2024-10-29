#include "AP_Compass_HWT905.h"

#if AP_COMPASS_HWT905_ENABLED

#include <AP_HAL/AP_HAL.h>


extern const AP_HAL::HAL &hal;

AP_Compass_Backend *AP_Compass_HWT905::probe()
{
    return new AP_Compass_HWT905();
}

//AP_Compass_HWT905AP_Compass_HWT905::AP_Compass_HWT905() : AP_Compass_Backend(_compass)
//{
//    // Инициализация
//}


bool AP_Compass_HWT905::init()
{
    
    return true;
}



void AP_Compass_HWT905::read()
{

}


#endif