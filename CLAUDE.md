# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal shell configuration files managed with [homeshick](https://github.com/andsens/homeshick). Primary shell is zsh with bash compatibility maintained.

## Commands

### Validation
```bash
# Syntax check all shell files
shellcheck home/.bashrc home/.zshrc home/.init_shell home/.dotfiles/*.sh

# Test configuration loading
zsh -c "source home/.zshrc && echo 'ZSH OK'"
bash -c "source home/.bashrc && echo 'BASH OK'"

# Verify homeshick setup
$HOME/.homesick/repos/homeshick/bin/homeshick check
```

### Adding New Files
```bash
homeshick track dotfiles <filename>
homeshick cd dotfiles
```

## Architecture

### Shell Initialization Flow
```
.zshrc/.bashrc
    └── .init_shell (shared by both shells)
            ├── Color code definitions
            ├── History configuration (eternal history)
            └── Sources .dotfiles/ modules:
                    ├── system.sh  - Core aliases (lsd, bat, dev shortcuts)
                    ├── git.sh     - Git aliases
                    ├── docker.sh  - Docker/ROS build/run functions
                    └── ros.sh     - ROS workspace management
```

### Key Patterns

**Smart fallbacks**: Tools like `lsd` and `bat` fall back to `ls` and `cat` if not installed.

**ROS version detection**: Functions in `docker.sh` and `ros.sh` auto-detect ROS_VERSION (1 vs 2) and use appropriate commands (catkin vs colcon, devel vs install directories).

**Rocker integration**: `dockrun` uses [rocker](https://github.com/osrf/rocker) for GPU/X11/SSH sharing in Docker containers.

### Plugin Management

Zsh plugins are managed with [Antidote](https://github.com/mattmc3/antidote) via `.zsh_plugins.txt`. Powerlevel10k provides the prompt with instant prompt caching.

## Development Guidelines

See **AGENTS.md** for detailed code style, security requirements, and testing procedures.

Key points:
- 4-space indentation, no tabs
- snake_case for functions, UPPER_CASE for exports
- Always validate with shellcheck before committing
- Test changes in both zsh and bash
- Add new tools as modules in `.dotfiles/` directory
