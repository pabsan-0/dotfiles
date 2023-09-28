#!/bin/sh

# This script scans for available screens
# Meant for a laptop, using only an external one
# If 2 screens are detected, whatever their names, assume 
# there is an external monitor and use it alone.


# Notice the space not to match "disconnected"
if xrandr | grep " connected" | wc -l; then

    if   xrandr | grep -q "DP-1-2-3 connected" ; then
        xrandr --output DP-0 --off --output DP-1 --off --output DP-2 --off --output DP-3 --off --output HDMI-0 --off --output DP-4 --off --output DP-5 --off --output eDP-1-1 --off --output DP-1-1 --off --output DP-1-2 --off --output DP-1-2-1 --off --output DP-1-2-2 --off --output DP-1-2-3 --primary --mode 1920x1080 --pos 1920x0 --rotate normal
    
    elif xrandr | grep -q "DP-1-2 connected"; then
        xrandr --output DP-0 --off --output DP-1 --off --output DP-2 --off --output DP-3 --off --output HDMI-0 --off --output DP-4 --off --output DP-5 --off --output eDP-1-1 --off --output DP-1-1 --off --output DP-1-2 --primary --mode 1920x1080 --pos 1920x0 --rotate normal --output DP-1-2-1 --off --output DP-1-2-2 --off --output DP-1-2-3  --off
    else
        autorandr
        arandr
    fi
else
    autorandr
    arandr
fi


