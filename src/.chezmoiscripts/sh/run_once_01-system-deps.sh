#!/bin/bash

set -eufo pipefail

if [[ "$(uname)" == "Darwin" ]]; then
    if command -v brew &> /dev/null; then
        brew install openssl readline sqlite3 xz tcl-tk@8 libb2 zstd zlib pkgconfig
        brew install supervisor
    else
        echo "Homebrew is not installed"
        exit 1
    fi
elif [ -f /etc/redhat-release ]; then
    sudo dnf install -y make gcc patch zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk8-devel libffi-devel xz-devel libuuid-devel gdbm-libs libnsl2
    sudo dnf install -y libzstd-devel
    sudo dnf install -y python3-devel
    sudo dnf install -y supervisor
elif [ -f /etc/debian_version ]; then
    sudo apt update
    sudo apt install -y make build-essential libssl-dev zlib1g-dev \
        libbz2-dev libreadline-dev libsqlite3-dev curl git \
        libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
    sudo apt install -y libzstd-dev
    sudo apt install -y supervisor
elif [ -f /etc/arch-release ]; then
    sudo pacman -S --needed base-devel openssl zlib xz tk zstd
    sudo pacman -S --needed supervisor
else
    echo "Error: Unsupported OS distribution"
    exit 1
fi

echo "runtime build dependencies installed successfully"
