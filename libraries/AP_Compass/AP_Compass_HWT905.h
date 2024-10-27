#pragma once

#if AP_COMPASS_HWT905_ENABLED
#include "AP_Compass_Backend.h"

class Compass_HWT905 : public AP_Compass_Backend
{
public:
    Compass_HWT905(AP_Compass &compass);
    static AP_Compass_Backend *probe();

    void read() override;

private:

};

#endif