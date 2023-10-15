# Pop!_OS


> - **NOTE 1:** this installation assumes a [multiboot](/docs/) setup where another distro (Arch, NixOS...) is managing the bootloader
> - **NOTE 2:** in general, the steps below would be the same for most Debian/Ubuntu based distros
> - **NOTE 3:** won't tweak the default terminal but install Alacritty instead

- [Pop!\_OS](#pop_os)
  - [documentation](#documentation)
  - [live installation](#live-installation)
  - [post-install config](#post-install-config)


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
# Startup Applications >> Add: devilspie
```

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
```

<!-- ```yaml
# Themes: ['Dracula GTK', '']
# gnome-look.org: ['', '']
``` -->


- Manage shell environment: packages, zsh, nvim

```bash
# Install them basics
sudo apt install alacritty btop cava flameshot ripgrep tldr tmux zsh    # taskwarrior -- fzf with Go!
sudo apt install neofetch --no-install-recommends
tldr --update

# Them Rust packages
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh      # default
cargo install bat bottom eza fd-find git-delta gitui zoxide
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

- Workstation vibes -- see [code/codium settings.json](/.config/code/User/settings.jsonc)

```bash
# Pop!_Shop OK
flatpak install spotify
flatpak install discord
flatpak install gitkraken
flatpak install flathub com.github.IsmaelMartinez.teams_for_linux
sudo apt install steam  # Proton 8
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
sudo apt-get install ipcalc nmap nmapsi4 openssh-server wireshark tshark  && \
 sudo usermod -aG wireshark username

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

- LibreOffice language

```yaml
# LibreOffice Writer
Tools:
  Language:
    For All Text:
      More:
        Default Languages for Documents:
          Western: Spanish (Spain)
```