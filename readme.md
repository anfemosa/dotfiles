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

### Download from the website

- [docfetcher](https://sourceforge.net/projects/docfetcher/): Desktop search application.
- [freeplane-mindmapping](https://sourceforge.net/projects/freeplane/): Application for Mind Mapping, Knowledge Management, Project Management.
- [Albert launcher](https://albertlauncher.github.io/installing/): Desktop agnostic launcher.
- [Davmail](http://davmail.sourceforge.net/): POP/IMAP/SMTP/Caldav/Carddav/LDAP Exchange and Office 365 Gateway.
- [fd](https://github.com/sharkdp/fd): simple, fast and user-friendly alternative to find.
- [VSCodium](https://vscodium.com/): Free/Libre Open Source Software Binaries of VS Code.
- [FreeFileSync](https://freefilesync.org/)

- [GitAhead is a graphical Git client](https://gitahead.github.io/gitahead.com/)
- [Rclone - rsync for cloud storage](https://rclone.org/downloads/): can mount OneDrive using FUSE
- [OneDrive Client for Linux](https://github.com/abraunegg/onedrive)
- XMind
- SourceTrail

- [GitKraken Git GUI](https://www.gitkraken.com/git-client)
- [Foxit Reader](https://www.foxitsoftware.com/pdf-reader/)
- [yEd - Graph Editor](https://www.yworks.com/products/yed)
- [PlantUML](https://plantuml.com/)
- [trash-cli](https://github.com/andreafrancia/trash-cli)
- [Microsoft Teams](https://www.microsoft.com/en-us/microsoft-teams/download-app#allDevicesSection)
- [Kdenlive video editor](https://kdenlive.org/en/download/) (AppImage)
- [restic bacup](https://github.com/restic/restic/releases)
- [ShellCheck, a static analysis tool for shell scripts](https://github.com/koalaman/shellcheck)
- [ngrok - secure introspectable tunnels to localhost](https://ngrok.com/)

- [asciinema edit](https://github.com/cirocosta/asciinema-edit): Auxiliary tools for dealing with ASCIINEMA casts.

### From snapcraft

``` bash
sudo apt update
sudo apt install snapd
```

- spotify
- zotero-snap
- docfetcher ***sudo snap install docfetcher***

### From Flatpak

- gimp
- libre-office
