include "AP_Compass_HWT905.h"

#if AP_COMPASS_HWT905_ENABLED

#include <AP_HAL/AP_HAL.h>


extern const AP_HAL::HAL &hal;

AP_Compass_Backend *Compass_HWT905::probe();
{
    Compass_HWT905 *_compass = NEW_NOTHROW Compass_HWT905();
    return new Compass_HWT905(_compass);
}

Compass_HWT905::Compass_HWT905(AP_Compass &compass) : AP_Compass_Backend(compass) {
    // Инициализация
}


bool Compass_HWT905::init()
{
    
    return true;
}



void Compass_HWT905::read()
{
    _healthy = true;
    _last_update = AP_HAL::millis();
}


#endif