#!/bin/bash
# Colors for output
green="\e[32m"
yellow="\e[33m"
RESET="\e[0m"

# Get the current script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# SETTING UP YAY AND UPDATING THE PACKAGES
echo -e "${YELLOW}Setting up yay...${RESET}"
cd ~
sudo pacman -Suy
sudo pacman -S --needed git base-devel go
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..

# INSTALLING ALL THE REQUERED PACKAGES
echo -e "${YELLOW}Installing required applications...${RESET}"
sudo pacman -S xorg xorg-xinit xorg-server xorg-xrandr xorg-xrdb vim network-manager-applet net-tools i3 dmenu dunst libnotify flameshot sddm emacs alacritty fish nitrogen stow picom make cmake nodejs npm vlc loupe firefox thunar nerd-fonts ttf-jetbrains-mono ttf-jetbrains-mono-nerd 

echo -e "${GREEN}ENABLEING SDDM SERVICE!${RESET}"
sudo systemctl enable sddm.service

echo -e "${GREEN}INSTALLING FISH AS DEFULT SHELL!${RESET}"
chsh -s /usr/bin/fish
sudo chsh -s /usr/bin/fish

echo -e "${GREEN}Done installing applications!${RESET}"
#>>>>>>CLONEING THE DOTFILES REPOR
echo -e "${YELLOW}Cloning dotfiles repo...${RESET}"
git clone https://github.com/NOTHING-R/dotfiles.git ~/dotfiles
echo -e "${GREEN}Done cloning the repo.${RESET}"

#>>>>>>ADDING AND EDITING THE NECCESSERY FILES FOR EXWM SETUP
echo -e "${YELLOW}Setting up EXWM in .xinitrc and Xresources...${RESET}"
echo "Xft.dpi: 125" > ~/.Xresources
xrdb -merge ~/.Xresources

cat > ~/.xinitrc <<EOF
#!/bin/sh
exec emacs
EOF

chmod +x ~/.xinitrc
echo -e "${GREEN}.xinitrc configured!${RESET}"

echo -e "${YELLOW}Creating EXWM desktop session entry...${RESET}"
sudo bash -c 'cat > /usr/share/xsessions/exwm.desktop <<EOF
[Desktop Entry]
Name=EXWM
Exec=emacs
Type=Application
DesktopName=EXWM
EOF'
echo -e "${GREEN}EXWM setup complete!${RESET}"

#>>>>>>INSTALLING BETTERLOCKSCREEN FOR LOCKSCREEN
sudo pacman -Suy
yay -Suy
echo -e "${YELLOW}Installing betterlockscreen...${RESET}"
yay -S betterlockscreen
betterlockscreen -u "$SCRIPT_DIR/betterlockscreen/wallpaper/grim-reaper-skull-black-background-scary-5k-4968x2848-902.jpg"
echo -e "${GREEN}Done with betterlockscreen!${RESET}"

#>>>>>>SETTING UP WLOGOUT
sudo pacman -Suy
echo -e "${YELLOW}Installing wlogout...${RESET}"
yay -S wlogout 
mkdir -p ~/.config/wlogout
cp -r "$SCRIPT_DIR/wlogout/files/"* ~/.config/wlogout/
echo -e "${GREEN}Done setting up wlogout!${RESET}"


#>>>>>>INSTALLING AND EDITIGN THE SDDM THEME
echo -e "${YELLOW}Installing Tiger SDDM theme...${RESET}"
git clone https://github.com/al-swaiti/tiger-sddm-theme.git /tmp/tiger-sddm-theme
sudo mkdir -p /usr/share/sddm/themes/tiger
sudo cp -r /tmp/tiger-sddm-theme/* /usr/share/sddm/themes/tiger/
sudo mkdir -p /etc/sddm.conf.d

CONF_FILE="/etc/sddm.conf.d/theme.conf.user"
if [ -f "$CONF_FILE" ] && grep -q "^\[Theme\]" "$CONF_FILE"; then
    sudo sed -i '/^\[Theme\]/,/^\[/ s/^Current=.*/Current=tiger/' "$CONF_FILE"
else
    echo -e "[Theme]\nCurrent=tiger" | sudo tee -a "$CONF_FILE" > /dev/null
fi

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

if [ -f "$SCRIPT_DIR/background/default" ]; then
    sudo cp "$SCRIPT_DIR/background/default" "/usr/share/sddm/themes/tiger/default"
    echo -e "${GREEN}✔️ Background image set to default in tiger theme.${RESET}"
else
    echo -e "${YELLOW}⚠️ Warning: $SCRIPT_DIR/background/default not found! Background won't be set.${RESET}"
fi

echo -e "${GREEN}✅ Tiger SDDM theme installed, configured, and background set successfully!${RESET}"


#>>>>>>SETTING UP THE BACKGROUDN WITH NITROGEN
if [ -f "$SCRIPT_DIR/background/wallpaper.png" ]; then
    echo -e "${YELLOW}🎨 Wallpaper found, setting via nitrogen...${RESET}"
    nitrogen --set-zoom-fill "$SCRIPT_DIR/background/wallpaper.png" --save
    echo -e "${GREEN}✅ Wallpaper set successfully!${RESET}"
else
    echo -e "${YELLOW}⚠️ Wallpaper not found at $SCRIPT_DIR/background/wallpaper.png${RESET}"
fi

#>>>>>>CONFIGUREING THE DOTEFILES WITH STOW
echo -e "${YELLOW}UPDATING i3, emacs, dunst and fastfetch with stow...${RESET}"
cd ~/dotfiles/
stow i3/ emacs/ fastfetch/ dunst/
echo -e "${GREEN}✔️ Dotfiles applied successfully!${RESET}"
