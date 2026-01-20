#!/bin/bash

PID_FILE="/tmp/caffeine.pid"

is_running() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if kill -0 "$PID" 2>/dev/null; then
            return 0
        fi
    fi
    return 1
}

case "$1" in
    "status")
        if is_running; then
            echo '{"alt": "on", "class": "active", "tooltip": "Caffeine Active: Sleep Inhibited"}'
        else
            echo '{"alt": "off", "class": "inactive", "tooltip": "Caffeine Inactive"}'
        fi
        ;;
    "toggle")
        if is_running; then
            PID=$(cat "$PID_FILE")
            kill "$PID"
            rm "$PID_FILE"
        else
            systemd-inhibit --what=idle:sleep:handle-lid-switch --who="waybar-caffeine" --why="User requested via Waybar" --mode=block sleep infinity &
            echo $! > "$PID_FILE"
        fi
        # Signal Waybar to update the module immediately
        pkill -RTMIN+9 waybar
        ;;
esac
