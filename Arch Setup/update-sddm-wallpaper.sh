#!/bin/bash

# Step 1: Read wallpaper path from nitrogen config
WALLPAPER=$(grep '^file=' ~/.config/nitrogen/bg-saved.cfg | cut -d= -f2)

# Step 2: Get extension of the wallpaper (jpg/png/jpeg etc.)
# EXTENSION="${WALLPAPER##*.}"

# Step 3: Define target path
TARGET="/usr/share/sddm/themes/nothing_sddm_theme/backgrounds/default"

# Step 4: Copy wallpaper as default
echo "Copying $WALLPAPER to $TARGET"
sudo cp "$WALLPAPER" "$TARGET"

# Step 5 (optional): Confirm success
if [[ $? -eq 0 ]]; then
    echo "✅ Wallpaper updated successfully for SDDM."
else
    echo "❌ Failed to update wallpaper. Try checking permissions."
fi
