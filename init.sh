#!/bin/sh

# NOTE: The callsign is edited by the hceeprom.pl script, which does edit the eeprom.
# This script is directly from the clearskyinstitute/hamclock repository, however, the
# setup does not recognize the callsign change. The callsign change is only recognized 
# after using the setup menu. I suspect it has to do with another property within the 
# eeprom that is also required. The setup.cpp callsignOk() is returning a false value.
# Initializes parameters for HamClock stored in environmental variables

# How to update callsign after initial setup
# curl http://localhost:8080/set_newde?call=AB1CDE
# curl http://localhost:8080/restart

EEPROM_PATH=$HOME/.hamclock/eeprom
if [ ! -f ${EEPROM_PATH} ]; then
    # Creates the eeprom file if it doesn't exist
    /usr/local/bin/hamclock -0 &
    while [ ! -f ${EEPROM_PATH} ]; do
        sleep 1
    done

    # Configure eeprom with environmental variables
    let OFFSET=$UTC_OFFSET*3600
    perl hceeprom.pl NV_CALLSIGN $CALLSIGN &&
    perl hceeprom.pl NV_DE_GRID $LOCATOR &&
    perl hceeprom.pl NV_DE_LAT $LAT &&
    perl hceeprom.pl NV_DE_LNG $LONG &&
    perl hceeprom.pl NV_DE_TZ $OFFSET &&
    perl hceeprom.pl NV_BCMODE $VOACAP_MODE &&
    perl hceeprom.pl NV_BCPOWER $VOACAP_POWER &&
    perl hceeprom.pl NV_FLRIGHOST $FLRIG_HOST &&
    perl hceeprom.pl NV_FLRIGPORT $FLRIG_PORT &&
    perl hceeprom.pl NV_FLRIGUSE $USE_FLRIG &&
    perl hceeprom.pl NV_METRIC_ON $USE_METRIC &&
    perl hceeprom.pl NV_CALL_BG $CALLSIGN_BACKGROUND_COLOR &&
    perl hceeprom.pl NV_CALL_RAINBOW $CALLSIGN_BACKGROUND_RAINBOW &&
    perl hceeprom.pl NV_CALL_FG $CALLSIGN_COLOR &&
    perl hceeprom.pl NV_WIFI_SSID $WIFI_SSID &&
    perl hceeprom.pl NV_WIFI_PASSWD $WIFI_PWD &&
    perl hceeprom.pl NV_WIFI_PASSWD $WIFI_PWD &&
    perl hceeprom.pl NV_SHOW_PIP $SHOW_PUB_IP &&
    perl hceeprom.pl NV_X11FLAGS 0x01 &&
    perl hceeprom.pl NV_PLOT_0 0x19 &&
    perl hceeprom.pl NV_DX_GRID $DXGRID &&
    perl hceeprom.pl -l

    # Kill the initial HamClock process to load the new eeprom
    pkill hamclock
fi
# Starts HamClock
/usr/local/bin/hamclock -o -k

# -t 20 throttle CPU to 20%, minimum is 10
# -o stdout instead of log file
# -k skip setup
