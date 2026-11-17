# Shell 启动文件

zsh 和 bash 先判定两种彼此独立的属性，再决定读哪些文件。系统级文件（`/etc`）与用户级文件（`$HOME`）成对出现，通常**先系统、后用户**；但登录退出时正好相反（**先用户、后系统**）。

---

## 1. 两种正交属性

**login / non-login** 与 **interactive / non-interactive** 是两条完全独立的轴，二者笛卡尔积产生 4 种组合。图形桌面已登录并不代表打开的终端就是 login shell（桌面管理器本身不是 shell）。

### 属性判定与特征对比

| 属性维度 | 判定条件（内部机制） | 状态检测命令 | 典型场景 | 决定加载的文件 |
| :--- | :--- | :--- | :--- | :--- |
| **Login**<br>（登录） | 参数 0 以 `-` 开头（如 `-zsh`），或启动时带 `-l` / `--login` | `zsh`: `[[ -o login ]]`<br>`bash`: `shopt -q login_shell` | 控制台 tty、SSH（无远程命令）、`su -`、`sudo -i`、macOS 终端默认窗口 | **zsh**: `zprofile`, `zlogin`, `zlogout`<br>**bash**: `/etc/profile`, `~/.bash_profile` 等, `bash_logout` |
| **Non-login**<br>（非登录） | 参数 0 无 `-`，且未指定 `-l` / `--login` | 同上（取反） | Linux 桌面终端新标签、终端内再次运行 `zsh`/`bash`、`su`（不带 `-`）、脚本、`ssh host cmd` | 不读上述所有登录和注销文件 |
| **Interactive**<br>（交互式） | 无 `-c` 且无脚本参数，且 stdin 和 stderr 均连接终端；或显式带 `-i` | `zsh`: `[[ -o interactive ]]`<br>`bash`: `[[ $- == *i* ]]`（同时设 `PS1`） | 在终端前敲命令的日常 Shell 环境 | **zsh**: `zshrc`<br>**bash**: `bashrc` |
| **Non-interactive**<br>（非交互式） | 运行脚本、带 `-c` 执行命令、后台管道、命令替换；stdin/stderr 未接终端 | 同上（取反） | 执行脚本（`./run.sh`）、`zsh -c`、`bash -c`、`ssh host cmd` | 不读 `zshrc` / `bashrc`；只读全局环境变量 |

### 四种组合场景与加载文件一览

| 组合模式 | 典型代表场景 | zsh 实际读取主文件（简略） | bash 实际读取主文件（简略） |
| :--- | :--- | :--- | :--- |
| **Interactive Login**<br>（交互登录） | SSH 登录、macOS 终端新建窗口、Linux 控制台 tty | `zshenv` → `zprofile` → `zshrc` → `zlogin` | `/etc/profile` → `~/.bash_profile`（在其中 source `~/.bashrc`） |
| **Interactive Non-login**<br>（交互非登录） | Linux 桌面终端新建 Tab、tmux/screen 新建窗格、会话内输入 `zsh`/`bash` | `zshenv` → `zshrc` | `~/.bashrc` |
| **Non-interactive Non-login**<br>（非交互非登录） | 运行脚本（`sh script.sh`）、`zsh -c`、`bash -c`、CI/CD 构建步骤 | 仅读 `zshenv`（每次都读） | 默认不读任何用户 dotfiles；仅当定义了 `$BASH_ENV` 时读取其指向的文件 |
| **Non-interactive Login**<br>（非交互登录） | `zsh -lc 'cmd'`、`bash -lc 'cmd'`、部分远程调度器 | `zshenv` → `zprofile` → `zlogin`（不读 `zshrc`） | `/etc/profile` → `~/.bash_profile`（不读 `~/.bashrc`，除非 profile 内显式 source） |

> **SSH 远程执行特例**：`ssh host cmd` 属于 Non-interactive Non-login。
> - **zsh**：仅读 `/etc/zshenv` 和 `~/.zshenv`。
> - **bash**：源码中检测到输入连接网络（sshd）时，会特例额外读取 `~/.bashrc`（以 `sh` 启动时无此特例）。

---

## 2. 系统级 `/etc` 路径跨发行版对比

`/etc` 下的具体路径由编译 shell 时的参数决定。下表中 Fedora 为本机（Fedora 44 WSL，zsh 5.9，bash 5.3）实测验证值：

| 文件类别 | Fedora / RHEL / CentOS | Debian / Ubuntu | Arch Linux | macOS |
| :--- | :--- | :--- | :--- | :--- |
| **zshenv** | `/etc/zshenv` | `/etc/zsh/zshenv` | `/etc/zsh/zshenv` | `/etc/zshenv` |
| **zprofile** | `/etc/zprofile` | `/etc/zsh/zprofile` | `/etc/zsh/zprofile` | `/etc/zprofile` |
| **zshrc** | `/etc/zshrc` | `/etc/zsh/zshrc` | `/etc/zsh/zshrc` | `/etc/zshrc` |
| **zlogin** | `/etc/zlogin` | `/etc/zsh/zlogin` | `/etc/zsh/zlogin` | `/etc/zlogin` |
| **zlogout** | `/etc/zlogout` | `/etc/zsh/zlogout` | `/etc/zsh/zlogout` | `/etc/zlogout` |
| **profile** | `/etc/profile` | `/etc/profile` | `/etc/profile` | `/etc/profile` |
| **bashrc** | `/etc/bashrc`（通过脚本引入） | `/etc/bash.bashrc`（二进制直接读） | `/etc/bash.bashrc`（二进制直接读） | 无系统 bashrc |
| **bash 退出** | `/etc/bash.bash_logout`（二进制会找） | `/etc/bash.bash_logout` | `/etc/bash.bash_logout` | 通常无 |

---

## 3. Zsh 加载顺序

Zsh 由二进制直接驱动，逻辑正交严谨。`$ZDOTDIR` 未设置时默认使用 `$HOME`。
- `-f`（`NO_RCS`）：除 `/etc/zshenv` 外，跳过后续所有初始化文件。
- `-d`（`NO_GLOBAL_RCS`）：跳过后续所有 `/etc` 系统文件，但用户文件照常加载。

### 二进制内建加载顺序表

| 步骤 | 加载时机 | 系统文件（`/etc`） | 用户文件（`$ZDOTDIR` / `~`） | 控制开关与特征 |
| :---: | :--- | :--- | :--- | :--- |
| **1** | 任何启动（无条件必读） | `/etc/zshenv` | `~/.zshenv` | `/etc/zshenv` 不可跳过（`-f` 也读）；全局环境变量 |
| **2** | 仅 Login Shell | `/etc/zprofile` | `~/.zprofile` | 在 `zshrc` 之前执行；重型环境、PATH 初始化 |
| **3** | 仅 Interactive Shell | `/etc/zshrc` | `~/.zshrc` | 提示符、别名、补全、快捷键绑定、插件管理器 |
| **4** | 仅 Login Shell（收尾） | `/etc/zlogin` | `~/.zlogin` | 在 `zshrc` 之后执行；欢迎信息、启动任务 |
| **5** | 仅 Login Shell 退出时 | `/etc/zlogout` | `~/.zlogout` | **注意：顺序反转**，先读用户 `~/.zlogout`，再读系统 `/etc/zlogout` |

### 各使用场景下 Zsh 执行流程对比

| 场景 | 执行步骤顺序（二进制内建链） |
| :--- | :--- |
| **交互登录**（如 SSH、终端首个窗口） | `1. /etc/zshenv` $\to$ `2. ~/.zshenv` $\to$ `3. /etc/zprofile` $\to$ `4. ~/.zprofile` $\to$ `5. /etc/zshrc` $\to$ `6. ~/.zshrc` $\to$ `7. /etc/zlogin` $\to$ `8. ~/.zlogin` |
| **交互非登录**（如桌面终端新标签） | `1. /etc/zshenv` $\to$ `2. ~/.zshenv` $\to$ `3. /etc/zshrc` $\to$ `4. ~/.zshrc` |
| **脚本 / 非交互**（`script.sh`, `zsh -c`） | `1. /etc/zshenv` $\to$ `2. ~/.zshenv` |
| **会话退出**（退出登录 Shell 时） | `1. ~/.zlogout` $\to$ `2. /etc/zlogout`（`exec` 替换进程时不执行） |

### Fedora 系统脚本嵌套 source 连锁表

除二进制直接读入的文件外，Fedora 的 `/etc` 配置脚本还会级联引入 POSIX / Bash 兼容环境：

| 触发入口 | 内部行为与调用链 | 目的与约束说明 |
| :--- | :--- | :--- |
| `/etc/zprofile` | `emulate -L ksh` $\to$ `source /etc/profile` $\to$ `source /etc/profile.d/*.sh` | 导入系统通用的 PATH 与环境变量；zsh 下不会连锁进入 `/etc/bashrc` |
| `/etc/zshrc` | 检查 `if [[ ! -o login ]]` $\to$ `source /etc/profile.d/*.sh` | **仅非登录时**补充加载 `profile.d`（登录时已由 zprofile 载入，避免重复加载） |
| `/etc/zlogout` | `command -v clear &> /dev/null && clear` | 退出登录会话时自动清屏 |

---

## 4. Bash 加载顺序

Bash 机制历史较久，采用“三选一”互斥回退逻辑，且不同发行版对 `/etc/bashrc` 的处理差异很大。

### 二进制内建加载规则表

| 启动模式 | 涉及配置文件 | 选取与执行规则 |
| :--- | :--- | :--- |
| **Login Shell**<br>（含 `--login`） | `/etc/profile`<br>`~/.bash_profile`<br>`~/.bash_login`<br>`~/.profile` | 1. 先读 `/etc/profile`。<br>2. 用户文件**三选一**：仅读取 `~/.bash_profile`、`~/.bash_login`、`~/.profile` 中**第一个存在且可读**的文件，后续忽略。<br>3. `--noprofile` 参数可跳过全部。 |
| **Interactive Non-login**<br>（交互非登录） | `/etc/bash.bashrc`（Debian/Arch 等）<br>`~/.bashrc` | 1. Debian/Arch 等编译有系统 bashrc，先读 `/etc/bash.bashrc`。<br>2. 读取 `~/.bashrc`。<br>3. `--norc` 可跳过；`--rcfile <file>` 可替换 `~/.bashrc`。 |
| **Non-interactive**<br>（脚本执行） | `$BASH_ENV` 指向的文件 | 不读任何系统或用户 dotfiles；仅当环境变量 `BASH_ENV` 有值时，展开并 source 对应路径。 |
| **以 `sh` 启动的 Login** | `/etc/profile` $\to$ `~/.profile` | 模拟传统 sh 行为，只认 `~/.profile`，跳过 bash 专属文件。 |
| **以 `sh` 或 `--posix` 交互** | `$ENV` 指向的文件 | POSIX 模式，不读 `bashrc`，仅读取 `$ENV` 展开的文件。 |
| **会话退出** | `~/.bash_logout`<br>`/etc/bash.bash_logout` | 先读用户 `~/.bash_logout`，后读系统 `/etc/bash.bash_logout`。 |

### 常见发行版实际执行链对比

| 发行版与场景 | 实际嵌套执行顺序 |
| :--- | :--- |
| **Fedora 交互登录** | `1. /etc/profile` $\to$ `2. /etc/profile.d/*.sh` $\to$ `3. /etc/bashrc` $\to$ `4. ~/.bash_profile` $\to$ `5. ~/.bashrc`（在 bashrc 再次引用 `/etc/bashrc` 时被防护变量跳过） |
| **Fedora 交互非登录** | `1. ~/.bashrc` $\to$ `2. /etc/bashrc` $\to$ `3. /etc/profile.d/*.sh` |
| **Debian/Ubuntu 交互登录** | `1. /etc/profile` $\to$ `2. /etc/profile.d/*.sh` $\to$ `3. ~/.bash_profile`（或 fallback 到 `~/.profile`，并在其中显式 source `~/.bashrc`） |
| **Debian/Ubuntu 交互非登录**| `1. /etc/bash.bashrc`（二进制直接执行） $\to$ `2. ~/.bashrc` |

---

## 5. Zsh 与 Bash 横向综合对比

| 对比维度 | Zsh 体系 | Bash 体系 | 核心设计差异说明 |
| :--- | :--- | :--- | :--- |
| **全局无条件文件** | `/etc/zshenv`<br>`~/.zshenv` | 无直接对应<br>（脚本需依赖 `$BASH_ENV`） | Zsh 无论运行脚本、命令替换还是交互都会读 `zshenv`；Bash 脚本默认完全隔离用户环境。 |
| **登录环境初始化** | `/etc/zprofile`<br>`~/.zprofile` | `/etc/profile`<br>`~/.bash_profile`（或 `~/.profile`） | Zsh 固定按链条加载；Bash 在用户端使用三选一互斥逻辑。 |
| **交互配置** | `/etc/zshrc`<br>`~/.zshrc` | Fedora: 经由 profile/bashrc 引入 `/etc/bashrc`<br>Debian: `/etc/bash.bashrc`<br>用户端: `~/.bashrc` | 两者功能完全对等，用于存放 prompt、alias、键位、补全与函数。 |
| **登录收尾阶段** | `/etc/zlogin`<br>`~/.zlogin` | 无内建对应文件 | Zsh 独有两段式登录设计（`zprofile` 在 rc 之前，`zlogin` 在 rc 之后）。 |
| **退出注销处理** | `~/.zlogout`<br>`/etc/zlogout` | `~/.bash_logout`<br>`/etc/bash.bash_logout` | 两者机制完全一致，退出时均为**先用户、后系统**。 |
| **跳过控制选项** | `-f`（跳过 RCS）<br>`-d`（跳过 GLOBAL_RCS） | `--noprofile`（跳过 profile）<br>`--norc`（跳过 rc） | 参数粒度与命名不同。 |

---

## 6. 配置项最佳归宿速查表

源文件在 `src/`，`chezmoi apply` 后落到家目录。当前入库的是 zsh。bash 的 `~/.bashrc`、`~/.bash_profile`、`~/.profile` 没有源文件。Windows 上这三份以及 `.zprofile`、`.zshenv`、`.zshrc` 被 `src/.chezmoiignore.tmpl` 忽略。

### zsh

| 配置类别 | 放置文件 | 生效范围 | 本仓库 |
| :--- | :--- | :--- | :--- |
| **每次启动都要有的变量** | `~/.zshenv` | 四种组合都会读，包括 `zsh -c` 和 zsh 脚本 | `src/dot_zshenv` → `~/.zshenv`：`export EDITOR="vi"`。文件存在时再 source `~/.local/bin/env` 和 `~/.cargo/env`。`src/dot_local/bin/env` 把 `$HOME/.local/bin` 加到 `PATH` 前面。这里没有 `echo`。 |
| **只在 login 做的 PATH** | `~/.zprofile` | login。macOS 终端每次新窗口都会走到；Linux 桌面新标签通常不会 | 没有 `src/dot_zprofile`。`~/.local/bin` 和 cargo 放在 `~/.zshenv`，非 login、非交互的 zsh 也能看见。 |
| **别名、函数、提示符、补全、插件** | `~/.zshrc` | 只在 interactive | `src/dot_zshrc` → `~/.zshrc`。Oh My Zsh，`plugins=(git mise zsh-autosuggestions fast-syntax-highlighting)`。同文件还有 `eval "$(mise activate zsh)"`、`uv` / `uvx` 补全、`eval "$(starship init zsh)"`、`source <(fzf --zsh)`、`export RUSTC_WRAPPER`（`sccache`）、`brew shellenv` 与 `HOMEBREW_NO_AUTO_UPDATE=1`。别名：`astronvim`、`nvide`，没有 `vim` 时 `vim=vi`。函数：`set_proxy`、`unset_proxy`（按 WSL `networkingMode` 选主机代理）。末尾若存在则 `source ~/.envrc`。`PNPM_HOME` 在这里追加到 `PATH` 末尾，排在 mise 后面。 |
| **提示符主题文件** | `~/.config/starship.toml`，由 `~/.zshrc` 里的 `starship init` 读入 | 随 starship 初始化 | 不入库。`src/.chezmoiscripts/run_onchange_linux-install-packages.sh.tmpl` 执行 `starship preset plain-text-symbols -o ~/.config/starship.toml`。`src/dot_config/mise/config.toml` 里 `starship = "latest"`。 |
| **全系统登录环境** | `/etc/profile.d/<name>.sh`（Fedora 上由 `/etc/zprofile` source `/etc/profile` 带入） | login | chezmoi 不改 `/etc/profile.d`。代理留在 `~/.zshrc` 的 `set_proxy`，手动调用，登录时不会自动导出。 |
| **login 收尾** | `~/.zlogin` | login，且在 `~/.zshrc` 之后。写在这里的设置盖过 zshrc | 没有 `src/dot_zlogin`。 |
| **login 退出** | `~/.zlogout`，然后 `/etc/zlogout` | login 正常退出（`exit`、读到 EOF）。`exec` 换进程时不读 | 没有 `src/dot_zlogout`。Fedora 的 `/etc/zlogout` 会 `clear`。 |

### bash

| 配置类别 | 放置文件 | 生效范围 | 本仓库 |
| :--- | :--- | :--- | :--- |
| **每次启动都要有的变量** | 没有与 `~/.zshenv` 对等的文件。login 放 `~/.bash_profile`（否则 `~/.bash_login`，再否则 `~/.profile`）。非交互脚本只读 `BASH_ENV` 指向的路径 | login 读 profile 那一组；脚本只看 `BASH_ENV` | 没有这些源文件，也没有设置 `BASH_ENV`。 |
| **只在 login 做的 PATH** | `~/.bash_profile` | login，含 `bash -lc`。三者里它排第一，文件在则 `~/.profile` 整份不执行 | 没有 `src/dot_bash_profile`。Fedora skel 的 `~/.bash_profile` 会 source `~/.bashrc`。 |
| **别名、函数、提示符、补全** | `~/.bashrc` | interactive，且不是 login 时由二进制直接读。login 要在 `~/.bash_profile` 里 source 它才会执行 | 没有 `src/dot_bashrc`。对应的 zsh 内容在 `src/dot_zshrc`。Fedora 上 `~/.bashrc` 还负责 source `/etc/bashrc`。 |
| **提示符主题文件** | `PS1` 写在 `~/.bashrc`。若用 starship，在 `~/.bashrc` 里 `eval "$(starship init bash)"`，主题仍是 `~/.config/starship.toml` | interactive | 仓库只接了 zsh：`src/dot_zshrc` 里是 `eval "$(starship init zsh)"`。主题文件由 `starship preset plain-text-symbols -o ~/.config/starship.toml` 生成。 |
| **全系统登录环境** | `/etc/profile.d/<name>.sh` | login 时由 `/etc/profile` 读入。Fedora 的非 login 交互 bash 再由 `/etc/bashrc` 读一次 | chezmoi 不改 `/etc/profile.d`。 |
| **login 收尾** | 写在 `~/.bash_profile` 末尾（source `~/.bashrc` 之后） | login | 没有 `src/dot_bash_profile`。 |
| **login 退出** | `~/.bash_logout`，然后 `/etc/bash.bash_logout` | login 正常退出。本机二进制会找系统文件，但文件不存在 | 没有 `src/dot_bash_logout`。 |
| **不要当成启动文件** | 没有 `~/.bashenv`。非交互要注入时设置 `BASH_ENV`。以 `sh` 运行的交互壳看 `ENV` | 仅当变量有值 | 仓库里没有这份文件，也没有设置 `BASH_ENV` 或 `ENV`。 |

---

## 7. 外部关联文件对比

以下文件不直接属于 Zsh/Bash 二进制内建链条，但在会话生命周期中常被触发或混淆：

| 文件路径 | 读取机制与驱动者 | 文件语法格式 | 作用说明与差异 |
| :--- | :--- | :--- | :--- |
| `/etc/environment` | PAM 模块（`pam_env.so`）在登录认证前读取 | 纯 `KEY=DEFAULT` 键值对（**非 shell 脚本**） | 全局环境设置，不支持变量替换与循环；图形登录、SSH、sudo 均受其影响。 |
| `~/.pam_environment` | PAM 用户级配置文件 | 纯键值对 | **已废弃**（因安全隐患主流 Linux 发行版已禁用）。 |
| `/etc/inputrc`<br>`~/.inputrc` | GNU Readline 库 | Readline 专用指令格式 | **Bash** 用于命令行编辑键位与行为；**Zsh** 默认使用内置的 ZLE，不读取此文件。 |
| `~/.bashrc.d/*.sh` | Fedora/RHEL 在 `~/.bashrc` 中通过 shell 循环引入 | Shell 脚本片段 | 模块化管理 bash 交互配置；只有用户 bashrc 编写了遍历逻辑才会生效。 |
| `~/.bash_aliases` | Debian/Ubuntu 在 `~/.bashrc` 中预留判断引入 | Shell 脚本片段 | 放置用户别名；本质只是 `~/.bashrc` 的拆分文件。 |
