#!/bin/bash

set -eufo pipefail

install_if_missing() {
    local command="$1"
    local install_command="$2"
    if ! command -v "$command" &> /dev/null; then
        echo "$command not found, executing install command: $install_command"
        eval "$install_command"
        echo "$command installed successfully"
    else
        echo "$command already exists: $(command -v "$command")"
    fi
}

if [[ "$(uname)" == "Darwin" ]]; then
    if command -v brew &> /dev/null; then
        brew install openssl readline sqlite3 xz tcl-tk@8 libb2 zstd zlib pkgconfig
        echo "build python dependencies installed successfully"
    else
        echo "Homebrew is not installed"
        exit 1
    fi

elif [ -f /etc/redhat-release ]; then
    sudo dnf install -y make gcc patch zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk8-devel libffi-devel xz-devel libuuid-devel gdbm-libs libnsl2
    sudo dnf install -y libzstd-devel
    echo "build python dependencies installed successfully"

elif [ -f /etc/debian_version ]; then
    sudo apt update
    sudo apt install -y make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl git \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
    sudo apt install -y libzstd-dev
    echo "build python dependencies installed successfully"

elif [ -f /etc/arch-release ]; then
    pacman -S --needed base-devel openssl zlib xz tk zstd
    echo "build python dependencies installed successfully"

else
    echo "Error: Unsupported OS distribution"
fi

if [ ! -d ~/.pyenv ]; then
    echo "Installing pyenv"
    curl https://pyenv.run | bash
    echo "pyenv installed successfully"
else
    # echo "Updating pyenv"
    # pyenv update
    echo "~/.pyenv already exists"
fi

if ! command -v pyenv &> /dev/null; then
    echo "please check .bashrc or .zshrc to seen if pyenv is installed"
else
    echo "pyenv already exists: $(command -v pyenv)"
fi

if ! command -v uv &> /dev/null; then
    echo "Installing uv"
    curl -LsSf https://astral.sh/uv/install.sh | sh
    echo "uv installed successfully"
else
    # echo "Updating uv"
    # uv self update
    echo "uv already exists: $(command -v uv)"
fi

# uv tool
install_if_missing pre-commit "uv tool install pre-commit --with pre-commit-uv --force-reinstall"
install_if_missing ruff "uv tool install ruff"
install_if_missing black "uv tool install black"
install_if_missing isort "uv tool install isort"
# install_if_missing flake8 "uv tool install flake8"
# install_if_missing mypy "uv tool install mypy"
