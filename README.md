
# Table of Contents

1.  [INSTALLING ARCH LINUX](#org7510e06)
2.  [MY SHORT JOURNEY](#orgfe3542d)
3.  [SOFTWARES I USE](#org888aa4a)
4.  [How to install require softwares](#org8fc3166)
    1.  [AUR setup (yay)](#orgf6933a7)
5.  [Package you need](#org1cda4aa)
6.  [DISPLAY MANAGEMENT AND GRAPHICAL EFFECTS](#orgb859c17)
7.  [NETWORK TOOLS](#org0808416)
8.  [LOCK-SCREEN, POWER OPTION AND DISPLAY MANAGER](#org79bb50d)
    1.  [LOCK SCREEN AND POWER OPTION](#orga9fd913)
    2.  [LOGIN MANAGER](#org2800c33)
    3.  [LOGIN MANAGER THEME](#org4a2b664)
9.  [MY MAIN SOFTWARE](#orgb970070)



<a id="org7510e06"></a>

# INSTALLING ARCH LINUX

So This is how I setup my system. I use arch linux so at first you have to visit [ARCH LINUX](https://archlinux.org/download/) website and
download the arch iso. Then you have to burn it in a pendrive you can find the tutorial [here](https://youtu.be/gAnA7X8fAGs?si=PgrMLHdeqaWcD_EH). And then follow
the  [arch install tutorial](https://youtu.be/AYxaNjbC1wg?si=UYbJj1Zr-gjapE1a). I install arch like this. Just change the desktop envornment to i3 and you are
good to go. 


<a id="orgfe3542d"></a>

# MY SHORT JOURNEY

I am mainly trying to use only one software [EMACS](https://en.wikipedia.org/wiki/Emacs). I first saw this software in [hexdump](https://www.youtube.com/@hexdump1337). He is an amazing
person. I follow him since early 2024. I like his work so much. After I saw the workflow and the system
customization of [Leonardo Tamiano ](https://blog.leonardotamiano.xyz/)I want his desktop envornment and I want to use my system like him.
Then I fist learn about window manager. My first window manager was [i3wm](https://i3wm.org/). I used it like 6 month.
After learning the bacis of window manager then I started learning emacs. I learned the bacis from two 
youtuber's. They are:

-   [distro tube](https://www.youtube.com/watch?v=scBBjZcy6fc&list=PL5--8gKSku15uYCnmxWPO17Dq6hVabAB4)
-   [SYSTEM CRAFTERS](https://youtu.be/48JlgiBpw_I?si=4PQ6LOblljRwMA3J)


<a id="org888aa4a"></a>

# SOFTWARES I USE

I think you should have a extra [DE](https://wiki.archlinux.org/title/Desktop_environment) or [WM](https://wiki.archlinux.org/title/Window_manager) for saftey. If there are any configuretion error or any problem occer in your main desktop environment then you can switch to your second environment and troubleshoot that problem. Thats why I use [i3wm](https://i3wm.org/) as my second environment. For transparency and smoothness I use [picom](https://wiki.archlinux.org/title/Picom). For notification I use [dunst](https://wiki.archlinux.org/title/Dunst). For screenshoot I use [flameshot](https://wiki.archlinux.org/title/Flameshot). As a terminal I use [alacritty](https://alacritty.org/). For setting wallpaper and maintaining wallpaper settings I use [nitrogen](https://wiki.archlinux.org/title/Nitrogen). And for playing video there is [VLC](https://wiki.archlinux.org/title/VLC_media_player). And for pictures I use [loupe](https://archlinux.org/packages/extra/x86_64/loupe/) know as Image Viewer. At the I use  [Firefox](https://wiki.archlinux.org/title/Firefox). And not but the list [stow](https://man.archlinux.org/man/stow.8) for maintaining config files.


<a id="org8fc3166"></a>

# How to install require softwares

In arch you can find most of the software from the pacman and aur.


<a id="orgf6933a7"></a>

## AUR setup (yay)

    sudo pacman -s --needed git base-devel go
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si

For more information visit [yay](https://github.com/Jguer/yay). 


<a id="org1cda4aa"></a>

# Package you need

For work with arch and emacs you have to download some package and fonts.

    sudo pacman -S xorg xorg-xinit xorg-server xorg-xrandr xorg-xrdb vim network-manager-applet net-tools i3 dmenu dunst flameshot sddm emacs alacritty nitrogen stow picom make cmake vlc loupe firefox nerd-fonts ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-indic-otf harfbuzz noto-fonts noto-fonts-cjk noto-fonts-emoji qt5-declarative qt5-quickcontrols2 qt5-graphicaleffects


<a id="orgb859c17"></a>

# DISPLAY MANAGEMENT AND GRAPHICAL EFFECTS

All the package here, I think they are the basic software you need to run your system. The [xorg](https://www.x.org/wiki/) and the other xorg tool's are for running graphical application you can find more info about this on [Xorg Arch](https://wiki.archlinux.org/title/Xorg). 


<a id="org0808416"></a>

# NETWORK TOOLS

In arch linux you have to download tools for accessing and maintaining your wireless and other connection for those works you need those tools:

    sudo pacman -S network-manager-applet net-tools


<a id="org79bb50d"></a>

# LOCK-SCREEN, POWER OPTION AND DISPLAY MANAGER

As a lockscreen I use [Betterlockscreen](https://github.com/betterlockscreen/betterlockscreen). For all the power options I use [wlogout](https://aur.archlinux.org/packages/wlogout). And as a display manager I use [sddm](https://wiki.archlinux.org/title/SDDM) and the [sddm tiger theme](https://store.kde.org/p/1985612). 


<a id="orga9fd913"></a>

## LOCK SCREEN AND POWER OPTION

    #>>>>> WLOGOUT AND BETTERLOCKSCREEN
    yay -S wlogout betterlockscreen 


<a id="org2800c33"></a>

## LOGIN MANAGER

    sudo pacman -S sddm 
    sudo systemctl enable sddm


<a id="org4a2b664"></a>

## LOGIN MANAGER THEME

    #!/bin/bash
    #>>>>> SETTING UP THE TIGER THEME FOR SDDM LOGIN SCREEN
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


<a id="orgb970070"></a>

# MY MAIN SOFTWARE

As I mentioned earlyer I am using only [EMACS](https://www.gnu.org/software/emacs/). I will bring the full customization soon!

