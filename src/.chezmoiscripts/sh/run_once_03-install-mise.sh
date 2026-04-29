#!/bin/bash
set -eufo pipefail

export PATH="$HOME/.local/bin:$PATH"

MISE_BIN="$HOME/.local/bin/mise"
if command -v mise &> /dev/null; then
    MISE_BIN="$(command -v mise)"
fi

if [ ! -x "$MISE_BIN" ]; then
    echo "Installing mise"
    curl -fsSL https://mise.run | sh
    MISE_BIN="$HOME/.local/bin/mise"
    echo "mise installed successfully: $MISE_BIN"
else
    echo "mise already exists: $MISE_BIN"
fi

"$MISE_BIN" --version
