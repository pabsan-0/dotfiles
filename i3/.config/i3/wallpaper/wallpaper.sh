#! /usr/bin/env bash
#
# DO NOT USE; still being tested
#
exit 1;

EXECUTABLE="$1"

# Check whether var is non-"" and file exists
if [ -n "$EXECUTABLE" ] || [ -f "$EXECUTABLE" ] ; then

    "$EXECUTABLE" &
    pid=$!
    sleep 1
    if ps -p $pid > /dev/null 2>&1 && wait $pid; then
        # i3-msg fullscreen
        i3lock --color 475263
    else
        i3-nagbar -t warning -m "Wallpaper error: $EXECUTABLE crashed"
    fi

# Else default lock screen
else 
    
    i3lock --color 475263
fi
