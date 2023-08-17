# Dual Booting UEFI

> Machine [EX2511](https://icecat.biz/en/p/acer/nx.ef6eb.006/extensa-notebooks-4713392421143-ex2511-55pf-30284410.html) ==> i5-4210U 16GB 2xSSD

- [Dual Booting UEFI](#dual-booting-uefi)
  - [Disk 1 Windows](#disk-1-windows)
    - [Windows 11 + WSL2](#windows-11--wsl2)
      - [WSL Ubuntu](#wsl-ubuntu)
      - [WSL Tumbleweed](#wsl-tumbleweed)
    - [Docker WSL](#docker-wsl)
  - [Disk 0 Linux](#disk-0-linux)
    - [Arch](#arch)
    - [Pop!\_OS 22.04](#pop_os-2204)
    - [openSUSE Tumbleweed](#opensuse-tumbleweed)


<!--
https://www.youtube.com/watch?v=JRdYSGh-g3s     # Arch DB 0
https://www.youtube.com/watch?v=LGhifbn6088     # Arch DB 1
https://github.com/spxak1/weywot/blob/main/Pop_OS_Dual_Boot.md
https://www.youtube.com/watch?v=qYqPBrTudUY     # PopOS DB
https://support.system76.com/articles/windows/#installing-on-a-dedicated-drive
    - Disable Fast Startup
-->

<hr>

## Disk 1 Windows

```yaml
# Windows Run
winver
lusrmgr.msc
gpedit.msc: secpol.msc
```
```powershell
# If you're using a virtual machine, run the following PowerShell command to enable nested virtualization:
# Set-VMProcessor -VMName <VMName> -ExposeVirtualizationExtensions $true
```

### Windows 11 + WSL2

- Ventoy Installation
- Basic config
- Powershell

<!--
```TODO
- PWSH `$PROFILE` returns OneDrive location meaning that it's carried over across machines... LIKELY NOT PROPER ATM
- https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.3
- https://chocolatey.org/install#individual
- https://scoop.sh/

# HOUSEKEEPING - OneDrive
- https://www.reddit.com/r/onedrive/comments/kxlvxh/duplicate_documents_folder_is_driving_me_crazy/
```
-->

---


```yaml
# Customize Terminal profile for PWSH 7
Settings:
    Startup: Default profile: PowerShell
    Profiles: PowerShell:
        # Command line: "C:\Program Files\PowerShell\7\pwsh.exe"
        # Starting directory: %USERPROFILE%
        Appearance:
            Font size: 10
            Background opacity: 90%
        # Advanced: Bell notification style: Flash window
```

- Installing basic software

```powershell
winget search brave
winget install --id Brave.Brave --source winget                     # version 114.1.52.126

winget search vscode
winget install --id Microsoft.VisualStudioCode --source winget      # version 1.79.2

# winget install --id Valve.Steam --source winget                   # version 2.10.91.91
# winget install --id Google.Chrome --source winget                 # version 114.0.5735.134
# winget install --id Discord.Discord --source winget               # version 1.0.9013
# winget install --id Spotify.Spotify --source winget               # version 1.2.14
# winget install --id Nextcloud.NextcloudDesktop --source winget    # version 3.8.2
# winget install --id WiresharkFoundation.Wireshark --source winget # version 4.0.6.0
# winget search packettracer    # no results
# winget search neovim          # DON'T -- keep this sh within WSL  # version 0.9.1

winget install --id Microsoft.VCRedist.2015+.x64 --source winget
winget install --id KeePassXCTeam.KeePassXC --source winget         # version 2.7.5
winget install --id REALiX.HWiNFO --source winget                   # version 7.46
# winget install --id CPUID.CPU-Z --source winget                   # version 2.06
winget install --id Microsoft.PowerToys --source winget             # version 0.70.1
```

```yaml
# VScode
Extensions:
  One Dark Pro
  vscode-icons
  WSL

  Docker
  Dev Containers
  Remote Development

# Settings: Terminal Integrated Font Size: 12
```

<!--
```yaml
# Brave
Set as default browser
Settings:
#   Appearance: Dark
```

```yaml
# Chrome... G-account
```
-->

- Install NerdFonts

```yaml
Open Brave Browser: nerdfonts.com/font-downloads
FiraMono Nerd Font: Download
Save: Downloads\FiraMono.zip
Extract All: FiraMono
FiraMono Nerd Font Regular: Install
FiraMono Nerd Font Medium: Install
FiraMono Nerd Font Bold: Install
```

- Pro: Sandbox & Hyper-V

```powershell
# https://learn.microsoft.com/en-us/windows/security/application-security/application-isolation/windows-sandbox/windows-sandbox-overview
# either "Windows Features > Windows Sandbox > ON" or the following command (as admin)
Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online
```
```powershell
# https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v
Enable-WindowsOptionalFeature -FeatureName "Microsoft-Hyper-V" -All -Online
# DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V
```

<!-- - [ ] https://learn.microsoft.com/en-us/training/paths/windows-server-hyper-v-virtualization/ -->

- WSL 2

<!--
```markdown
# documentation
- @MicrosoftDeveloper: [In WSL, can I use distros other than the ones in the Microsoft Store? | One Dev Question](https://www.youtube.com/watch?v=AfhDwVASD2c)
- @LearnMicrosoft: [Will I be able to run WSL 2 and other 3rd party virtualization tools such as VMware, or VirtualBox?](https://learn.microsoft.com/en-us/windows/wsl/faq)

# TODO
- wsl.conf ??
- https://www.youtube.com/watch?v=ZO4KWQfUBBc (DOCKER @Fazt)
- https://www.youtube.com/watch?v=a6uR-iGVh7k (Custom Kernel)
  - https://www.youtube.com/watch?v=6lqMeg_n7l4
```

```powershell
## https://learn.microsoft.com/en-us/windows/wsl/compare-versions
# Install WSL via Microsoft Store
wsl.exe --install
wsl.exe --update

```

```powershell
# enable nested virtualization for WSL in VMs
Set-VMProcessor -VMName <VMName> -ExposeVirtualizationExtensions $true

# see Windows build
cmd.exe /c ver

# see linux kernel version
wsl.exe --status        # || cat /proc/version
```
-->

```powershell
# No need to manually turn on the Windows feature on Windows 11! -- https://learn.microsoft.com/en-us/windows/wsl/install-manual
# https://learn.microsoft.com/en-us/windows/wsl/basic-commands#install
# https://learn.microsoft.com/en-us/windows/wsl/install

# See all available distros
wsl -l -o

# Enable Windows features (VM Platform [+ WSL via MS Store]) & install Ubuntu
wsl --install

# Install openSUSE Tumbleweed
wsl --install -d openSUSE-Tumbleweed

# Verify WSL versions for each distro
wsl -l -v

# # Set default distro
# wsl --set-default Ubuntu

# Update WSL (likely not necessary) and see status and current build version
wsl --update
wsl --status
wsl --version

# Export | import

# https://learn.microsoft.com/en-us/windows/wsl/setup/environment
```

```yaml
# Customize Terminal profiles -- Settings:
Ubuntu:                 # ubuntu.exe
  Appearance:
    Color scheme: Tango Dark
    Font face: FiraMono Nerd Font
    Font size: 9
    Cursor shape: Underscore
    Intense text style: Bold font with bright colors
    Background opacity: 77%
  Advanced: Bell notification style: Flash window, Flash taskbar

openSUSE-Tumleweed:     # C:\Windows\system32\wsl.exe -d openSUSE-Tumbleweed
  Icon: https://es.opensuse.org/images/6/6e/Icon-distribution250.png
    # ms-appx://ProfilesIcons/{9acb9455-ca41-5aff7-950f-6bca1bc9722f}.png
  Appearance:
    Color scheme: Campbell
    Font face: FiraMono Nerd Font
    Font size: 10
    Cursor shape: Bar
    Intense text style: Bold font with bright colors
    Background opacity: 80%
  Advanced: Bell notification style: Flash window, Flash taskbar
```

<!-- - [ ] https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-git#git-credential-manager-setup -->

- OneNote => Office365

```yaml
MS Store: search OneNote
```

- Hard drive Forensics: [SleuthKit.Autopsy](https://www.sleuthkit.org/autopsy)

```powershell
winget install --id SleuthKit.Autopsy --source winget
```
```yaml
# Autopsy Setup Wizard
Installation Folder: C:\Program Files\Autopsy-4.20.0\

# First Startup
Information: Autopsy stores data about each case in its Central Repository (...)
Windows Defender Firewall: has blocked some features...
  OpenJDK Platform Library: Allow on private
  Autopsy64: Allow on private
```
```yaml
# First case
Case Name: test01
Base Directory: D:\autopsy_test
Case Number: 001
Examiner: pabloqpacin
```
> ERROR: Closes immediately

- Windows sysadmin tools (**Sysinternals Suite**)

```powershell
winget search sysinternals
winget install --id 9P7KNL5RWT25 --source msstore
# winget install --id Microsoft.Sysinternals* --source winget
```


#### WSL Ubuntu

```bash
# UNIX username + passwd

# Preps
dpkg -l | wc -l     # 422
sudo apt update
# apt list --upgradable
sudo apt upgrade -y

sudo apt install btop fzf g++ ripgrep tldr unzip zsh
git clone https://github.com/pabloqpacin/dotfiles
# git clone git@github.com:pabloqpacin/dotfiles.git
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
rm ~/.zshrc
ln -s ~/dotfiles/.zshrc
ln -s ~/dotfiles/.gitconfig
ln -s ~/dotfiles/.config/bat ~/.config
ln -s ~/dotfiles/.config/btop ~/.config
ln -s ~/dotfiles/.config/nvim ~/.config
ln -s ~/dotfiles/.config/tmux ~/.config
mkdir -p ~/.local/share/tldr && tldr -u

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install bat git-delta exa

# git clone https://github.com/dylanaraps/neofetch
# sudo apt install make && cd neofetch && sudo make install
sudo apt install neofetch --no-install-recommends

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
nvm install node
snap list
sudo snap refresh
sudo snap install nvim --classic
cd ~/.config/nvim && nvim lua/pabloqpacin/packer.lua
# :so && :PackerUpdate && :PackerCompile

sudo apt install cmake
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux                                # prefix+I to install plugins

sudo apt install wslu --no-install-recommends
# rustup docs --book
    # sudo apt install xdg-utils  # for xdg-open -- DON'T, WSLVIEW IS ENOUGH

sudo apt install xclip xsel
```


<!-- ```TODO
- ... -- https://learn.microsoft.com/en-us/windows/wsl/basic-commands

- Docker -- https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-containers
- Databases -- https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-database

- Arch doable?? -- https://learn.microsoft.com/en-us/windows/wsl/use-custom-distro
- info -- https://learn.microsoft.com/en-us/windows/wsl/build-custom-distro
``` -->

#### WSL Tumbleweed

```bash
# YaST2 firstboot: username and password

zypper search -i | wc -l        # (304)
sudo zypper refresh
sudo zypper update

sudo zypper install bat btop exa fzf git git-delta neofetch neovim ripgrep tmux zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/pabloqpacin/dotfiles
ln -s ~/dotfiles/.zshrc
ln -s ~/dotfiles/.gitconfig
ln -s ~/dotfiles/.config/bat ~/.config
ln -s ~/dotfiles/.config/btop ~/.config
ln -s ~/dotfiles/.config/nvim ~/.config
ln -s ~/dotfiles/.config/tmux ~/.config

git clone --depth 1 https://github.com/wbthomason/packer.nvim \
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
nvm install node
npm install tldr
tldr -u
npm install live-server
sudo zypper install gcc-c++
cd .config/nvim && nvim lua/pabloqpacin/packer.lua
# :so && :PackerUpdate && PackerCompile

zypper search -i | wc -l        # (380)

sudo zypper install cmake
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux                                # prefix+I to install plugins
```

```bash
# Write script for tmux...

#!/bin/bash
sudo mkdir /run/tmux
echo "Created /run/tmux"
sudo chmod 1777 /run/tmux
echo "Granted it 1777 permissions"
```

<!--
...
- .wslconfig
- wsl.conf
-->


### Docker WSL

- Install

```markdown
<!-- - https://docs.docker.com/desktop/install/linux-install/ -->
- https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-containers
- https://docs.docker.com/desktop/wsl/
- https://docs.docker.com/get-started/
```
```powershell
# In Windows host
# winget install --id Docker.DockerCLI --source winget          # ??
# winget install --id Docker.DockerDesktop --source winget      # "Installer hash does not match" !!
```
```yaml
# Brave Browser
docker.com: Download Docker Desktop Installer for Windows

# Downloads
Docker_Desktop_Installer.exe: double-click

# Installing Docker Desktop 4.21.0 (113844)
Use WSL 2 instead of Hyper-V: on
Add shortcut to desktop: off
# ...   Restart
```

- Set up

<!-- ```yaml
# KeePassXC
Start: Create DB || Open DB || Import from KeePass 1 || Import from 1Password || Import from CSV
Create: Ex2511_passwerds
Passwd: ...
``` -->
```yaml
# Docker Hub Sign up
Username:   # pqp95
Email:      # ...
Password:   # KeePassXC
Agree: on
```
```yaml
# First start
Docker Subscription Service Agreement: Accept
Welcome to Docker Desktop: Sign up || Sign in || Continue without signing in
Role: Student
Usecases: Learning
# Starting the Docker Engine
```

- Getting started

```bash
# In Ubuntu WSL
mkdir ~/Workspace/docker_101 && cd $_
git clone https://github.com/docker/getting-started.git
# code getting-started
cd getting-started/app
nvim Dockerfile
```
```Dockerfile
# syntax=docker/dockerfile:1
   
FROM node:18-alpine
WORKDIR /app
COPY . .
RUN yarn install --production
CMD ["node", "src/index.js"]
EXPOSE 3000
```
```bash
docker build -t getting-started .
# docker scout quickvview

docker run -dp 127.0.0.1:3000:3000 getting-started
docker ps -a    # list all containers
sensible-browser http://127.0.0.1:3000
# add a couple items
docker stop <container_name>
docker start <container_name>
```
```bash
nvim src/static/js/app.js
    # modify line 56: "No items yet"
docker build -t getting started .

docker ps -a    # new not shown
docker stop <container_name>
docker rm <container_name>

docker run -dp 127.0.0.1:3000:3000 getting-started
```
```bash
docker image ls
docker image inspect <foo> | bat -l json
```

<hr>


## Disk 0 Linux

### Arch

- UEFI installation
- If encounter Boot problems, manage the BIOS/UEFI boot options
- Set GRUB for **Dual Boot**...
- Set WM, install yay
- Custom environment: zsh neovim tmux ...
- Set Wi-Fi, prep disk other distros
- GRUB customization -- **after all other distros**

---
- Overwrite old HDD with zeroes

```bash
# Mount it and erase its current partitions aye
# sudo mkdir /mnt/old_hdd
    # sudo mount /dev/sdc /mnt/old_hdd
# sudo cfdisk /dev/sdc
# sudo mkfs.ext4 /dev/sdc
# sudo mount /dev/sdc /mnt/old_hdd

# No partitions mounted: erase the HDD with zeros
sudo dd if=/dev/zero of=/dev/sdc bs=4M status=progress
```

- Toggle WiFi on and off

```bash
cheat nmcli             # OJO !!
nmcli radio wifi        # see current status
nmcli radio wifi off    # toggle WiFi connection off
```
---



### Pop!_OS 22.04

- Ventoy installation
- Login back in Arch
- First Pop!_OS login

```yaml
# Welcome tour
Dock: no
Workspaces Button: no

# # Gnome terminal
# New profile: mine: Set as default
#   Font size: 10
#   Built-in schemes: Gray on black
#   Use transparent background: 30%
#   Palette: Built-in schemes: Tango
```
- Custom environment

<hr>

### openSUSE Tumbleweed

- Ventoy live session

```yaml
# Installation
Language: English US
Keyboard: Spanish
Online Repositories: Yes                # OK to 3 default
System-role: Desktop with KDE Plasma    # TODO Generic Desktop + Server
# Disk: Suggested:
#   /dev/sda2: swap
#   /dev/sda1: /boot/efi
#   /dev/sda6: / (btrfs)
#   9 subvolume actions:
#     - create subvolume @ on /dev/sda6
#     - create subvolume @/var on /dev/sda6
#     - create subvolume @/usr/local on /dev/sda6
#     - create subvolume @/srv on /dev/sda6
#     - create subvolume @/root on /dev/sda6
#     - create subvolume @/opt on /dev/sda6
#     - create subvolume @/home on /dev/sda6
#     - create subvolume @/boot/grub2/x86_64-efi on /dev/sda6
#     - create subvolume @/boot/grub2/i386-pc on /dev/sda6
#   # takes all free disk space but ignores /dev/sda5,
#   # meaning we may have those 100GB still available
Disk: Expert partitioner: Existing partitions:
  /dev/sda5: / (ext4) -- Format
  /dev/sda1: /boot/efi
  /dev/sda2: swap
Clock and region: Europe Madrid
Username: pabloqpacin
Password: ...
  Use this passwd for sysadmin: on
  Automatic Login: on
Overview:
  SecureBoot: disable
```

- Login back in Arch

```bash
sudo mkdir /mnt/suse
sudo mount /dev/sdb1 /mnt/win11
sudo mount /dev/sda4 /mnt/pop
sudo mount /dev/sda5 /mnt/suse
sudo grub-mkconfig -o /boot/grub/grub.cfg
reboot
```

- First openSUSE Tumbleweed login

```yaml
# YaST
Software Repositories: Delete Ventoy repository

# System Settings
Appearance: Global Theme: Breeze Dark

# Task bar
Right click: Edit Mode: More Options: Auto Hide

# Konsole
```

```bash
sudo zypper refresh
sudo zypper update || sudo zypper dup
# rpm -qa | wc -l               # (2148) installed packages

sudo zypper install alacritty bat btop exa fzf git git-delta neofetch neovim ripgrep tmux zsh

git clone https://github.com/pabloqpacin/dotfiles
sudo unzip ~/dotfiles/fonts/FiraMonoNerd.zip -d /usr/share/fonts/FiraMonoNerd
fc-cache -fv

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
rm .zshrc
ln -s ~/dotfiles/.zshrc
ln -s ~/dotfiles/.gitconfig
ln -s ~/dotfiles/.config/bat ~/.config
ln -s ~/dotfiles/.config/btop ~/.config
ln -s ~/dotfiles/.config/nvim ~/.config
ln -s ~/dotfiles/.config/tmux ~/.config
ln -s ~/dotfiles/.config/alacritty ~/.config

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
nvm install node
npm install -g live-server
npm install -g tldr
tldr -u

sudo zypper install gcc-c++
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
cd .config/nvim && nvim lua/pabloqpacin/packer.lua
# :so && :PackerUpdate && :PackerCompile

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux                                # prefix+I to install plugins
```

```bash
sudo nvim /etc/hostname     # TW_box
```


<hr>

<!--
NEXT UP
- Kali
- NixOS
- Alpine
- Gentoo
-->
