#!/bin/bash

TEMP_FILE="/tmp/hyprsunset_current_temp"
DEFAULT_TEMP=4000
MIN_TEMP=1000
MAX_TEMP=10000
STEP=500

get_temp() {
    if [ -f "$TEMP_FILE" ]; then
        cat "$TEMP_FILE"
    else
        echo $DEFAULT_TEMP
    fi
}

set_temp() {
    echo "$1" > "$TEMP_FILE"
}

current_temp=$(get_temp)

if [ "$1" == "toggle" ]; then
    if pgrep -x hyprsunset > /dev/null; then
        pkill -x hyprsunset
    else
        hyprsunset -t "$current_temp" > /dev/null 2>&1 &
    fi
    exit 0
fi

if [ "$1" == "increase" ]; then
    new_temp=$((current_temp + STEP))
    if [ "$new_temp" -gt "$MAX_TEMP" ]; then
        new_temp=$MAX_TEMP
    fi
    set_temp "$new_temp"
    if pgrep -x hyprsunset > /dev/null; then
        pkill -x hyprsunset
        hyprsunset -t "$new_temp" > /dev/null 2>&1 &
    fi
    exit 0
fi

if [ "$1" == "decrease" ]; then
    new_temp=$((current_temp - STEP))
    if [ "$new_temp" -lt "$MIN_TEMP" ]; then
        new_temp=$MIN_TEMP
    fi
    set_temp "$new_temp"
    if pgrep -x hyprsunset > /dev/null; then
        pkill -x hyprsunset
        hyprsunset -t "$new_temp" > /dev/null 2>&1 &
    fi
    exit 0
fi

if [ "$1" == "status" ]; then
    if pgrep -x hyprsunset > /dev/null; then
        echo "{\"text\": \"\ue32b\", \"tooltip\": \"Blue light filter on (${current_temp}K)\", \"class\": \"active\"}"
    else
        echo "{\"text\": \"\ue30d\", \"tooltip\": \"Blue light filter off (Set: ${current_temp}K)\", \"class\": \"inactive\"}"
    fi
fi