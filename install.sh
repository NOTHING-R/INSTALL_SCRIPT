#!/bin/bash

# Get the current script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Setting up yay..."
cd ~
sudo pacman -S --needed git base-devel go
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..

echo "Installing required applications..."
sudo pacman -S xorg xorg-xinit xorg-server xorg-xrandr vim network-manager-applet net-tools i3 dmenu sddm emacs alacritty nitrogen stow picom make cmake nerd-fonts ttf-jetbrains-mono-nerd qt5-declarative qt5-quickcontrols2 qt5-graphicaleffects
sudo systemctl enable sddm
echo "Done!!"

read -p "Do you want to clone the dotfiles repo? (yes/no): " answer
if [[ "$answer" == "yes" || "$answer" == "y" ]]; then
    echo "Cloning dotfiles repo..."
    git clone https://github.com/NOTHING-R/dotfiles.git ~/dotfiles
else
    echo "You can find it at https://github.com/NOTHING-R"
fi

read -p "Do you want to set up EXWM in .xinitrc? (yes/no): " answer
if [[ "$answer" == "yes" || "$answer" == "y" ]]; then
    echo "Setting up EXWM in .xinitrc and Xresources..."
    echo "Xft.dpi: 125" > ~/.Xresources

    cat > ~/.xinitrc <<EOF
#!/bin/sh
# Start EXWM via Emacs
exec emacs
EOF

    chmod +x ~/.xinitrc
    echo ".xinitrc configured!"

    echo "Creating EXWM desktop session entry..."
    sudo bash -c 'cat > /usr/share/xsessions/exwm.desktop <<EOF
[Desktop Entry]
Name=EXWM
Exec=emacs
Type=Application
DesktopName=EXWM
EOF'

    echo "EXWM setup complete!"
else
    echo "Skipping EXWM setup. You can do it manually later."
fi

# >>>>> SETTING UP BETTERLOCKSCREEN
echo "Installing betterlockscreen..."
yay -S betterlockscreen --noconfirm

echo "Setting betterlockscreen wallpaper..."
betterlockscreen -u "$SCRIPT_DIR/betterlockscreen/wallpaper/grim-reaper-skull-black-background-scary-5k-4968x2848-902.jpg"
echo "Done with betterlockscreen!"

# >>>>> SETTING UP WLOGOUT
echo "Installing wlogout..."
yay -S wlogout --noconfirm
mkdir -p ~/.config/wlogout
cp -r "$SCRIPT_DIR/wlogout/files/"* ~/.config/wlogout/
echo "Done setting up wlogout!"


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
