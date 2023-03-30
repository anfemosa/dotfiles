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

- [Brave Browser](https://brave.com/es/linux/): Yet another web browser
- [VSCode](https://code.visualstudio.com/): VS Code
- [ShellCheck](https://github.com/koalaman/shellcheck): A static analysis tool for shell scripts
- [Microsoft Teams](https://www.microsoft.com/en-us/microsoft-teams/download-app#allDevicesSection)
- [DB Browser for SQLite]
- [Dconf Editor]
- [SimpleScreenRecorder]
- [Terminator]
- [VLC]
- [XPad]

- [fd](https://github.com/sharkdp/fd): simple, fast and user-friendly alternative to find
- [AppImageLauncher](https://github.com/TheAssassin/AppImageLauncher): makes your Linux desktop AppImage ready -->

``` bash
sudo add-apt-repository ppa:appimagelauncher-team/stable
sudo apt update
sudo apt install appimagelauncher
```

- [checkingplaneitor](https://git.code.tecnalia.com:unai.antero/checkingplaneitor)
- [qpdf](https://github.com/qpdf/qpdf): command-line tool and C++ library that performs content-preserving transformations on PDF files
- [pdfmixtool](https://gitlab.com:scarpetta/pdfmixtool) v1.0.2 functional in Ubuntu 20.04
- [bat](https://github.com/sharkdp/bat.git)
- [lsd](https://github.com/Peltoche/lsd.git)
- [iscan-bundle](https://support.epson.net/linux/en/iscan_c.php?version=2.30.4)
- [Mendeley](https://www.mendeley.com/download-reference-manager/linux): AppImage

- [Albert launcher](https://albertlauncher.github.io/installing/): Desktop agnostic launcher
- [freeplane-mindmapping](https://sourceforge.net/projects/freeplane/): Application for Mind Mapping, Knowledge Management, Project Management
- [docfetcher](https://sourceforge.net/projects/docfetcher/): Desktop search application
- [GitAhead](https://gitahead.github.io/gitahead.com/):  A graphical Git client
- [Davmail](http://davmail.sourceforge.net/): POP/IMAP/SMTP/Caldav/Carddav/LDAP Exchange and Office 365 Gateway
- [FreeFileSync](https://freefilesync.org/): Better on windows
- [Rclone](https://rclone.org/downloads/):  rsync for cloud storage, can mount OneDrive using FUSE
- [yEd - Graph Editor](https://www.yworks.com/products/yed)
- [PlantUML](https://plantuml.com/)
- [umlet](https://www.umlet.com/): UML tool with a simple user interface, also for code
- [Kdenlive video editor](https://kdenlive.org/en/download/) (AppImage)
- [restic backup](https://github.com/restic/restic/releases)
- [ngrok](https://ngrok.com/):  secure introspectable tunnels to localhost
- [VSCodium](https://vscodium.com/): Free/Libre Open Source Software Binaries of VS Code
- [asciinema edit](https://github.com/cirocosta/asciinema-edit): Auxiliary tools for dealing with ASCIINEMA casts

- [gdm-tools](https://github.com/realmazharhussain/gdm-tools.git)
- [plymouth-theme](https://github.com/pop-os/plymouth-theme.git)
- [pop-fonts](https://github.com/pop-os/fonts.git)
- [pop-theme](https://github.com/pop-os/gtk-theme)
- [vortex-ubuntu-plymouth-theme](https://github.com/emanuele-scarsella/vortex-ubuntu-plymouth-theme.git)
- [disk-usage-space](https://github.com/anfemosa/disk-usage-space.git)

- [powerlevel10k](https://github.com/romkatv/powerlevel10k)

``` text
https://phuctm97.com/blog/zsh-antigen-ohmyzsh
https://github.com/zsh-users
https://github.com/mattmc3/zdotdir
```

- [Antidote](https://github.com/mattmc3/antidote)

``` bash
git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
```

- [zsh-you-shuould-use](https://github.com/MichaelAquilina/zsh-you-should-use.git)

### From snapcraft

``` bash
sudo apt update
sudo apt install snapd
```

- spotify
- docfetcher ***sudo snap install docfetcher***
- telegram-desktop ***current installation method***

### From Flatpak

- gimp
- libre-office
- telegram-desktop ***preferred installation method***
