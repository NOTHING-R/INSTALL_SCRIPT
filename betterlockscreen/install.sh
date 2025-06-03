#!/bin/bash 
echo "Started......."
yay -S betterlockscreen 
echo "Setting up......"
betterlockscreen -u wallpaper/grim-reaper-skull-black-background-scary-5k-4968x2848-902.jpg 
# Ask for confirmation before locking
read -p "Do you want to test it now? (yes/no): " answer

if [[ "$answer" == "yes" || "$answer" == "y" ]]; then
    betterlockscreen --lock
else
    echo "Lock setup successful. You can test it later."
fi
