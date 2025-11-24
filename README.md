# dotfiles

## install

```sh
sudo dnf install chezmoi git

chezmoi init git@github.com:USERNAME/dotfiles.git

HTTP_PROXY=socks5://127.0.0.1:3067 HTTPS_PROXY=socks5://127.0.0.1:3067 ALL_PROXY=socks5://127.0.0.1:3067 chezmoi apply
```

## summary

git
chezmoi
curl
wget

golang
tldr
neovim
yazi
awk

- shell
  - zsh
  - oh-my-zsh
    - zsh-autosuggestions
    - fast-syntax-highlighting
    - git
    - direnv
  - starship
  - direnv
  - astronvim
    - neovim
  - tmux
    - plugins/scripts/dracula.sh
      tmux set-window-option -g window-status-format ""
      tmux set-window-option -g window-status-current-format ""
- lang
  - python
    - pyenv
    - uv
  - node
    - nvm
  - rust
    - sccache
  - go
  - c cpp
    - gcc
    - clang
- pacakges
- secret
  - ssh
  - bitwarden
  - 1password
- home
  - dotfiles
    .zshrc
    .zshenv
    .bashrc
    .profile
    .bash_profile
  - config
    .zshenv  EDITOR
    .zprofile  PATH
    .zshrc  alias functions prompt setopt unsetopt key_bindings oh-my-zsh-plugins
    .bashenv
    .bash_profile
    .bashrc
    .profile
    .gitconfig
    .ssh/config
    .config/systemd/user/redis.conf
    .config/uv/uv.toml
  - opt
    - supervisor
    - redis
  - lang
    - python
    - rust
    - go
  - repo
    - private
    - github
  - tmp
