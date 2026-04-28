#!/bin/bash

set -eufo pipefail

if command -v rtk &> /dev/null; then
    RTK_CMD=(rtk)
elif command -v mise &> /dev/null; then
    RTK_CMD=(mise exec -- rtk)
else
    echo "rtk not found, skipping RTK init"
    exit 0
fi

# rtk init currently expects these directories to exist before writing files.
mkdir -p ~/.claude
mkdir -p ~/.cursor
mkdir -p ~/.codex

echo "Initializing RTK integrations"
"${RTK_CMD[@]}" init -g --auto-patch
"${RTK_CMD[@]}" init -g --opencode
"${RTK_CMD[@]}" init -g --agent cursor --auto-patch
"${RTK_CMD[@]}" init -g --codex
