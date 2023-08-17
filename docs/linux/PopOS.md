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
      nvme0n1p4: 409600 MiB -- PopOS -- ext4
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

```bash
sudo nano /etc/hostname

sudo apt update -y \
  && sudo apt full-upgrade -y \
  && sudo apt autoremove -y \
  && sudo apt autoclean -y

echo 'APT::Get::Show-Versions "true";' | sudo tee /etc/apt/apt.conf.d/99show-versions
  # $ sudo apt upgrade -V


# Install Brave -- mind the "*.gpg arch=amd64"
sudo curl -fsSLo /usr/share/keyrings/brave-browser-beta-archive-keyring.gpg https://brave-browser-apt-beta.s3.brave.com/brave-browser-beta-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-beta-archive-keyring.gpg arch=amd64] https://brave-browser-apt-beta.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-beta.list
sudo apt update
sudo apt install brave-browser

# Brave --> Download a Nerd Font
sudo unzip ~/Downloads/FiraCode.zip -d /usr/share/fonts/FiraCodeNerd
fc-cache -fv

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
ln -s ~/dotfiles/.devilspie ~
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
  # Hide Top Bar: ...
```

<!-- ```yaml
# Themes: ['Dracula GTK', '']
# gnome-look.org: ['', '']
``` -->


- Manage shell environment

```bash
# Install the basics
sudo apt install alacritty btop cava flameshot fzf ripgrep tldr tmux zsh    # taskwarrior
sudo apt install neofetch --no-install-recommends
tldr --update

# Them Rust packages
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh      # default
cargo install bat exa fd-find git-delta zoxide
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
```

```bash
# Install Golang
cd /tmp \
 && wget -c https://golang.org/dl/go1.21.0.linux-amd64.tar.gz \
 && sudo rm -rf /usr/local/go \
 && sudo tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz \
 && source ~/dotfiles/zsh/golang.zsh

# Build lf
env CGO_ENABLED=0 go install -ldflags="-s -w" github.com/gokcehan/lf@latest
lf -doc | bat -l sh

# Set up Tmux plugins
git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux    # $ C-b + I --> Install plugins

# Install npm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
nvm install node
# $ npm install --global live-server

# Python basics
sudo apt-get install python3-pip python3-venv --no-install-recommends

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

```yaml
# Desktop apps
Pop Shop:
  - Steam: deb pkg    # Proton 8
  - Discord: deb pkg
  - Spotify: flatpak
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
# Install some important tools
sudo apt-get install nmap nmapsi4 openssh-server wireshark  && \
 sudo usermod -aG wireshark username

sudo apt install virtualbox virtualbox-ext-pack virtualbox-guest-additions-iso

# Cheat...
```


