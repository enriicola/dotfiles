
INTERNAL_DISPLAY="eDP-1"
EXTERNAL_DISPLAY="HDMI-1"

# Get the resolution of the internal display
INTERNAL_RESOLUTION=$(xrandr | grep "$INTERNAL_DISPLAY connected" -A1 | tail -n1 | awk '{print $1}')
INTERNAL_WIDTH=$(echo $INTERNAL_RESOLUTION | cut -d'x' -f1)
INTERNAL_HEIGHT=$(echo $INTERNAL_RESOLUTION | cut -d'x' -f2)

# Get the resolution of the external display
EXTERNAL_RESOLUTION=$(xrandr | grep "$EXTERNAL_DISPLAY connected" -A1 | tail -n1 | awk '{print $1}')
EXTERNAL_WIDTH=$(echo $EXTERNAL_RESOLUTION | cut -d'x' -f1)
EXTERNAL_HEIGHT=$(echo $EXTERNAL_RESOLUTION | cut -d'x' -f2)

# Set the position of the external display to be on top of the internal display
xrandr --output "$EXTERNAL_DISPLAY" --auto --pos 0x0 \
       --output "$INTERNAL_DISPLAY" --auto --pos 0x$EXTERNAL_HEIGHT
