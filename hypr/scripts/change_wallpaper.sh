#!/usr/bin/env bash

WALLPAPERS_DIR="$HOME/Pictures/Wallpapers"

TRANSITIONS=(
    simple fade left right top bottom
    wipe wave grow center any outer
)
TRANSITION=${TRANSITIONS[$RANDOM % ${#TRANSITIONS[@]}]}

pgrep -x "swww-daemon" >/dev/null || swww-daemon &

# Use walker to select wallpaper
# Create a mapping of filenames to full paths
cd "$WALLPAPERS_DIR" || exit 1

# Get all image files with full paths
mapfile -t FULL_PATHS < <(find "$WALLPAPERS_DIR" -type f \( -iname "*.gif" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.bmp" \))

# Extract just the filenames for display
FILENAMES=()
for path in "${FULL_PATHS[@]}"; do
    FILENAMES+=("$(basename "$path")")
done

# Show filenames in walker
SELECTED=$(printf "%s\n" "${FILENAMES[@]}" | walker --dmenu)

[ -z "$SELECTED" ] && exit 0

# Find the full path of the selected file
FILE=""
for path in "${FULL_PATHS[@]}"; do
    if [ "$(basename "$path")" = "$SELECTED" ]; then
        FILE="$path"
        break
    fi
done

[ -z "$FILE" ] && exit 0

ln -sf "$FILE" ~/.cache/current_wallpaper

{
    swww img "$FILE" \
      --transition-type "$TRANSITION" \
      --transition-duration 1.0 \
      --transition-bezier .25,.1,.25,1 \
      --transition-fps 60
} &

{
    matugen image "$FILE" --mode dark --json hex
    hyprctl reload
} &

wait
