#!/bin/bash

set -eufo pipefail

# Stacks to manage: <systemd-unit-name>:<host-data-dir>
STACKS=(
    "9router.service:${HOME}/.9router"
)

if ! command -v docker &> /dev/null; then
    echo "docker is not installed yet; skipping compose stack enablement"
    exit 0
fi

if ! docker compose version &> /dev/null; then
    echo "docker compose plugin is not available; skipping compose stack enablement"
    exit 0
fi

if ! command -v systemctl &> /dev/null; then
    echo "systemctl is not available; skipping compose stack enablement"
    exit 0
fi

# Persist user services across logout so containers truly autostart at boot.
if command -v loginctl &> /dev/null; then
    if ! loginctl show-user "$USER" -p Linger 2> /dev/null | grep -q "Linger=yes"; then
        sudo loginctl enable-linger "$USER" || \
            echo "warning: failed to enable-linger for $USER; containers will only run while logged in"
    fi
fi

systemctl --user daemon-reload

# for entry in "${STACKS[@]}"; do
#     unit="${entry%%:*}"
#     data_dir="${entry##*:}"
#     mkdir -p "$data_dir"

#     if systemctl --user is-enabled "$unit" &> /dev/null; then
#         systemctl --user restart "$unit" || \
#             echo "warning: failed to restart $unit; check 'journalctl --user -u $unit'"
#     else
#         systemctl --user enable --now "$unit" || \
#             echo "warning: failed to enable $unit; check 'journalctl --user -u $unit'"
#     fi
# done
