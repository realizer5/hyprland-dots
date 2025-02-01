#!/usr/bin/env bash
    if pgrep -f "swaybg" &> /dev/null; then
        pkill -f "swaybg" >/dev/null 2>&1
    fi
    wallpaper=$(find $HOME/Pictures/wallpapers/ -name '*.jpg' -o -name '*.jpg' -o -name '*.png' | shuf -n 1)

    swaybg -i $wallpaper -m fill &
