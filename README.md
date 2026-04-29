# dotfiles

## install

```sh
git clone <your-repo-url> ~/.local/share/chezmoi
cd ~/.local/share/chezmoi

./bootstrap.sh

chezmoi init --apply
```

If you need a proxy for the first apply:

```sh
HTTP_PROXY=socks5://127.0.0.1:4067 \
HTTPS_PROXY=socks5://127.0.0.1:4067 \
ALL_PROXY=socks5://127.0.0.1:4067 \
chezmoi apply
```

Later updates:

```sh
make apply
```

## bootstrap model

- `bootstrap.sh` installs the minimum prerequisites: `git`, `curl`, `mise`, `chezmoi`
- `chezmoi` manages dotfiles and orchestration scripts
- OS package managers install system libraries and build dependencies
- `mise` manages language runtimes and developer tools declaratively

## orchestration

- `src/.chezmoiscripts/sh/run_once_01-system-deps.sh` installs system packages and build dependencies, including `supervisor`
- `src/.chezmoiscripts/sh/run_once_03-install-mise.sh` installs `mise`
- `src/.chezmoiscripts/sh/run_after_install_04-mise-tools.sh.tmpl` runs `mise install` after apply and tracks `mise` config changes
- `src/.chezmoiscripts/sh/run_onchange_install_11-python.sh` installs Python CLI tools via `mise exec -- uv`

## runtime management

- Core runtimes are pinned to stable major/minor versions in `src/dot_config/mise/config.toml`
- Current defaults: `python 3.12`, `node 22`, `go 1.24`, `rust 1.86`
- Leaf CLI tools can stay on `latest`

## managed components

- Shell: `zsh`, `oh-my-zsh`, `zsh-autosuggestions`, `fast-syntax-highlighting`, `direnv`, `starship`
- Editors and terminal tools: `neovim`, AstroNvim, `tmux`, `lazygit`, `yazi`
- Runtimes: Python with `uv`, Node.js, Rust with `sccache`, Go, C/C++ toolchains
- Services and local tooling: `supervisor`, Redis, SSH config, Git config
- Home layout and workspace directories: `~/repo`, `~/lang`, `~/tmp`, `~/etc`, `~/opt`, `~/ws/workspace`

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
    - mise
    - uv
  - node
    - mise
  - rust
    - mise
    - sccache
  - go
    - mise
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
