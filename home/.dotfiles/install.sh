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

APT_PACKAGES=(ripgrep fd-find fzf bat trash-cli direnv)
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
    ARCH=$(dpkg --print-architecture)
    LSD_VERSION=$(curl -s https://api.github.com/repos/lsd-rs/lsd/releases/latest | grep '"tag_name"' | sed 's/.*"v\(.*\)".*/\1/')

    if [ -z "$LSD_VERSION" ]; then
        error "Failed to fetch lsd latest version from GitHub"
        exit 1
    fi

    LSD_DEB="lsd_${LSD_VERSION}_${ARCH}.deb"
    LSD_URL="https://github.com/lsd-rs/lsd/releases/download/v${LSD_VERSION}/${LSD_DEB}"

    TMP_DIR=$(mktemp -d)
    trap 'rm -rf "$TMP_DIR"' EXIT

    curl -sL -o "${TMP_DIR}/${LSD_DEB}" "$LSD_URL"
    curl -sL -o "${TMP_DIR}/checksums.txt" "https://github.com/lsd-rs/lsd/releases/download/v${LSD_VERSION}/lsd-v${LSD_VERSION}-checksums.txt"
    cd "${TMP_DIR}" && sha256sum -c --ignore-missing checksums.txt
    sudo dpkg -i "${TMP_DIR}/${LSD_DEB}"
    info "lsd ${LSD_VERSION} installed"
fi

echo -e "\n${GREEN}All core dependencies are installed.${NC}"
