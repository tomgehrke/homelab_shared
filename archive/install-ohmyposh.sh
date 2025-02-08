#!/bin/bash

# Install prerequisites
sudo apt install unzip

# Download
# sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
$HOMELAB/scripts/update-ohmyposh.sh

# Make executable
sudo chmod +x /usr/local/bin/oh-my-posh

# Get themes
# mkdir ~/.poshthemes
# wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
# unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
# chmod u+rw ~/.poshthemes/*.omp.*
# rm ~/.poshthemes/themes.zip
$HOMELAB/scripts/update-ohmyposh-themes.sh

# Merge custom themes
cp $HOMELAB/poshthemes/* ~/.poshthemes
