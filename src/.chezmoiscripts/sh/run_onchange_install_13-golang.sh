#!/bin/bash

set -eufo pipefail

if [[ "$(uname)" == "Darwin" ]]; then
    if command -v brew &> /dev/null; then
        brew install golang
    else
        echo "Homebrew is not installed"
        exit 1
    fi
    
elif [ -f /etc/redhat-release ]; then
    sudo dnf install -y golang

elif [ -f /etc/debian_version ]; then
    sudo apt update
    sudo apt install -y golang

elif [ -f /etc/arch-release ]; then
    sudo pacman -Syu --noconfirm golang

else
    echo "Error: Unsupported OS distribution"
    exit 1
fi

mkdir -p ~/lang/go
go env -w GOPATH=~/lang/go
