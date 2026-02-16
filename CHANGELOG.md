# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- `pipx` to apt packages and new pipx section in install.sh for `rocker`, `vcs2l`, and `bandit`.
- `gh` (GitHub CLI) to install.sh via official GitHub apt repository.
- `glab` (GitLab CLI) to install.sh via GitLab release binaries.
- `shellcheck` to install.sh apt packages.

### Fixed
- lsd install to use tarball instead of .deb for dpkg zstd compatibility.
- lsd installation to use updated package name and improve error handling.
- fzf installed from GitHub instead of apt for latest version.

### Changed
- Refactored shell configuration for better portability and DRY.

### Added
- Automated dependency installer (`install.sh`).
