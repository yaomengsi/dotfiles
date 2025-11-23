#!/bin/bash

set -eufo pipefail

if ! command -v starship &> /dev/null; then
    echo "Installing Starship"
    curl -fsSL https://starship.rs/install.sh | sh -s -- -y
    echo "Starship installed successfully"
    starship preset jetpack -o ~/.config/starship.toml
    echo "Starship preset jetpack applied successfully"
else
    echo "Starship is already installed"
fi

