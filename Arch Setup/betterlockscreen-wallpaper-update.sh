#!/bin/bash

# Step 1: Read wallpaper path from nitrogen config
WALLPAPER=$(grep '^file=' ~/.config/nitrogen/bg-saved.cfg | cut -d= -f2)

# Step 2: Get extension of the wallpaper (jpg/png/jpeg etc.)
# EXTENSION="${WALLPAPER##*.}"

# Step 3: Define target path
TARGET="/usr/share/sddm/themes/nothing_sddm_theme/backgrounds/default"

# Step 4: Copy wallpaper as default
echo "Copying $WALLPAPER to $TARGET"
betterlockscreen -u $WALLPAPER
echo "Done"

