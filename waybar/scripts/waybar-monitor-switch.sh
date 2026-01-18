#!/bin/bash

CONFIG_FILE="$HOME/.config/waybar/config.jsonc"
LAST_STATE="unknown"
LOG_FILE="/tmp/waybar-switch.log"

echo "Script started at $(date)" > "$LOG_FILE"

while true; do
    if hyprctl monitors | grep -q "HDMI-A-1"; then
        CURRENT_STATE="docked"
    else
        CURRENT_STATE="undocked"
    fi

    if [ "$CURRENT_STATE" != "$LAST_STATE" ]; then
        echo "$(date): State changed from $LAST_STATE to $CURRENT_STATE" >> "$LOG_FILE"
        
        # Wait a moment for monitors to settle
        sleep 2

        if [ "$CURRENT_STATE" == "docked" ]; then
             echo "Applying docked config..." >> "$LOG_FILE"
             # Switching to docked: Replace [1, 2, 3, 4, 5] with [1]
             sed -i 's/"eDP-1": \[[0-9, ]*\]/"eDP-1": [1]/' "$CONFIG_FILE"
             # Move workspaces 2-5 to external monitor
             for i in {2..5}; do hyprctl dispatch moveworkspacetomonitor $i HDMI-A-1; done
        else
             echo "Applying undocked config..." >> "$LOG_FILE"
             # Switching to undocked: Replace [1] with [1, 2, 3, 4, 5]
             sed -i 's/"eDP-1": \[[0-9, ]*\]/"eDP-1": [1, 2, 3, 4, 5]/' "$CONFIG_FILE"
        fi
        
        # Restart waybar cleanly
        echo "Restarting waybar..." >> "$LOG_FILE"
        killall waybar
        sleep 1
        uwsm-app -- waybar &
        
        LAST_STATE="$CURRENT_STATE"
    fi
    sleep 2
done