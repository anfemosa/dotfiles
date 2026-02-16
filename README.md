# dotfiles

Personal shell configuration managed with [homeshick](https://github.com/andsens/homeshick). Primary shell is zsh with bash compatibility.

## Quick Start

```bash
# Clone with homeshick
homeshick clone <your-user>/dotfiles

# Install dependencies
bash ~/.dotfiles/install.sh

# Restart shell
exec zsh
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

## Installed Tools

The `install.sh` script installs the following (idempotent, Debian/Ubuntu):

| Tool | Method | Description |
|------|--------|-------------|
| ripgrep | apt | Fast recursive search |
| fd-find | apt | Fast file finder |
| bat | apt | cat with syntax highlighting |
| trash-cli | apt | Safe rm replacement |
| direnv | apt | Per-directory env vars |
| shellcheck | apt | Shell script linter |
| fzf | GitHub clone | Fuzzy finder |
| lsd | GitHub release | Modern ls replacement |
| gh | Official apt repo | GitHub CLI |
| glab | GitLab release | GitLab CLI |

## Zsh Plugins

Managed with [Antidote](https://github.com/mattmc3/antidote). Prompt by [Powerlevel10k](https://github.com/romkatv/powerlevel10k).

Key plugins: forgit, git-open, zsh-auto-notify, zsh-you-should-use, zsh-syntax-highlighting, zsh-autosuggestions.

## Key Patterns

- **Smart fallbacks**: `lsd` falls back to `ls`, `bat` to `cat` if not installed.
- **ROS auto-detection**: Functions in `docker.sh` and `ros.sh` detect ROS 1 vs 2 automatically.
- **Rocker integration**: `dockrun` uses [rocker](https://github.com/osrf/rocker) for GPU/X11/SSH in Docker.
