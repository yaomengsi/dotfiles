#!/bin/bash

set -eufo pipefail

if [ ! -d "${HOME}/.oh-my-zsh" ]; then
    echo "installing oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "oh-my-zsh installed successfully"
else
    echo "oh-my-zsh is already installed"
fi

if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
    echo "installing zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    echo "zsh-autosuggestions installed successfully"
else
    echo "zsh-autosuggestions is already installed"
fi

# if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
#     echo "installing zsh-syntax-highlighting"
#     git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
#     echo "zsh-syntax-highlighting installed successfully"
# else
#     echo "zsh-syntax-highlighting is already installed"
# fi

if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting ]; then
    echo "installing fast-syntax-highlighting"
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
    echo "fast-syntax-highlighting installed successfully"
else
    echo "fast-syntax-highlighting is already installed"
fi

if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions ]; then
    echo "installing zsh-completions"
    git clone https://github.com/zsh-users/zsh-completions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
    echo "zsh-completions installed successfully"
else
    echo "zsh-completions is already installed"
fi
