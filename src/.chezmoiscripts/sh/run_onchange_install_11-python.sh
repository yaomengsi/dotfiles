#!/bin/bash

set -eufo pipefail

export PATH="$HOME/.local/bin:$PATH"

MISE_BIN="$HOME/.local/bin/mise"
if command -v mise &> /dev/null; then
    MISE_BIN="$(command -v mise)"
fi

if [ ! -x "$MISE_BIN" ]; then
    echo "mise is not installed yet"
    exit 1
fi

install_if_missing() {
    local command="$1"
    shift
    if ! command -v "$command" &> /dev/null; then
        echo "$command not found, installing it now"
        "$@"
        echo "$command installed successfully"
    else
        echo "$command already exists: $(command -v "$command")"
    fi
}

# uv tool
install_if_missing pre-commit "$MISE_BIN" exec -- uv tool install pre-commit --with pre-commit-uv --force-reinstall
install_if_missing ruff "$MISE_BIN" exec -- uv tool install ruff
install_if_missing black "$MISE_BIN" exec -- uv tool install black
install_if_missing isort "$MISE_BIN" exec -- uv tool install isort
# install_if_missing flake8 "uv tool install flake8"
# install_if_missing mypy "uv tool install mypy"
