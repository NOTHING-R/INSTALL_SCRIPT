#!/bin/bash 
if [ "$EUID" -ne 0 ]; then 
  echo "Please give your root password"
  exec sudo "$0" "$@"
fi

sudo pacman -S sddm
sudo systemctl enable sddm
mkdir -p /etc/sddm.conf.d/
touch /etc/sddm.conf.d/theme.conf.user
sudo cp -r nothing_sddm_theme/ /usr/share/sddm/themes/ 
cp theme.conf.user /etc/sddm.conf.d/
echo "Installed successfully"
