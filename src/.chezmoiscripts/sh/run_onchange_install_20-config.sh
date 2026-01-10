#!/bin/bash

set -eufo pipefail

mkdir -p ~/etc/supervisor
mkdir -p ~/opt/supervisor

mkdir -p ~/ws/workspace

mkdir -p ~/repo/private
mkdir -p ~/repo/github

mkdir -p ~/lang/py
mkdir -p ~/lang/rs
mkdir -p ~/lang/go
mkdir -p ~/lang/cc
mkdir -p ~/lang/js

mkdir -p ~/tmp

mkdir -p ~/.config/lazygit
touch ~/.config/lazygit/config.yml

mkdir -p ~/.config/neovide
touch ~/.config/neovide/config.toml
