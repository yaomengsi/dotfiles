#!/bin/bash

set -eufo pipefail

mkdir -p ~/etc/supervisor
mkdir -p ~/opt/supervisor

mkdir -p ~/repo/private
mkdir -p ~/repo/github

mkdir -p ~/lang/python
mkdir -p ~/lang/rust
mkdir -p ~/lang/go

mkdir -p ~/tmp

mkdir -p ~/ws

mkdir -p ~/.config/lazygit
touch ~/.config/lazygit/config.yml

mkdir -p ~/.config/neovide
touch ~/.config/neovide/config.toml
