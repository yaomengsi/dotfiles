#!/bin/bash
set -eufo pipefail

if ! command -v mise &> /dev/null; then
    echo "Installing mise"
    curl https://mise.run | sh
    echo "mise installed successfully"
else
    echo "mise already exists: $(command -v mise)"
fi
