#!/bin/bash

# Cycle through Hyprland layouts globally for ALL monitors/workspaces: 
# Master -> Dwindle -> Scrolling

# 1. Get current global layout to determine the rotation
CURRENT_GLOBAL=$(hyprctl getoption general:layout -j | jq -r '.str')

# 2. Determine the next layout
case "$CURRENT_GLOBAL" in
  master)  NEW_LAYOUT="dwindle" ;;
  dwindle) NEW_LAYOUT="scrolling" ;;
  *)       NEW_LAYOUT="master" ;;
esac

# 3. Set the global default for all FUTURE/new workspaces
hyprctl keyword general:layout "$NEW_LAYOUT"

# 4. Force all EXISTING active workspaces to the new layout (all monitors)
for ws in $(hyprctl workspaces -j | jq -r '.[].id'); do
  hyprctl keyword workspace "$ws", layout:"$NEW_LAYOUT"
done

# 5. Notify the user with the Omarchy icon
notify-send "󱂬    System layout set to $NEW_LAYOUT"
