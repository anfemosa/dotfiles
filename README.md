# dotfiles

Personal shell configuration managed with [homeshick](https://github.com/andsens/homeshick). Primary shell is zsh with bash compatibility.

## Bootstrap a Machine

```bash
# install homeshick
git clone https://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick

# clone the dotfiles
$HOME/.homesick/repos/homeshick/bin/homeshick clone anfemosa/dotfiles

# reproduce the tracked links
$HOME/.homesick/repos/homeshick/bin/homeshick link dotfiles

# install core dependencies
bash ~/.dotfiles/install.sh
```

## Usage

```bash
# load homeshick (auto-loaded via .bashrc/.zshrc)
source ~/.homesick/repos/homeshick/homeshick.sh

# track a file
homeshick track dotfiles .bashrc

# commit and push
homeshick cd dotfiles
git commit -m "Added .bashrc file"
git push origin master
```

## Shell Initialization Flow

```
.zshrc / .bashrc
    └── .init_shell (shared config)
            ├── Color definitions
            ├── Eternal history
            └── Sources ~/.dotfiles/ modules:
                    ├── system.sh  - Core aliases (lsd, bat, dev shortcuts)
                    ├── git.sh     - Git aliases
                    ├── docker.sh  - Docker/ROS build & run (rocker)
                    └── ros.sh     - ROS workspace management
```

## Core Dependencies

Auto-installed by `bash ~/.dotfiles/install.sh` (idempotent, Debian/Ubuntu):

| Tool | Method | Description |
|------|--------|-------------|
| [ripgrep](https://github.com/BurntSushi/ripgrep) | apt | Fast recursive search |
| [fd-find](https://github.com/sharkdp/fd) | apt | Fast file finder |
| [bat](https://github.com/sharkdp/bat) | apt | cat with syntax highlighting |
| [trash-cli](https://github.com/andreafrancia/trash-cli) | apt | Safe rm replacement |
| [direnv](https://github.com/direnv/direnv) | apt | Per-directory env vars |
| [shellcheck](https://github.com/koalaman/shellcheck) | apt | Shell script linter |
| [fzf](https://github.com/junegunn/fzf) | GitHub clone | Fuzzy finder |
| [lsd](https://github.com/lsd-rs/lsd) | GitHub release | Modern ls replacement |
| [gh](https://cli.github.com/) | Official apt repo | GitHub CLI |
| [glab](https://gitlab.com/gitlab-org/cli) | GitLab release | GitLab CLI |

## Zsh Plugins

Managed with [Antidote](https://github.com/mattmc3/antidote). Prompt by [Powerlevel10k](https://github.com/romkatv/powerlevel10k).

Key plugins: forgit, git-open, zsh-auto-notify, zsh-you-should-use, zsh-syntax-highlighting, zsh-autosuggestions.

## Key Patterns

- **Smart fallbacks**: `lsd` falls back to `ls`, `bat` to `cat` if not installed.
- **ROS auto-detection**: Functions in `docker.sh` and `ros.sh` detect ROS 1 vs 2 automatically.
- **Rocker integration**: `dockrun` uses [rocker](https://github.com/osrf/rocker) for GPU/X11/SSH in Docker.

## Optional Packages

### From apt

- AutoKey - Desktop automation utility (`sudo apt install "autokey*"`)
- copyq - Clipboard manager (`sudo apt install copyq`)
- imwheel - Mouse wheel translator (`sudo apt install imwheel`)
- meld - Graphical diff/merge tool (`sudo apt install meld`)
- recoll - Personal full text search (`sudo apt install recoll`)
- neovim - Refactored vim fork (`sudo apt install neovim`)

### Download from the web

- [Brave Browser](https://brave.com/es/linux/)
- [VSCode](https://code.visualstudio.com/)
- [AppImageLauncher](https://github.com/TheAssassin/AppImageLauncher)
- [Rclone](https://rclone.org/downloads/) - rsync for cloud storage
- [restic](https://github.com/restic/restic/releases) - Backup tool
- [Kdenlive](https://kdenlive.org/en/download/) - Video editor

### From Flatpak

```bash
flatpak install flathub <package>
```

- gimp, libre-office, telegram-desktop, PDFMixTool
