#!/bin/bash 
echo "Started....."
yay -S wlogout
mkdir -p ~/.config/wlogout 
cp -r files/* ~/.config/wlogout/
echo "done!"
