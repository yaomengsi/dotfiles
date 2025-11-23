#!/bin/bash

set -eufo pipefail

if [[ "$(uname)" == "Darwin" ]]; then
    if command -v brew &> /dev/null; then
        brew install gcc
    else
        echo "Homebrew is not installed"
        exit 1
    fi

elif [ -f /etc/redhat-release ]; then
    sudo dnf install -y gcc gcc-c++
    # sudo dnf group install -y c-development
    # sudo dnf group install -y develpment-tools

elif [ -f /etc/debian_version ]; then
    sudo apt update
    sudo apt install -y gcc

elif [ -f /etc/arch-release ]; then
    sudo pacman -Syu --noconfirm gcc

else
    echo "Error: Unsupported OS distribution"
    exit 1
fi

echo "gcc installed successfully"
