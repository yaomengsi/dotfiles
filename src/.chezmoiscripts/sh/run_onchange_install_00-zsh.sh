#!/bin/bash

set -eufo pipefail

if command -v zsh &> /dev/null; then
    echo "ZSH is already installed"
    exit 0
fi

echo "Installing ZSH"

if [[ "$(uname)" == "Darwin" ]]; then
    if command -v brew &> /dev/null; then
        brew install zsh
    else
        echo "Homebrew is not installed"
        exit 1
    fi

elif [ -f /etc/redhat-release ]; then
    sudo dnf install -y zsh

elif [ -f /etc/debian_version ]; then
    sudo apt update
    sudo apt install -y zsh

elif [ -f /etc/arch-release ]; then
    sudo pacman -Syu --noconfirm zsh

else
    echo "Error: Unsupported OS distribution"
    exit 1
fi


if [ -f /etc/os-release ]; then
    source /etc/os-release
    case $ID in 
        fedora|almalinux)
            echo $ID
            # sudo dnf install -y zsh
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
