#!/bin/sh

# Initializes parameters for HamClock stored in environmental variables
if [ ! -f /root/.hamclock/eeprom ]; then
    # Creates the eeprom file if it doesn't exist
    /usr/local/bin/hamclock -0 &
    while [ ! -f /root/.hamclock/eeprom ]; do
        sleep 1
    done

    # Configure eeprom with environmental variables
    let OFFSET=$UTC_OFFSET*3600
    perl hceeprom.pl NV_TITLE $CALLSIGN &&
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
    perl hceeprom.pl -l
    
    # restarts hamclock to load the eeprom
    pkill hamclock
fi
# Starts HamClock
/usr/local/bin/hamclock -o -k

# -t 20 throttle CPU to 20%, minimum is 10
# -o stdout instead of log file
# -k skip setup
