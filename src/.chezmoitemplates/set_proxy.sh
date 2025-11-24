#!/bin/bash

# for wsl ip
HOST_IP="$(ip route show | grep -i default | awk '{ print $3}')"
# WSL_IP="$(hostname -I | awk '{print $1}')"
WSL_IP="$(ip route get 1.1.1.1 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="src") print $(i+1); exit}' || ip addr show | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | cut -d/ -f1 | head -1)"

# clash verge
_HOST_PROXY_PORT=7897
# mihomo
_HOST_PROXY_PORT=7890
# karing all
_HOST_PROXY_PORT=3066
# karing rules
_HOST_PROXY_PORT=3067

PROXY_IP=${HOST_IP}
PROXY_PORT=${_HOST_PROXY_PORT}

PROXY_IP_PORT="${PROXY_IP}:${PROXY_PORT}"
HOST_PROXY_HTTP="http://${PROXY_IP_PORT}"
HOST_PROXY_SOCKS="socks5://${PROXY_IP_PORT}"

unset_proxy() {
    unset http_proxy
    unset HTTP_PROXY
    unset https_proxy
    unset HTTPS_PROXY
    unset all_proxy
    unset ALL_PROXY
}

set_proxy() {
    echo "host ip:" "${HOST_IP}"
    echo "wsl ip:" "${WSL_IP}"
    proxy_http="${HOST_PROXY_HTTP}"
    # proxy_http="${HOST_PROXY_SOCKS}"
    export http_proxy="${proxy_http}"
    export HTTP_PROXY="${proxy_http}"
    export https_proxy="${proxy_http}"
    export HTTPS_PROXY="${proxy_http}"
    export all_proxy="${proxy_http}"
    export ALL_PROXY="${proxy_http}"
    echo "proxy:" "${proxy_http}"
}
