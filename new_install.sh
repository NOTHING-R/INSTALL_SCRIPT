#!/bin/bash
# Colors for output
green="\e[32m"
yellow="\e[33m"
RESET="\e[0m"


cat << 'EOF'


                                  WELCOME ON
 _____   ____  __  _    ___       _____ __ __  _____ ______    ___  ___ ___ 
|     | /    ||  |/ ]  /  _]     / ___/|  |  |/ ___/|      |  /  _]|   |   |
|   __||  o  ||  ' /  /  [_     (   \_ |  |  (   \_ |      | /  [_ | _   _ |
|  |_  |     ||    \ |    _]     \__  ||  ~  |\__  ||_|  |_||    _]|  \_/  |
|   _] |  _  ||     ||   [_      /  \ ||___, |/  \ |  |  |  |   [_ |   |   |
|  |   |  |  ||  .  ||     |     \    ||     |\    |  |  |  |     ||   |   |
|__|   |__|__||__|\_||_____|      \___||____/  \___|  |__|  |_____||___|___|


                            EVERYTHING IS AN ILLUSION 
EOF


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
sudo pacman -S xorg xorg-xinit xorg-server xorg-xrandr xorg-xrdb vim network-manager-applet net-tools dunst libnotify flameshot sddm emacs alacritty fish stow picom clang make cmake gcc pavucontrol nodejs npm loupe firefox thunar okular nerd-fonts ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-indic-otf harfbuzz noto-fonts noto-fonts-cjk noto-fonts-emoji qt5-declarative qt5-quickcontrols2 qt5-graphicaleffects ripgrep fd unzip curl gvfs udisks2 thunar-volman polkit-gnome xclip jq feh

echo -e "${GREEN}ADDING VM CONFIG!${RESET}"
sudo pacman -S --needed \
    qemu-full \
    virt-manager \
    virt-viewer \
    dnsmasq \
    vde2 \
    openbsd-netcat \
    libvirt \
    edk2-ovmf

sudo systemctl enable --now libvirtd
sudo usermod -aG libvirt "$(whoami)"
sudo virsh net-start default
sudo virsh net-autostart default

echo -e "${GREEN}ENABLEING SDDM SERVICE!${RESET}"
sudo systemctl enable sddm.service

echo -e "${GREEN}INSTALLING FISH AS DEFULT SHELL!${RESET}"
chsh -s /usr/bin/fish
sudo chsh -s /usr/bin/fish

echo -e "${GREEN}Done installing applications!${RESET}"
#>>>>>>CLONEING THE DOTFILES REPOR
echo -e "${YELLOW}Cloning dotfiles repo...${RESET}"
git clone  https://github.com/NOTHING-R/dotfiles_MARCH_2026.git ~/dotfiles
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


cat > ~/.xprofile <<EOF
#!/bin/bash
xinput set-prop "SYNA3071:00 06CB:82F1 Touchpad" "libinput Tapping Enabled" 1
xinput set-prop "SYNA3071:00 06CB:82F1 Touchpad" "libinput Natural Scrolling Enabled" 1

picom &
~/.fehbg &
dwmblocks &
EOF

chmod +x ~/.xprofile 
echo -e "${GREEN}.xprofile configured!${RESET}"

echo -e "${YELLOW}Creating EXWM desktop session entry...${RESET}"
sudo bash -c 'cat > /usr/share/xsessions/dwm.desktop <<EOF
[Desktop Entry]
Name=dwm
Comment=Dynamic Window Manager
Exec= /usr/local/bin/dwm
TryExec=/usr/local/bin/dwm
Type=Application
DesktopNames=dwm
EOF'
echo -e "${GREEN}EXWM setup complete!${RESET}"

#>>>>>>INSTALLING BETTERLOCKSCREEN FOR LOCKSCREEN
sudo pacman -Suy
yay -Suy
echo -e "${YELLOW}Installing betterlockscreen...${RESET}"

sudo pacman -Rns i3lock
yay -S betterlockscreen
betterlockscreen -u "$SCRIPT_DIR/betterlockscreen/wallpaper/grim-reaper-skull-black-background-scary-5k-4968x2848-902.jpg"
echo -e "${GREEN}Done with betterlockscreen!${RESET}"

#>>>>>>SETTING UP WLOGOUT
sudo pacman -Suy
yay -Suy
echo -e "${YELLOW}Installing wlogout...${RESET}"
yay -S wlogout 
mkdir -p ~/.config/wlogout
cp -r "$SCRIPT_DIR/wlogout/files/"* ~/.config/wlogout/
echo -e "${GREEN}Done setting up wlogout!${RESET}"


#ADDING SDDM THEME 
echo -e "${YELLOW}Installing Tiger SDDM theme...${RESET}"

# Clone repo into /tmp
git clone https://github.com/al-swaiti/tiger-sddm-theme.git /tmp/tiger-sddm-theme

# Extract tiger.tar.gz into SDDM theme directory
sudo mkdir -p /usr/share/sddm/themes
sudo tar -xzvf /tmp/tiger-sddm-theme/tiger.tar.gz -C /usr/share/sddm/themes

# Ensure the theme directory name is correct
THEME_DIR="/usr/share/sddm/themes/tiger"

if [ ! -d "$THEME_DIR" ]; then
    echo -e "${YELLOW}⚠️ Tiger theme folder not found. Checking folder name...${RESET}"
    # Sometimes archive extracts as "tiger-sddm-theme"
    if [ -d "/usr/share/sddm/themes/tiger-sddm-theme" ]; then
        sudo mv /usr/share/sddm/themes/tiger-sddm-theme "$THEME_DIR"
    else
        echo "❌ Tiger theme could not be installed."
        exit 1
    fi
fi

# Install fonts
if [ -d "$THEME_DIR/TTF" ]; then
    sudo cp -r "$THEME_DIR/TTF" /usr/share/fonts/
    fc-cache -f -v
fi

# Create SDDM config directory
sudo mkdir -p /etc/sddm.conf.d

CONF_FILE="/etc/sddm.conf.d/theme.conf"

# Write or update theme config
echo -e "${GREEN}✔️ Setting SDDM theme to 'tiger'...${RESET}"
echo -e "[Theme]\nCurrent=tiger" | sudo tee "$CONF_FILE" > /dev/null

# Set background inside theme.conf
THEME_CONF="$THEME_DIR/theme.conf"

if grep -q "^Background=" "$THEME_CONF"; then
    sudo sed -i 's/^Background=.*/Background="default"/' "$THEME_CONF"
else
    echo 'Background="default"' | sudo tee -a "$THEME_CONF" > /dev/null
fi

# Copy background if available
if [ -f "$SCRIPT_DIR/background/default" ]; then
    sudo cp "$SCRIPT_DIR/background/default" "$THEME_DIR/default"
    echo -e "${GREEN}✔️ Background image applied.${RESET}"
else
    echo -e "${YELLOW}⚠️ No custom background found. Using default.${RESET}"
fi

echo -e "${GREEN}✅ Tiger SDDM theme installed and configured successfully!${RESET}"


# #>>>>>> INSTALLING LAZYVIM FOR CODING
sudo pacman -S neovim
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

#>>>>>>CONFIGUREING THE DOTEFILES WITH STOW
echo -e "${YELLOW}UPDATING i3, emacs, dunst and fastfetch with stow...${RESET}"
cd
rm -rf ~/.config/emacs
rm -rf ~/.emacs.d
rm -rf ~/.config/sway
rm -rf ~/.config/dunst
rm -rf ~/.config/nvim

cd ~/dotfiles/
stow sway/ emacs/ fastfetch/ dunst/ nvim/ 
echo -e "${GREEN}✔️ Dotfiles applied successfully!${RESET}"

echo -e "${GREEN}✔️ YOU ARE ALL DONE${RESET}"
