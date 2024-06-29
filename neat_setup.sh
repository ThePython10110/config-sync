#!/usr/bin/bash

# Note: This script is designed for me, and me alone. It clones a private repo and sets things up the way I want them.
# Should work for Linux Mint
# curl <url> | bash
# or wget <url> && chmod +x neat_setup.sh && ./neat_setup.sh
# where url is https://gist.github.com/ThePython10110/d30451ffd35d8d3e443d792e499f9442/raw/neat_setup.sh
# It sets up DWM too, which is neat.

mkdir -p ~/neat_setup && cd ~/neat_setup

read -p "GUI (Y/n): " gui
read -p "Minecraft (y/N): " mc

echo "-----------INSTALLING GIT AND GITHUB CLI-------------"
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
&& sudo mkdir -p -m 755 /etc/apt/keyrings \
&& wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install -y git gh
gh auth login

if ! [[ "$gui" =~ [nN][oO]* ]]; then
    echo "\n\n---------------MANUAL DOWNLOADS------------------"
    echo "SAVE AS ~/neat_setup/thorium.deb"
    xdg-open "https://github.com/Alex313031/Thorium/releases/latest"
    read -n 1 -s
    echo "SAVE AS ~/neat_setup/Audacity.AppImage"
    xdg-open "https://www.audacityteam.org/download/linux"
    read -n 1 -s
    echo "SAVE AS ~/neat_setup/kitty.txz (make sure to get amd64 binary bundle)"
    xdg-open "https://github.com/kovidgoyal/kitty/releases/latest"
    read -n 1 -s
    echo "SAVE AS ~/neat_setup/MuseScore4.AppImage"
    xdg-open "https://github.com/diedeno/MuseScore/releases/latest"
    read -n 1 -s
    echo "SAVE AS ~/neat_setup/Joplin.AppImage"
    xdg-open "https://github.com/laurent22/joplin/releases/latest"
    read -n 1 -s
    echo "SAVE AS ~/neat_setup/rofi.tar.gz"
    xdg-open "https://github.com/davatorium/rofi/releases/latest"
    read -n 1 -s
fi

echo "\n\n----------------------GO AWAY----------------------"
# Install Apt packages
sudo apt install -y 7zip fzf curl python3-pip tldr trash-cli unrar make gcc

if [[ "$minecraft" =~ [yY]([eE][sS])* ]]; then
    sudo apt install -y openjdk-21-jre openjdk-17-jre openjdk-8-jre
fi

if ! [[ "$gui" =~ [nN][oO]* ]]; then
    sudo add-apt-repository ppa:minetestdevs/stable
    sudo apt update
    if [[ "$minecraft" =~ [yY]([eE][sS])* ]]; then
        flatpak install flathub com.atlauncher.ATLauncher
    fi
    sudo apt install -y gimp nitrogen musescore3 pavucontrol picom minetest \
        scrot lxappearance xdotool xclip simplescreenrecorder bespokesynth \
        libx11-dev libxft-dev libxinerama-dev xorg libharfbuzz-dev
fi
# Download and install .deb's
curl "https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz" -O
sudo gdebi thorium.deb
curl "https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-amd64.deb" -o fastfetch.deb && \
sudo gdebi fastfetch.deb
if ! [[ "$gui" =~ [nN][oO]* ]]; then
    curl "https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb" -o appimagelauncher.deb
    sudo gdebi appimagelauncher.deb
    curl "https://discord.com/api/download?platform=linux&format=deb" -o discord.deb && \
    sudo gdebi discord.deb
    curl "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -o vscode.deb && \
    sudo gdebi vscode.deb
fi

# Install NodeJS
curl -fsSL https://deb.nodesource.com/setup_22.x -o nodesource_setup.sh && \
sudo bash nodesource_setup.sh && \
sudo apt install -y nodejs

# Install Neovim
tar -xzf nvim-linux64.tar.gz
sudo mv -f nvim-linux64 /opt
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

if ! [[ "$gui" =~ [nN][oO]* ]]; then
    # Install kitty
    tar -xzf kitty.tar.gz -C ~/.local
    # Install rofi (stupid cd workaround)
    tar -xzf rofi.tar.gz . -C rofi
    cd rofi/*
    ./install-sh
    # Integrate AppImages with AppImageLauncher
    ail-cli integrate MuseScore4.AppImage
    ail-cli integrate Audacity.AppImage
    ail-cli integrate Joplin.AppImage
fi

# Imports my configuration (private repo)
echo "\n\n------------------SETUP-----------------"
cd ~
git clone https://thepython10110/config-sync --recurse-submodules
mv ~/.bashrc .bashrc.old
cd ~/config-sync
ln -st ~ .bashrc* .zshrc*
mkdir -p ~/.config
ln -s nvim ~/.config/
ln -s starship.toml ~/.config
if ! [[ "$gui" =~ [nN][oO]* ]]; then
    # Set up DWM
    ln -st ~ dwm* dmenu
    cd ~/dwm && sudo make install && cd -
    sudo ln -s dwm.desktop /usr/share/xsessions
fi

cd ~
rm -rf ~/neat_setup

echo "\n\n-----------DONE--------------"
exit
