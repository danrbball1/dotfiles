#!/usr/bin/env bash

# Update package list and upgrade existing packages
sudo apt update && sudo apt upgrade -y

# Install required packages
PACKAGES=(
    borgbackup
    btop
    cec-utils
    git
    lf
    neofetch
    ranger
    vim
)

sudo apt install -y "${PACKAGES[@]}"

# Verify installation
echo "Installation completed!"
