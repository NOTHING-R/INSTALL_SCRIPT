#!/bin/bash 

echo "Setting up yay..."
cd ~
sudo pacman -S --needed git base-devel go
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..

echo "Installing require application..."

sudo pacman -S xorg xorg-xinit xorg-server xorg-xrandr i3 sddm emacs alacritty nitrogen stow picom qt5-declarative qt5-quickcontrols2 qt5-graphicaleffects

echo "Done!!"

read -p "Do you want to clone the dotfiles repo? (yes/no): " answer

if [[ "$answer" == "yes" || "$answer" == "y" ]]; then
    echo "cloning dotfiles repo"
    git clone https://github.com/NOTHING-R/dotfiles.git ~/dotfiles
else
    echo "You can found it in https://github.com/NOTHING-R"
fi

