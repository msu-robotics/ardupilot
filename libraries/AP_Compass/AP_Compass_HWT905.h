#pragma once

#if AP_COMPASS_HWT905_ENABLED
#include "AP_Compass_Backend.h"

class AP_Compass_HWT905 : public AP_Compass_Backend
{
public:
    static AP_Compass_Backend *probe();

    void read() override;

private:
    AP_Compass_HWT905();
    bool init();
};

#endif