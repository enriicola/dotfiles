#!/bin/bash

CONFIG_FILE="$HOME/.config/waybar/config.jsonc"
CONFIG_DOCKED="$HOME/.config/waybar/config.docked.jsonc"
CONFIG_UNDOCKED="$HOME/.config/waybar/config.undocked.jsonc"
LOG_FILE="/tmp/waybar-switch.log"
LAST_STATE="unknown"

echo "Script started at $(date)" > "$LOG_FILE"

while true; do
    # Check for HDMI-A-1 connection
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
             cp "$CONFIG_DOCKED" "$CONFIG_FILE"
             
             # Move workspaces 2-5 to external monitor
             for i in {2..5}; do 
                 hyprctl dispatch moveworkspacetomonitor $i HDMI-A-1
             done
             # Ensure workspace 1 is on eDP-1
             hyprctl dispatch moveworkspacetomonitor 1 eDP-1
        else
             echo "Applying undocked config..." >> "$LOG_FILE"
             cp "$CONFIG_UNDOCKED" "$CONFIG_FILE"
             
             # Move all workspaces back to eDP-1 when undocked
             for i in {1..5}; do 
                 hyprctl dispatch moveworkspacetomonitor $i eDP-1
             done
        fi
        
        # Restart waybar cleanly
        echo "Restarting waybar..." >> "$LOG_FILE"
        killall waybar 2>/dev/null
        sleep 0.5
        uwsm-app -- waybar &
        
        LAST_STATE="$CURRENT_STATE"
    fi
    sleep 2
done
