#!/bin/bash

set -eufo pipefail

if [ ! -d "$HOME/.nvm" ]; then
    echo "Installing nvm"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    echo "nvm installed successfully"
else
    # echo "Updating nvm"
    # (
    # cd "$NVM_DIR"
    # git fetch --tags origin
    # git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
    # ) && \. "$NVM_DIR/nvm.sh"
    echo "nvm updated successfully"
fi

# nvm install --lts
echo "node.js installed successfully"
