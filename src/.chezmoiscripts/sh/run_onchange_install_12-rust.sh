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

if ! command -v cargo &> /dev/null; then
    echo "Installing rust"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile default
    echo "rust installed successfully"
else
    echo "rust is already installed"
fi

install_if_missing rust-analyzer "rustup component add rust-analyzer"

install_if_missing sccache "cargo install sccache"

# astronvim
install_if_missing tree-sitter "cargo install tree-sitter-cli"
install_if_missing rg "cargo install ripgrep"
install_if_missing btm "cargo install bottom"


# neovide dependencies
sudo dnf install -y fontconfig-devel freetype-devel @development-tools libstdc++-static libstdc++-devel
install_if_missing neovide "cargo install --git https://github.com/neovide/neovide"
