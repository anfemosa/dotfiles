#!/bin/bash
set -euo pipefail

# install.sh - Idempotent installer for core shell dependencies
# Usage: bash ~/.dotfiles/install.sh

# Colors
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
NC='\e[0m'

info()  { echo -e "${GREEN}[OK]${NC} $1"; }
warn()  { echo -e "${YELLOW}[SKIP]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check package manager
if ! command -v apt-get &> /dev/null; then
    error "apt-get not found. Only Debian/Ubuntu systems are supported."
    exit 1
fi

# --- apt packages ---

APT_PACKAGES=(ripgrep fd-find bat trash-cli direnv shellcheck tmux)
TO_INSTALL=()

for pkg in "${APT_PACKAGES[@]}"; do
    if dpkg -s "$pkg" &> /dev/null; then
        info "$pkg already installed"
    else
        TO_INSTALL+=("$pkg")
    fi
done

if [ ${#TO_INSTALL[@]} -gt 0 ]; then
    echo -e "\nInstalling apt packages: ${TO_INSTALL[*]}"
    sudo apt-get update -qq
    sudo apt-get install -y -qq "${TO_INSTALL[@]}"
    info "apt packages installed"
else
    info "All apt packages already installed"
fi

# --- fzf (from GitHub) ---

if [ -d "$HOME/.fzf" ] && command -v fzf &> /dev/null; then
    info "fzf already installed"
else
    echo -e "\nInstalling fzf from GitHub..."
    if [ -d "$HOME/.fzf" ]; then
        warn "$HOME/.fzf directory exists but fzf command not found, reinstalling..."
        rm -rf "$HOME/.fzf"
    fi
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --key-bindings --completion --no-update-rc
    info "fzf installed from GitHub"
fi

# --- Debian name variants: create symlinks if needed ---

# fd-find installs as fdfind
if command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
    mkdir -p "$HOME/.local/bin"
    ln -s "$(which fdfind)" "$HOME/.local/bin/fd"
    info "Created symlink: fd -> fdfind"
fi

# bat installs as batcat
if command -v batcat &> /dev/null && ! command -v bat &> /dev/null; then
    mkdir -p "$HOME/.local/bin"
    ln -s "$(which batcat)" "$HOME/.local/bin/bat"
    info "Created symlink: bat -> batcat"
fi

# --- lsd (from GitHub release) ---

if command -v lsd &> /dev/null; then
    info "lsd already installed"
else
    echo -e "\nInstalling lsd from GitHub..."
    ARCH=$(uname -m)
    LSD_VERSION=$(curl -s https://api.github.com/repos/lsd-rs/lsd/releases/latest | grep '"tag_name"' | sed 's/.*"v\(.*\)".*/\1/')

    if [ -z "$LSD_VERSION" ]; then
        error "Failed to fetch lsd latest version from GitHub"
        exit 1
    fi

    LSD_TAR="lsd-v${LSD_VERSION}-${ARCH}-unknown-linux-musl.tar.gz"
    LSD_URL="https://github.com/lsd-rs/lsd/releases/download/v${LSD_VERSION}/${LSD_TAR}"

    TMP_DIR=$(mktemp -d)
    trap 'rm -rf "$TMP_DIR"' EXIT

    if curl -sL -o "${TMP_DIR}/${LSD_TAR}" "$LSD_URL"; then
        tar -xzf "${TMP_DIR}/${LSD_TAR}" -C "${TMP_DIR}"
        mkdir -p "$HOME/.local/bin"
        cp "${TMP_DIR}/lsd-v${LSD_VERSION}-${ARCH}-unknown-linux-musl/lsd" "$HOME/.local/bin/lsd"
        chmod +x "$HOME/.local/bin/lsd"
        info "lsd ${LSD_VERSION} installed to ~/.local/bin/lsd"
    else
        error "Failed to download lsd from $LSD_URL"
        rm -rf "$TMP_DIR"
        exit 1
    fi
fi

# --- gh (GitHub CLI, from official apt repo) ---

if command -v gh &> /dev/null; then
    info "gh (GitHub CLI) already installed"
else
    echo -e "\nInstalling gh (GitHub CLI)..."
    sudo mkdir -p -m 755 /etc/apt/keyrings
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt-get update -qq
    sudo apt-get install -y -qq gh
    info "gh (GitHub CLI) installed"
fi

# --- glab (GitLab CLI, from GitHub release) ---

if command -v glab &> /dev/null; then
    info "glab (GitLab CLI) already installed"
else
    echo -e "\nInstalling glab (GitLab CLI) from GitHub..."
    ARCH=$(uname -m)
    GLAB_VERSION=$(curl -s https://api.github.com/repos/gitlab-org/cli/releases/latest | grep '"tag_name"' | sed 's/.*"v\(.*\)".*/\1/')

    if [ -z "$GLAB_VERSION" ]; then
        error "Failed to fetch glab latest version from GitHub"
        exit 1
    fi

    case "$ARCH" in
        x86_64)  GLAB_ARCH="Linux_x86_64" ;;
        aarch64) GLAB_ARCH="Linux_arm64" ;;
        *)       error "Unsupported architecture: $ARCH"; exit 1 ;;
    esac

    GLAB_TAR="glab_${GLAB_VERSION}_${GLAB_ARCH}.tar.gz"
    GLAB_URL="https://gitlab.com/gitlab-org/cli/-/releases/v${GLAB_VERSION}/downloads/${GLAB_TAR}"

    TMP_DIR=$(mktemp -d)
    trap 'rm -rf "$TMP_DIR"' EXIT

    if curl -sL -o "${TMP_DIR}/${GLAB_TAR}" "$GLAB_URL"; then
        tar -xzf "${TMP_DIR}/${GLAB_TAR}" -C "${TMP_DIR}"
        mkdir -p "$HOME/.local/bin"
        cp "${TMP_DIR}/bin/glab" "$HOME/.local/bin/glab"
        chmod +x "$HOME/.local/bin/glab"
        info "glab ${GLAB_VERSION} installed to ~/.local/bin/glab"
    else
        error "Failed to download glab from $GLAB_URL"
        rm -rf "$TMP_DIR"
        exit 1
    fi
fi

echo -e "\n${GREEN}All core dependencies are installed.${NC}"
