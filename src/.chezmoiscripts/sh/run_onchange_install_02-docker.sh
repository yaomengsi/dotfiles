#!/bin/bash

set -eufo pipefail

enable_docker_service() {
    if command -v systemctl &> /dev/null && systemctl list-unit-files &> /dev/null; then
        sudo systemctl enable --now docker
        sudo systemctl enable containerd.service
    else
        echo "systemd is not available; start the docker service manually if needed"
    fi
}

configure_docker_group() {
    local docker_user="${SUDO_USER:-$USER}"

    if ! getent group docker &> /dev/null; then
        sudo groupadd docker
    fi

    sudo usermod -aG docker "$docker_user"
    echo "User $docker_user was added to the docker group; log out and back in for it to take effect"
}

docker_runtime_installed() {
    case $ID in
        fedora|almalinux|rocky|centos|rhel)
            rpm -q docker-ce containerd.io &> /dev/null
            ;;
        ubuntu|debian)
            dpkg-query -W -f='${Status}' docker-ce 2> /dev/null | grep -q "ok installed" &&
                dpkg-query -W -f='${Status}' containerd.io 2> /dev/null | grep -q "ok installed"
            ;;
        arch)
            pacman -Q docker &> /dev/null
            ;;
        *)
            return 1
            ;;
    esac
}

if [[ "$(uname)" == "Darwin" ]]; then
    if command -v orb &> /dev/null || [ -d /Applications/OrbStack.app ]; then
        echo "OrbStack is already installed"
        exit 0
    fi

    echo "Installing OrbStack"

    if command -v brew &> /dev/null; then
        brew install --cask orbstack
        echo "Start OrbStack from Applications to finish setup"
    else
        echo "Homebrew is not installed"
        exit 1
    fi

elif [ -f /etc/os-release ]; then
    source /etc/os-release

    if docker_runtime_installed; then
        echo "docker runtime is already installed"
        enable_docker_service
        configure_docker_group
        exit 0
    fi

    echo "Installing docker"

    case $ID in 
        fedora)
            echo $ID
            # add repo
            sudo dnf -y install dnf-plugins-core
            sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

            # install docker
            sudo dnf install -y docker-ce containerd.io
            enable_docker_service
            configure_docker_group
            ;;
        almalinux|rocky|centos|rhel)
            echo $ID
            # add repo
            sudo dnf -y install dnf-plugins-core
            sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

            # install docker
            sudo dnf install -y docker-ce containerd.io
            enable_docker_service
            configure_docker_group
            ;;
        ubuntu|debian)
            echo $ID
            # add repo
            sudo apt-get update
            sudo apt-get install -y ca-certificates curl
            sudo install -m 0755 -d /etc/apt/keyrings
            sudo curl -fsSL "https://download.docker.com/linux/$ID/gpg" -o /etc/apt/keyrings/docker.asc
            sudo chmod a+r /etc/apt/keyrings/docker.asc
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/$ID ${VERSION_CODENAME:?} stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

            # install docker
            sudo apt-get update
            sudo apt-get install -y docker-ce containerd.io
            enable_docker_service
            configure_docker_group
            ;;
        arch)
            echo $ID
            sudo pacman -Syu --noconfirm docker
            enable_docker_service
            configure_docker_group
            ;;
        *)
            echo "Error: Unsupported OS distribution"
            exit 1
            ;;
    esac
else
    echo "Error: Unsupported OS"
    exit 1
fi


echo "Container runtime installed successfully"
