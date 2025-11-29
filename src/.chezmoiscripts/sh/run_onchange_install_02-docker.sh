#!/bin/bash

set -eufo pipefail

if command -v docker &> /dev/null; then
    echo "docker is already installed"
    exit 0
fi

echo "Installing docker"

if [[ "$(uname)" == "Darwin" ]]; then
    if command -v brew &> /dev/null; then
        brew install docker
    else
        echo "Homebrew is not installed"
        exit 1
    fi

elif [ -f /etc/os-release ]; then
    source /etc/os-release
    case $ID in 
        fedora|almalinux)
            echo $ID
            # add repo
            sudo dnf -y install dnf-plugins-core
            sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
            
            # install docker
            sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            sudo systemctl enable --now docker
            sudo systemctl enable docker.service
            sudo systemctl enable containerd.service
            
            # config docker
            sudo groupadd docker
            sudo usermod -aG docker $USER
            newgrp docker
            ;;
        ubuntu|debian)
            echo $ID
            # sudo apt update
            # sudo apt install -y zsh
            ;;
        arch)
            echo $ID
            # sudo pacman -Syu --noconfirm zsh
            ;;
        *)
            echo "Error: Unsupported OS distribution"
            exit 1
            ;;
    esac
fi


echo "zsh installed successfully, chsh -s $(which zsh) or sudo chsh $USER to set zsh as default shell"
