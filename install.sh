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
sudo pacman -S xorg xorg-xinit xorg-server xorg-xrandr xorg-xrdb vim network-manager-applet net-tools i3 dmenu dunst libnotify flameshot sddm emacs alacritty fish nitrogen stow picom clang make cmake gcc nodejs npm vlc loupe firefox thunar okular nerd-fonts ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-indic-otf harfbuzz noto-fonts noto-fonts-cjk noto-fonts-emoji qt5-declarative qt5-quickcontrols2 qt5-graphicaleffects ripgrep fd unzip curl 
echo -e "${GREEN}ADDING VM CONFIG!${RESET}"
sudo pacman -S qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service
sudo usermod -aG libvirt $(whoami)
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
yay -Suy
echo -e "${YELLOW}Installing wlogout...${RESET}"
yay -S wlogout 
mkdir -p ~/.config/wlogout
cp -r "$SCRIPT_DIR/wlogout/files/"* ~/.config/wlogout/
echo -e "${GREEN}Done setting up wlogout!${RESET}"

#>>>>>>SETTING UP THE BACKGROUDN WITH NITROGEN
if [ -f "$SCRIPT_DIR/background/wallpaper.png" ]; then
    echo -e "${YELLOW}🎨 Wallpaper found, setting via nitrogen...${RESET}"
    nitrogen --set-zoom-fill "$SCRIPT_DIR/background/wallpaper.png" --save
    echo -e "${GREEN}✅ Wallpaper set successfully!${RESET}"
else
    echo -e "${YELLOW}⚠️ Wallpaper not found at $SCRIPT_DIR/background/wallpaper.png${RESET}"
fi


# #>>>>>> INSTALLING LAZYVIM FOR CODING
sudo pacman -S neovim
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

#>>>>>>CONFIGUREING THE DOTEFILES WITH STOW
echo -e "${YELLOW}UPDATING i3, emacs, dunst and fastfetch with stow...${RESET}"
cd
rm -rf ~/.config/emacs
rm -rf ~/.emacs.d
rm -rf ~/.config/i3
rm -rf ~/.config/dunst

cd ~/dotfiles/
stow i3/ emacs/ fastfetch/ dunst/ nvim/
echo -e "${GREEN}✔️ Dotfiles applied successfully!${RESET}"
