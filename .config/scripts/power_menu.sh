#!/bin/bash

if pgrep -f "qs.*PowerMenu.qml" > /dev/null; then
    pkill -f "qs.*PowerMenu.qml"
else
    qs -p "/home/destycoon/.config/quickshell/modules/bar/barModules/PowerMenu.qml"
fi
