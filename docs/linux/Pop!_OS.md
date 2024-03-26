# Pop!_OS


> - **NOTE 1:** this installation assumes a [multiboot](/docs/) setup where another distro (Arch, NixOS...) is managing the bootloader
> - **NOTE 2:** in general, the steps below would be the same for most Debian/Ubuntu based distros
> - **NOTE 3:** won't tweak the default terminal but install Alacritty instead

- [Pop!\_OS](#pop_os)
  - [documentation](#documentation)
  - [live installation](#live-installation)
  - [post-install config](#post-install-config)
    - [Base](#base)
    - [Desktop](#desktop)
    - [Homelab](#homelab)


---

## documentation

- Pop!_OS
  - @System76: [Keyboard Shortcuts](https://support.system76.com/articles/pop-keyboard-shortcuts/)
- Rice <!--Race Inspired Cosmetic Enhancements-->
  - @NIX tricks: [How I Made GNOME Look This Clean on Pop!_OS](https://youtu.be/rYQFBCE0aq8)
  - @NiccoLovesLinux: [GNOME Extensions for Productivity, Workflow, and More!](https://youtu.be/A-ot9xk74T4)
  - KeePassXC
    - @KeePassXC: [User Manual](https://keepassxc.org/docs/KeePassXC_UserGuide)


<!-- MOCKS

```bash
# $ mkdir .themes

```
 -->


## live installation

```yaml
Live ISO installer:
  Language: English US
  Keyboard: Spanish Default
  Install:
    Create Partition:
      nvme0n1p4: 409600 MiB -- PopOS -- ext4  # 1 TB !!
    Define Partitions:          # don't format any!
      - /dev/nvme0n1p4: /
      - /dev/nvme0n1p2: swap
      - /dev/nvme0n1p1: /boot/efi   # bootloader managed by another distro
  Username: ...
  Passwd: ...
```
> If applicable, update GRUB now booting into the relevant partition/OS


## post-install config

### Base

- First steps

```yaml
# Welcome tour
Dock: Doesn't extend to edges
Top Bar: Show Workspaces & Applications Buttons
Accounts:
    - Google: yes

# After tour if applicable
Top Bar: Battery --> Hybrid Graphics
```

<!--
```yaml
# Gnome terminal
New profile: mine: Set as default
  Font size: 10
  Built-in schemes: Gray on black
  Use transparent background: 30%
  Palette: Built-in schemes: Tango
```
 -->

```bash
sudo nano /etc/hostname

sudo apt update -y \
  && sudo apt full-upgrade -y \
  && sudo apt autoremove -y \
  && sudo apt autoclean -y

# $ sudo update-alternatives --config x-terminal-emulator

echo 'APT::Get::Show-Versions "true";' | sudo tee /etc/apt/apt.conf.d/99show-versions
  # $ sudo apt upgrade -V

# Install Brave -- mind the "*.gpg arch=amd64"
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser

# Brave --> Download a Nerd Font
sudo unzip ~/Downloads/FiraCode.zip -d /usr/share/fonts/FiraCodeNerd
fc-cache -fv

# Install a local password manager
sudo apt install keepassxc
mkdir .KPXC && cd $_
keepassxc-cli db-create -p database.kdbx
keepassxc-cli open database.kdbx
  # $ mkdir database somegroup
  # $ add -u someusername --url https://somesite.web -g somegroup/entryname
  # $ show -s entryname

# If baremetal, fix Videos not playing mp4
sudo apt remove gstreamer1.0-vaapi

# If VM... Devices: Insert Guest Additions CD image... && open media
./autorun.sh
reboot

# Remove xdg_user_directories
# $ rmdir Documents Music Public Templates Videos
```

- System settings and desktop extensions

```bash
sudo apt install acpi cbonsai gnome-tweaks devilspie unclutter-xfixes
unclutter -idle 3 &
ln -s ~/dotfiles/.devilspie ~/
ln -s ~/dotfiles/.config/autostart ~/.config
```
<!-- gnome-session-properties -->

```yaml
# System
Settings:
  Date and Time:
    Time Format: '24-hour'
  Desktop:
    Dock:
      - Size: Custom --> 40px
      - Visibility: Intelligently hide
      - Options: Show {Launcher, Workspaces, Applications} Icon --> no

# Brave -- enable "GNOME Shell integration" extension, then install:
extensions.gnome.org:
  Vitals: by corecoding
  BackSlide: by p91paul
  Hide Top Bar: by tuxor1337
  Transparent Top Bar: (Adjustable transparency) by Gonzague
  # User Themes: by fmuellner
  # App Indicator: by ??

# System
Extensions:
  Pop Shell:
    - Show Window Titles: no
    - Smart gaps: on
    - Gaps: Outer & Inner == 1
    - Allow launcher over fullscren window: yes
  Transparent Top Bar:
    - Top Bar Opacity: 36%
    - Opaque top bar when a window touches it: no
  Hide Top Bar: <3 top yes; 3 down no; 100 both>

# More Brave extensions
chrome.google.com/webstore:
  KeePassXC-Browser: ...  # https://keepassxc.org/docs/KeePassXC_GettingStarted#_setup_browser_integration)
  Dark Reader:
    - Enabled by Default: no
    - Detect dark theme: yes
    # Now just activate when needed
  SimpleLogin: for ProtonMail           # (!)
```

<!-- ```yaml
# Themes: ['Dracula GTK', '']
# gnome-look.org: ['', '']
``` -->


- Manage shell environment: packages, zsh, nvim

```bash
# Install them basics
sudo apt install alacritty btop cava flameshot ripgrep tldr tmux zsh    # taskwarrior -- fzf with Go!
sudo apt install ccze grc mycli --no-install-recommends
sudo apt install neofetch --no-install-recommends
tldr --update

# Them Rust packages
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh      # default
cargo install cargo-update bat bottom eza fd-find git-delta gitui zoxide
    # https://github.com/rust-lang/cargo/issues/2729

# Set up SSH auth for Github
ssh-keygen -t ed25519 -C "my@email.com"     # skip
cat ~/.ssh/id_25519.pub
  # github.com > profile settings > add New SSH
ssh -T git@github.com                       # yes

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Clone and symlink them dotfiles
git clone git@github.com:pabloqpacin/dotfiles.git

rm .zshrc
ln -s ~/dotfiles/.zshrc ~
ln -s ~/dotfiles/.gitconfig ~
ln -s ~/dotfiles/.config/bat ~/.config
ln -s ~/dotfiles/.config/btop ~/.config
ln -s ~/dotfiles/.config/alacritty ~/.config

ln -s ~/dotfiles/.config/lf ~/.config
ln -s ~/dotfiles/.config/tmux ~/.config
ln -s ~/dotfiles/.config/nvim ~/.config

# Install zsh plugins
git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git $HOME/dotfiles/zsh/plugins/zsh-autosuggestions
git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/dotfiles/zsh/plugins/zsh-syntax-highlighting
```

```bash
# Set up Tmux plugins
git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux    # $ C-b + I --> Install plugins

# Python basics -- nvim lowkey required
sudo apt-get install python3-pip python3-venv --no-install-recommends

# Install Golang
cd /tmp \
 && wget -c https://golang.org/dl/go1.21.0.linux-amd64.tar.gz \
 && sudo rm -rf /usr/local/go \
 && sudo tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz \
 && source ~/dotfiles/zsh/golang.zsh

# Install FZF
go install github.com/junegunn/fzf@latest

# Build lf
env CGO_ENABLED=0 go install -ldflags="-s -w" github.com/gokcehan/lf@latest
lf -doc | bat -l sh

# Install npm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
nvm install node
# $ npm install --global live-server

# Build and set up Neovim
sudo apt-get install build-essential cmake gettext ninja-build unzip
git clone --depth 1 https://github.com/neovim/neovim.git
cd neovim && make CMAKE_BUILD_TYPE=Release      # RelWithDebInfo OK too
sudo make install
# $ cd .. && rm -rf neovim

git clone --depth 1 https://github.com/wbthomason/packer.nvim \
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

cd ~/.config/nvim && nvim lua/pabloqpacin/packer.lua
# $ :so && :PackerSync && :PackerCompile && :MasonUpdate

# TODO: deno, peek, live-server, ...
```

### Desktop

- Workstation vibes -- see [code/codium settings.json](/.config/code/User/settings.jsonc)

```bash
# Pop!_Shop OK
# flatpak install flathub io.dbeaver.DBeaverCommunity
flatpak install anydesk
flatpak install discord
flatpak install gitkraken
flatpak install krita
flatpak install slack
flatpak install spotify
flatpak install visualboy
sudo apt install steam  # Proton 8
flatpak install flathub com.github.IsmaelMartinez.teams_for_linux

# flatpak install retroarch --> if possible, do via Steam instead aye? see ~/dotfiles/.config/retroarch
# flatpak install dolphinemu
```

```bash
# Install VSCodium
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
    | sudo tee /etc/apt/sources.list.d/vscodium.list
sudo apt update && sudo apt install codium

# Alternatively $ sudo apt-get install code
```
```bash
# Misc
sudo apt-get install libssl-dev && \
 cargo install mdcat

cd /tmp \
  && wget https://github.com/cheat/cheat/releases/download/4.4.0/cheat-linux-amd64.gz \
  && gunzip cheat-linux-amd64.gz \
  && chmod +x cheat-linux-amd64 \
  && sudo mv cheat-linux-amd64 /usr/local/bin/cheat
  # symlink config and personal cheatsheets

git clone https://github.com/st3w/neo
cd neo && sudo apt update
sudo apt install autoconf build-essential libncurses-dev \
 && ./autogen.sh \
 && ./configure \
 && make \
 && sudo make install
cd .. && rm -rf neo
```

```bash
# Arduino stuff --    https://github.com/pabloqpacin/C-eazy
flatpak install cc.arduino.IDE
curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | BINDIR=~/.local/bin sh
sudo useradd -aG dialout $USER  # https://arduino.stackexchange.com/questions/739/arduino-program-only-works-when-run-as-root
# arduino-cli config init     # && ln -s ...
```
```bash
# Networking tools
sudo apt-get install ipcalc nmap nmapsi4 openssh-server termshark tshark wireshark && \
sudo usermod -aG wireshark $USER

# https://wiki.safing.io/en/Portmaster/Install/Linux
curl -fsSL https://updates.safing.io/latest/linux_all/packages/install.sh | sudo bash

sudo apt install nftables traceroute whois

sudo apt install iperf3
```

```bash
# Virtualization tools
sudo apt install virtualbox virtualbox-ext-pack virtualbox-guest-additions-iso

# TODO: KVM
```

<!--
- New partititons

```yaml
Disks:
Create unallocated 150GB: Pop_Steam_Games Ext4
# Install AC6 unto it -- Create Application Shortcut
```
 -->


```bash
# Install PowerShell -- https://learn.microsoft.com/en-us/powershell/scripting/install/install-ubuntu?view=powershell-7.3
sudo apt-get update
sudo apt-get install -y wget apt-transport-https software-properties-common

  # Download, register and delete the Microsoft repository GPG keys
wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

sudo apt-get update
sudo apt-get install -y powershell

pwsh


# Install oh-my-posh prompt & symlink config
mkdir -p $HOME/.local/bin
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d $HOME/.local/bin

ln -s ~/dotfiles/.config/powershell ~/.config
# $ mkdir $HOME/.cache/oh-my-posh/themes/NOPE   -- mv NOPE themes
```

- Fix webcam for Teams

```bash
flatpak search teams
flatpak install flathub com.github.IsmaelMartinez.teams_for_linux
```
<!-- ```bash
# # INOP
# sudo apt install ffmpeg v4l2loopback-dkms v4l-utils
# sudo modprobe v4l2loopback
# ffmpeg -f v4l2 -i /dev/video0 -vf format=yuv420p,scale=1280x720 -f v4l2 /dev/video1
# ffmpeg -f v4l2 -i /dev/video0 -vf "format=yuv420p,scale=1280:720" -c:v rawvideo -pix_fmt yuv420p -f v4l2 /dev/video1\
# v4l2-ctl --list-formats-ext -d /dev/video0
# v4l2-ctl --list-formats-ext -d /dev/video1
# sudo nvim /etc/gdm3/custom.conf
``` -->

- LibreOffice config

```md
# documentation
- @TheLinuxExperiment: [Make LIBREOFFICE more compatible with MICROSOFT OFFICE & 365](https://www.youtube.com/watch?v=G0che2Az9hw)
- @libreoffice.org -- extensions
    - https://superuser.com/questions/1525126/how-to-get-code-block-with-syntax-highlighting-into-libreoffice-writer
    - [Code Highlighter 2](https://extensions.libreoffice.org/en/extensions/show/5814)
    - [Extension Manager](https://help.libreoffice.org/7.5/en-US/text/shared/01/packagemanager.html#hd_id3895382)
- @eBuzzCentral: [LibreOffice – Make It Compatible With MS Office & Office 365 | Layout & Fonts](https://www.youtube.com/watch?v=vjTOFGddtwQ)

```

```yaml
# LibreOffice Writer
Tools:
  Language:
    For All Text:
      More:
        Default Languages for Documents:
          Western: Spanish (Spain)
View:
    User interface:
        UI variant: Tabbed
Options:  # Alt+F12
    LibreOffice:
        View:
            Icon Style: Yaru mate (SVG)

```

- LibreOffice extensions...

```bash
# Find local files
whereis libreoffice
    # /etc/libreoffice /usr/share/libreoffice

# Brave --> extensions.libreoffice.org
wget https://extensions.libreoffice.org/assets/downloads/508/1693681078/codehighlighter2.oxt
#sudo unopkg add --shared codehighlighter2.oxt
# Writer --> Extension --> Add: foo.oxt

```

- TODO
    - [ ] Fine dark mode (icons/theme)
    - [ ] Code highlighting
    - [ ] markdown?
    - [ ] JUST MAKE IT USABLE FOR fine PDFs


<!-- - USERS AND STUFF

```bash
# sudo mkdir /home/ztore

# sudo useradd -mg users whoami
# sudo passwd whoami      # supdawg
# su whoami

# sudo chown :libvirt-qemu /media/pabloqpacin/ASIR/KVM_VMs
# sudo chmod 0771 /media/pabloqpacin/ASIR
# sudo chmod 0770 /media/pabloqpacin
``` -->

- OBS

```bash
flatpak install com.obsproject.Studio
flatpak install kdenlive

sudo apt-get install screenkey
ln -s ~/dotfiles/.config/screenkey.json ~/.config
    # Use left + right CTRL keys to HIDE PASSWORDS !!

sudo apt-get install fortune-mod
```

- Docker

```bash
$sa_update && $sa_install ca-certificates curl gnupg  # gnome-terminal
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
$sa_update && $sa_install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    # docker compose version; docker --version; docker version; sudo docker run hello-world
    sudo usermod -aG docker $USER
wget https://desktop.docker.com/linux/main/amd64/docker-desktop-4.24.2-amd64.deb
$sa_update && $sa_install ./docker-desktop-4.24.2-amd64.deb && rm docker-desktop-4.24.2-amd64.deb
    # systemctl --user start docker-desktop || systemctl --user enable docker-desktop
```

<!-- ```txt
[~] sudo systemctl disable --now docker
[sudo] password for pabloqpacin:
Sorry, try again.
[sudo] password for pabloqpacin:
Synchronizing state of docker.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install disable docker
Warning: Stopping docker.service, but it can still be activated by:
  docker.socket
[~] sudo systemctl disable --now docker.socket
Removed /etc/systemd/system/sockets.target.wants/docker.socket.
``` -->

- Raspberry Pi 5

```bash
# sudo apt install rpi-imager   # version behind!

wget https://downloads.raspberrypi.org/imager/imager_latest_amd64.deb
sudo dpkg -i imager_latest_amd64.deb && \
  sudo apt-get install -f

# wget https://downloads.raspberrypi.com/raspios_full_armhf/images/raspios_full_armhf-2023-10-10/2023-10-10-raspios-bookworm-armhf-full.img.xz
# xz -d file.img.xz

# Open Imager, burn OS to SD
```

```yaml
# Imager
# ...
```

- https://www.essentialdevtips.com/blog/how-do-you-display-code-snippets-in-microsoft-word/


---

- VLC
  - [skins](https://www.videolan.org/vlc/skins.php)
  - contributing
    - [github.com/videolan](https://github.com/videolan/vlc)
    - [VideoLAN: Contribute](https://www.videolan.org/contribute.html)

---


- AnyDesk

```bash
flatpak install anydesk

# # Install .deb from the browser
# sudo dpkg -i anydesk_*.deb
# sudo apt-get install -f

# # http://deb.anydesk.com/howto.html
# wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | apt-key add -
#     # WARNING: pat-key is deprecated. Manage keyring files in trusted.gpg.d instead...
# echo "deb http://deb.anydesk.com/ all main" > /etc/apt/sources.list.d/anydesk-stable.list
# apt update && apt install anydesk
```

```bash
flatpak install onlyoffice
flatpak install qbittorrent
```

- Github CLI

```sh
# # https://github.com/cli/cli/blob/trunk/docs/install_linux.md
# type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
# curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
# && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
# && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
# && sudo apt update \
# && sudo apt install gh -y

```

<!--
- Proton VPN

```bash
# flatpak install protonvpn
wget https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.3-2_all.deb
echo "c68a0b8dad58ab75080eed7cb989e5634fc88fca051703139c025352a6ee19ad  protonvpn-stable-release_1.0.3-2_all.deb" | sha256sum --check -
sudo dpkg -i protonvpn-stable-release_1.0.3-2_all.deb
sudo apt install proton-vpn-gnome-desktop       # ...

rm protonvpn-stable-release_1.0.3.-2_all.deb
sudo dpkg -r protonvpn-stable-release
sudo rm /etc/apt/sources.list.d/protonvpn-stable.list
```
-->

- More Misc.

```bash
sudo apt-get install audacity

agi gnome-clocks
```

### Homelab

- Samba (Pi5)

```bash
sudo apt install smbclient -y

# sudo pacman -S

```

- SQL


```bash
# sudo apt install mariadb-client
pip install -U mycli

ln -s ~/dotfiles/.myclirc ~/

# sudo docker run -d --name mariadb-container -e MYSQL_ROOT_PASSWORD=changeme -e MYSQL_ROOT_HOST='%' -p 3307:3306 -v mariadb_data:/var/lib/mysql mariadb:latest

mycli -h 127.0.0.1 -P 3307 -u root -p


```

---

<!-- ### Setesur

```bash
# SETERA: Convert .mp3 to .wav
sudo apt-get install \
    sox

# sox...
sox --encoding u-law -r 8000 -n nuevo.wav original.mp3
``` -->

---



- fix 'Ubuntu Pro' bullshite

```txt
~ » aguu
Hit:1 https://download.docker.com/linux/ubuntu jammy InRelease
Hit:2 https://brave-browser-apt-release.s3.brave.com stable InRelease
Hit:3 http://repository.spotify.com stable InRelease
Hit:4 https://packages.microsoft.com/ubuntu/22.04/prod jammy InRelease
Hit:5 https://download.vscodium.com/debs vscodium InRelease
Hit:6 http://apt.pop-os.org/proprietary jammy InRelease
Hit:7 http://apt.pop-os.org/release jammy InRelease
Hit:8 http://apt.pop-os.org/ubuntu jammy InRelease
Hit:9 http://apt.pop-os.org/ubuntu jammy-security InRelease
Hit:10 http://apt.pop-os.org/ubuntu jammy-updates InRelease
Hit:11 http://apt.pop-os.org/ubuntu jammy-backports InRelease
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
All packages are up to date.
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Calculating upgrade... Done
Get more security updates through Ubuntu Pro with 'esm-apps' enabled:
  vlc-plugin-qt libvlc5 vlc-data libvlccore9 vlc vlc-bin libiperf0
  libavdevice58 ffmpeg libpostproc55 libavcodec58 traceroute iperf3
  libavutil56 libswscale5 libswresample3 vlc-plugin-video-output libavformat58
  libvlc-bin vlc-plugin-base libavfilter7
Learn more about Ubuntu Pro at https://ubuntu.com/pro
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
```
```bash
sudo mv /etc/apt/apt.conf.d/20apt-esm-hook.conf{,.bak}
# https://askubuntu.com/questions/1434512/how-to-get-rid-of-ubuntu-pro-advertisement-when-updating-apt
```
