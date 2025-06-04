#!/bin/bash 
if [ "$EUID" -ne 0 ]; then 
  echo "Please give your root password"
  exec sudo "$0" "$@"
fi

sudo pacman -S sddm
sudo systemctl enable sddm

echo "Installed successfully"

# >>>>> SETTING UP SDDM THEME
echo "Installing SDDM theme..."

# Clone the sequoia theme
git clone https://codeberg.org/JaKooLit/sddm-sequoia.git /tmp/sddm-sequoia

# Modify wallpaper path in config
sed -i 's|wallpaper="backgrounds/.*"|wallpaper="backgrounds/default"|' /tmp/sddm-sequoia/theme.conf

# Rename the wallpaper image file to "default"
wallpaper_file=$(find /tmp/sddm-sequoia/backgrounds -type f -name "*.jpg" | head -n 1)
if [[ -n "$wallpaper_file" ]]; then
    mv "$wallpaper_file" "/tmp/sddm-sequoia/backgrounds/default"
else
    echo "⚠️ No .jpg wallpaper found to rename!"
fi

# Install the theme to sddm
sudo mkdir -p /usr/share/sddm/themes/
sudo cp -a /tmp/sddm-sequoia /usr/share/sddm/themes/sequoia

# Set the theme
sudo mkdir -p /etc/sddm.conf.d/
echo -e "[Theme]\nCurrent=sequoia" | sudo tee /etc/sddm.conf.d/theme.conf

echo "✅ SDDM Sequoia theme installed and configured!"
