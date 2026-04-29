#!/bin/bash
set -eufo pipefail

# chezmoi bootstrap - installs core prerequisites to bootstrap dotfiles

GREEN='\033[0;32m'
NC='\033[0m'
info() { printf "${GREEN}%s${NC}\n" "$*"; }

install_mise() {
    if command -v mise >/dev/null 2>&1; then
        info "mise already installed: $(mise --version)"
        return 0
    fi

    info "Installing mise..."
    curl -fsSL https://mise.run | sh
    export PATH="$HOME/.local/bin:$PATH"
    info "mise installed successfully: $HOME/.local/bin/mise"
}

install_chezmoi() {
    if command -v chezmoi >/dev/null 2>&1; then
        info "chezmoi already installed: $(chezmoi --version)"
        return 0
    fi
    info "Installing chezmoi..."
    if command -v brew >/dev/null 2>&1; then
        brew install chezmoi
    else
        sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
    fi
    info "chezmoi installed successfully"
}

install_packages() {
    case "$(uname -s)" in
        Darwin)
            if ! command -v brew >/dev/null 2>&1; then
                info "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            brew install git curl
            ;;
        Linux)
            if [ -f /etc/redhat-release ]; then
                sudo dnf install -y git curl
            elif [ -f /etc/debian_version ]; then
                sudo apt update
                sudo apt install -y git curl
            elif [ -f /etc/arch-release ]; then
                sudo pacman -Syu --noconfirm git curl
            else
                echo "Error: unsupported Linux distribution"
                exit 1
            fi
            ;;
        *)
            echo "Error: unsupported OS"
            exit 1
            ;;
    esac
    info "core packages installed"
}

info "==> chezmoi bootstrap starting..."
install_packages
install_mise
install_chezmoi
info "==> done. run 'chezmoi init --apply' to apply dotfiles"
