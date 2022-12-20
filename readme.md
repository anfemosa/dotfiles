# dotfiles

## What is this

A backup of my dot and config files using [homeshick](https://github.com/andsens/homeshick)

## Bootstrap a machine

``` bash
git clone https://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
$HOME/.homesick/repos/homeshick/bin/homeshick clone anfemosa/dotfiles
```

## Usage

``` bash
source ~/.homesick/repos/homeshick/homeshick.sh
homeshick track dotfiles .bashrc
homeshick cd dotfiles
git commit -m "Added .bashrc file"
git push origin master
```

## Others packages

Some useful applications:

### From apt

- AutoKey - Desktop automation utility for Linux and X11. --> ***sudo apt install "autokey*"***
- copyq - Clipboard Manager with Advanced Features. --> ***sudo apt install copyq***
- imwheel - Universal  mouse  wheel  and  button  translator for the X Windows System. --> ***sudo apt install imwheel***
- meld - Graphical tool to diff and merge files. --> ***sudo apt install meld***
- recoll - Personal full text search package. --> ***sudo apt install recoll***
- neovim - Heavily refactored vim fork. --> ***sudo apt install neovim***
- ripgrep - Line-oriented search tool that recursively searches the current. --> ***sudo apt install ripgrep***
- trash-cli - Command Line Interface to FreeDesktop.org Trash. --> ***sudo apt install trash-cli***
- [trash-cli](https://github.com/andreafrancia/trash-cli)

### Download from the website

- [docfetcher](https://sourceforge.net/projects/docfetcher/): Desktop search application.
- [freeplane-mindmapping](https://sourceforge.net/projects/freeplane/): Application for Mind Mapping, Knowledge Management, Project Management.
- [Albert launcher](https://albertlauncher.github.io/installing/): Desktop agnostic launcher.
- [Davmail](http://davmail.sourceforge.net/): POP/IMAP/SMTP/Caldav/Carddav/LDAP Exchange and Office 365 Gateway.
- [fd](https://github.com/sharkdp/fd): simple, fast and user-friendly alternative to find.

- [VSCode](https://code.visualstudio.com/): VS Code.
- [VSCodium](https://vscodium.com/): Free/Libre Open Source Software Binaries of VS Code.
- [Microsoft Teams](https://www.microsoft.com/en-us/microsoft-teams/download-app#allDevicesSection)

- AppImageLauncher: makes your Linux desktop AppImage ready -->

``` bash
sudo add-apt-repository ppa:appimagelauncher-team/stable
sudo apt update
sudo apt install appimagelauncher
```

- [ShellCheck](https://github.com/koalaman/shellcheck): A static analysis tool for shell scripts

- [GitAhead is a graphical Git client](https://gitahead.github.io/gitahead.com/)
- [FreeFileSync](https://freefilesync.org/)
- [Rclone - rsync for cloud storage](https://rclone.org/downloads/): can mount OneDrive using FUSE
- [yEd - Graph Editor](https://www.yworks.com/products/yed)
- [PlantUML](https://plantuml.com/)
- [Kdenlive video editor](https://kdenlive.org/en/download/) (AppImage)
- [restic bacup](https://github.com/restic/restic/releases)
- [ngrok](https://ngrok.com/):  secure introspectable tunnels to localhost.

- [asciinema edit](https://github.com/cirocosta/asciinema-edit): Auxiliary tools for dealing with ASCIINEMA casts.

### From snapcraft

``` bash
sudo apt update
sudo apt install snapd
```

- spotify
- docfetcher ***sudo snap install docfetcher***

### From Flatpak

- gimp
- libre-office
