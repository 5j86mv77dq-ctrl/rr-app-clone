#!/bin/bash
# Move the 9 audiobook covers from ~/Downloads into this folder,
# then crop each one to a 1:1 square (centered crop, 1500x1500).
#
# HOW TO RUN:
#   1. Open Terminal
#   2. Drag this file into Terminal and press Enter
#   (or: bash ~/path/to/move_and_crop_covers.sh)

set -e

# This script's own directory = the Audiobook Covers folder
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOWNLOADS="$HOME/Downloads"

FILES=(
  "01_Mary_at_the_Crossroads_of_History.jpg"
  "02_Confessions.jpg"
  "03_The_Interior_Castle.jpg"
  "04_Introduction_to_the_Devout_Life.jpg"
  "05_Story_of_a_Soul.jpg"
  "06_Brideshead_Revisited.jpg"
  "07_The_Power_and_the_Glory.jpg"
  "08_Kristin_Lavransdatter.jpg"
  "09_The_Lord_of_the_Rings.jpg"
)

echo "=== Audiobook Cover Mover + Cropper ==="
echo "Source: $DOWNLOADS"
echo "Destination: $SCRIPT_DIR"
echo ""

# Check for sips (built into macOS) or ImageMagick
if command -v magick &>/dev/null; then
  CROP_CMD="magick"
elif command -v convert &>/dev/null; then
  CROP_CMD="convert"
else
  CROP_CMD="sips"
fi
echo "Using: $CROP_CMD for cropping"
echo ""

moved=0
cropped=0
missing=()

for f in "${FILES[@]}"; do
  src="$DOWNLOADS/$f"
  dst="$SCRIPT_DIR/$f"

  if [ -f "$src" ]; then
    echo "Moving $f..."
    cp "$src" "$dst"
    rm "$src"
    ((moved++)) || true

    # Crop to square
    echo "  Cropping to 1:1..."
    if [ "$CROP_CMD" = "magick" ]; then
      magick "$dst" -gravity Center -extent "$(magick identify -format '%[fx:min(w,h)]x%[fx:min(w,h)]' "$dst")" "$dst"
    elif [ "$CROP_CMD" = "convert" ]; then
      SIZE=$(convert "$dst" -format "%[fx:min(w,h)]" info:)
      convert "$dst" -gravity Center -crop "${SIZE}x${SIZE}+0+0" +repage "$dst"
    else
      # Use macOS built-in sips
      W=$(sips -g pixelWidth "$dst" | awk '/pixelWidth/{print $2}')
      H=$(sips -g pixelHeight "$dst" | awk '/pixelHeight/{print $2}')
      if [ "$W" -gt "$H" ]; then
        OFFSET=$(( (W - H) / 2 ))
        sips --cropToHeightWidth "$H" "$H" --cropOffset 0 "$OFFSET" "$dst" --out "$dst" 2>/dev/null
      elif [ "$H" -gt "$W" ]; then
        OFFSET=$(( (H - W) / 2 ))
        sips --cropToHeightWidth "$W" "$W" --cropOffset "$OFFSET" 0 "$dst" --out "$dst" 2>/dev/null
      fi
    fi
    ((cropped++)) || true
    echo "  ✓ Done"
  else
    missing+=("$f")
    echo "  ⚠ Not found in Downloads: $f"
  fi
done

echo ""
echo "=== Complete ==="
echo "Moved: $moved files"
echo "Cropped: $cropped files to square"
[ ${#missing[@]} -gt 0 ] && echo "Missing: ${missing[*]}"
echo ""
echo "Files are now in: $SCRIPT_DIR"
