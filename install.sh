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
sudo pacman -S xorg xorg-xinit xorg-server xorg-xrandr xorg-xrdb vim network-manager-applet net-tools i3 dmenu dunst sddm emacs alacritty nitrogen stow picom make cmake vlc nerd-fonts ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-indic-otf harfbuzz noto-fonts noto-fonts-cjk noto-fonts-emoji qt5-declarative qt5-quickcontrols2 qt5-graphicaleffects
sudo systemctl enable sddm
echo "Done!!"

# >>>>> CLONING THE DOTFILES REPO 
echo "Cloning dotfiles repo..."
git clone https://github.com/NOTHING-R/dotfiles.git ~/dotfiles
echo "Done cloning the repo"

# >>>>> SETTING UP BETTERLOCKSCREEN
echo "Setting up EXWM in .xinitrc and Xresources..."
echo "Xft.dpi: 125" > ~/.Xresources
xrdb -merge ~/.Xresources

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

# >>>>> SETTING UP SDDM THEME (TIGER)
# echo "Installing Tiger SDDM theme..."
# git clone https://github.com/al-swaiti/tiger-sddm-theme.git /tmp/tiger-sddm-theme
# sudo mkdir -p /usr/share/sddm/themes/tiger
# sudo cp -r /tmp/tiger-sddm-theme/* /usr/share/sddm/themes/tiger/
# sudo mkdir -p /etc/sddm.conf.d
# echo -e "[Theme]\nCurrent=tiger" | sudo tee /etc/sddm.conf.d/tiger.conf > /dev/null
# echo "Tiger SDDM theme installed and set as default!"
# >>>>>> OLD SCRIPT END'S HERE

# >>>>> SETTING UP SDDM THEME (TIGER)
# >>>>> SETTING UP SDDM THEME (TIGER)
echo "Installing Tiger SDDM theme..."
git clone https://github.com/al-swaiti/tiger-sddm-theme.git /tmp/tiger-sddm-theme
sudo mkdir -p /usr/share/sddm/themes/tiger
sudo cp -r /tmp/tiger-sddm-theme/* /usr/share/sddm/themes/tiger/
sudo mkdir -p /etc/sddm.conf.d

# Modify or create /etc/sddm.conf.d/theme.conf.user
CONF_FILE="/etc/sddm.conf.d/theme.conf.user"

if [ -f "$CONF_FILE" ] && grep -q "^\[Theme\]" "$CONF_FILE"; then
    # Edit only inside [Theme] section
    sudo sed -i '/^\[Theme\]/,/^\[/ s/^Current=.*/Current=tiger/' "$CONF_FILE"
else
    # Append section if not present
    echo -e "[Theme]\nCurrent=tiger" | sudo tee -a "$CONF_FILE" > /dev/null
fi

# Step 1: Ensure Background="default" in theme.conf
THEME_CONF="/usr/share/sddm/themes/tiger/theme.conf"

if [ -f "$THEME_CONF" ]; then
    if grep -q "^Background=" "$THEME_CONF"; then
        sudo sed -i 's/^Background=.*/Background="default"/' "$THEME_CONF"
    else
        echo 'Background="default"' | sudo tee -a "$THEME_CONF" > /dev/null
    fi
else
    echo 'Background="default"' | sudo tee "$THEME_CONF" > /dev/null
fi

# Step 2: Copy background/default file to tiger theme directory
if [ -f "$SCRIPT_DIR/background/default" ]; then
    sudo cp "$SCRIPT_DIR/background/default" "/usr/share/sddm/themes/tiger/default"
    echo "✔️ Background image set to default in tiger theme."
else
    echo "⚠️ Warning: $SCRIPT_DIR/background/default not found! Background won't be set."
fi

echo "✅ Tiger SDDM theme installed, configured, and background set successfully!"

# >>>>> UPDATING i3 emacs and fastfetch script with stow 
echo "UPDATING i3 emacs and fastfetch with stow"
cd ~/dotfiles/
stow i3/ emacs/ fastfetch/

# >>>>>> SETTING UP DAFULT WALLPAPER
nitrogen --set-zoom-fill background/wallpaper.png --save
