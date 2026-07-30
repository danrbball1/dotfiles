#!/bin/bash

# TODO: Set this to a default, but allow 
# easy override by passing a parameter or 
# using the environment variable 
# KIOSK_URL.
KIOSK_URL="http://192.168.20.3:8123"

# Wait for services to come online. TODO: 
# It would be nice to get rid of this, 
# but right now on Bookworm, if we don't 
# wait, there are errors at boot and you 
# have to start kiosk manually.
sleep 8

#echo 'Hiding the mouse cursor...' 
# unclutter -idle 0.1 -root &

echo 'Starting Chromium...' 
#/usr/bin/chromium-browser --noerrdialogs --disable-infobars --kiosk --app=$KIOSK_URL --enable-features=OverlayScrollbar
/usr/bin/chromium-browser --kiosk --noerrdialogs --disable-infobars --enable-features=OverlayScrollbar --disable-restore-session-state --app=$KIOSK_URL
