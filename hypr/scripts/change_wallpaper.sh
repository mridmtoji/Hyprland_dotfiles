#!/usr/bin/env bash

WALLPAPERS_DIR="$HOME/Pictures/Wallpapers/"

TRANSITIONS=(
    simple fade left right top bottom
    wipe wave grow center any outer
)

TRANSITION=${TRANSITIONS[$RANDOM % ${#TRANSITIONS[@]}]}

if ! pgrep -x "swww-daemon" >/dev/null; then
  swww-daemon &
  sleep 0.5
fi

FILE=$(zenity --file-selection \
              --title="Choose Wallpaper" \
              --filename="$WALLPAPERS_DIR/" \
              --file-filter="Images | *.gif *.jpg *.jpeg *.png *.webp *.bmp")

[ -z "$FILE" ] && exit 0

matugen image "$FILE" --mode dark --json hex

sleep 0.3

# Apply colors to running terminals (if using sequences method)
# pkill -USR1 foot

hyprctl reload

swww clear-cache
sleep 0.5

swww img "$FILE" \
  --transition-type $TRANSITION \
  --transition-duration 1.0 \
  --transition-bezier .25,.1,.25,1 \
  --transition-fps 60

ln -sf "$FILE" ~/.cache/current_wallpaper

