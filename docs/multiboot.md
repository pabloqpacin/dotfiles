# Dual Booting UEFI

> Machine [EX2511](https://icecat.biz/en/p/acer/nx.ef6eb.006/extensa-notebooks-4713392421143-ex2511-55pf-30284410.html) ==> i5-4210U 16GB 2xSSD

- [Dual Booting UEFI](#dual-booting-uefi)
  - [Disk 1 Windows](#disk-1-windows)
    - [Windows 11 + WSL2](#windows-11--wsl2)
      - [WSL Ubuntu](#wsl-ubuntu)
      - [WSL Tumbleweed](#wsl-tumbleweed)
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

```yaml
# Install Now
'I don't have a product key'
Windows 11 Pro N
Disk management: Customised: Install Windows only (advanced)
Delete every partition
Drive 1 (240GB) >> New >> 80_000 MB         # Next time: 50 GB
- P1 100MB System EFI
- P2 16MB MSR
- P3 78GB Primary NTFS
- P4 633MB Recovery

## Setup
Region: Spain
Keyboard: Spanish
Device name: Win11EX

Set up: Personal use
# MS Account: no@thankyou.com
MS Account: myaccount@gmail.com
Restore...: 'new device'            # || GL76 (2023-06-18) || QUEVEDOPABLO-S4 (2022-08-24)
Create PIN: ...

Location: Yes
Find Device: Yes
Diagnostics: Required
Inking: No
Tailored experience: No
Advertising ID: Yes
Customise experience: Skip

Use Phone from PC: Skip
OneDrive: Next                      # || 'Only save to PC'
Microsoft 365: Decline
100 GB Cloud: Decline
```

- Basic config

```yaml
# Settings
System:
    Power & battery: Energy recommendations: ...
    # Storage: Advanced storage settings: !!
    Activation: Windows is activated with a digital licence linked to your Microsoft account    # !!
# Network & internet: !!
Personalisation:
    Colours: Dark
    Themes: ...
    Start: Folders: Settings                                # Network !!
    Taskbar: everything OFF, Automatically hide the taskbar
Apps:
    Installed apps: Uninstall: Clipchamp, Microsoft News, Solitaire Collection
    Startup: OFF: Microsoft Edge, Microsoft Teams
# Accounts: !!
Privacy & security:
    Windows Security: everything must be green, ON          # driver issue for Core Isolation: Memory integrity (igdkmd64.sys)
    Find my device: OFF                                     # ?
    For developers:
        # Developer mode: !!
        File explorer:
            Show empty drives: yes
            Show file extensions: yes
            Show full path in title bar: yes
            Show hidden and system files: yes
            Show option to run as different user in Start: yes
        # Remote Desktop: !!
        Terminal: Default terminal app to host command-line apps: Windows Terminal
        # Powershell: Change execution policy to allow local PowerShell scripts to run without signingl. Require signing for remote scripts.
Windows Update: Check and fully update
    # Advanced options: Optional updates: Driver updates: !!
```
```yaml
# Disk Management
Disk Management: Disk 1: Unallocated 145.GB: New SIMPLE Volume: D: NTFS: Data
    # https://learn.microsoft.com/en-us/windows/win32/vds/volume-object
```
```yaml
# Microsoft Store:
Library: Get Updates: Update all
```

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

```yaml
# Pre-installed
Windows PowerShell              # 5.1
Windows PowerShell (x86)        # 5.1

# https://learn.microsoft.com/en-us/powershell/scripting/windows-powershell/ise/introducing-the-windows-powershell-ise?view=powershell-7.3
Windows PowerShell ISE
Windows PowerShell ISE (x86)

# Power Automate                # ... ??

# Proper via WinGet
PowerShell 7 (x64)              # 7.3.4
```


```powershell
# Check vanilla version
$PSVersionTable.PSVersion       # 5.1

# [https://learn.microsoft.com/en-us/powershell/scripting/whats-new/migrating-from-windows-powershell-51-to-powershell-7?view=powershell-7.3]
    # 'winget', ZIP package or MSI package via SCCM System Center Config Manager (https://learn.microsoft.com/en-us/mem/configmgr/apps/)
        # PWSH 5.1 :: $env:WINDIR\System32\WindowsPowerShell\v1.0
        # PWSH 7 :: $env:ProgramFiles\PowerShell\7
    # The new location is added to your PATH allowing you to run both Windows PowerShell 5.1 and PowerShell 7.
    # In Windows PowerShell 5.1, the executable is named powershell.exe. In version 6 and above, the executable is named pwsh.exe.
    # ... Separate PSModulePath
    # SEPARATE PROFILES
        # 5.1 :: $HOME\Documents\WindowsPowerShell
        # 7 :: $HOME\Documents\PowerShell
    # ...

# See current PROFILE location
$PROFILE
    # C:\Users\pquev\OneDrive\documents.MSI\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
    # ... ERROR: location can't be found -- !!
```
```powershell
# [https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.3]
    # Winget, the Windows Package Manager, ... to discover, install, upgrade, remove, and configure applications on Windows client computers.
        # This tool is the client interface to the Windows Package Manager service -- (https://learn.microsoft.com/en-us/windows/package-manager/winget/)
    # MSI via cli ... msiexec.exe /package PowerShell-7.3.4-win-x64.msi /quiet ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=1 ENABLE_PSREMOTING=1 REGISTER_MANIFEST=1 USE_MU=1 ENABLE_MU=1 ADD_PATH=1
    # Microsoft Store ... https://learn.microsoft.com/en-us/windows/msix/desktop/desktop-to-uwp-behind-the-scenes

# Using 'winget'
winget -v
winget --help
winget --info

winget search Microsoft.PowerShell
winget install --id Microsoft.PowerShell --source winget

# Allow? YES -- C:\Users\pquev\AppData\Local\Temp\WinGet\Microsoft.PowerShell.7.2.4.0\PowerShell-7.3.4-win-x64.msi
```
```powershell
# https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/02-help-system?view=powershell-7.3
Get-Help -Name -Get-Help    # -Full -Detailed -Examples -Online -Parameter NOUN - ShowWindow    | Out-GridView
Update-Help
Update-Help -UICulture en_US
    # help process
# https://learn.microsoft.com/en-us/powershell/scripting/learn/shell/dynamic-help?view=powershell-7.3
# https://learn.microsoft.com/en-us/powershell/scripting/learn/shell/creating-profiles?view=powershell-7.3
# https://learn.microsoft.com/en-us/powershell/scripting/dev-cross-plat/vscode/using-vscode?view=powershell-7.3
```

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
# winget install --id KeePassXCTeam.KeePassXC --source winget       # version 2.7.5
# winget install --id Nextcloud.NextcloudDesktop --source winget    # version 3.8.2
# winget install --id WiresharkFoundation.Wireshark --source winget # version 4.0.6.0
# winget search packettracer    # no results
# winget search neovim          # DON'T -- keep this sh within WSL  # version 0.9.1
```

```yaml
# VScode
Extensions:
  One Dark Pro
  vscode-icons
  WSL
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

<hr>


## Disk 0 Linux

### Arch

- UEFI installation

```bash
# UEFI boot via Ventoy

loadkeys es

cfdisk /dev/sda
# GPT: 1024MB EFI, 4GB Swap, 100GB Linux

mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda3
mkswap /dev/sda2 && swapon /dev/sda2

mount /dev/sda3 /mnt
mkdir -p /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi

pacstrap /mnt linux linux-firmware base base-devel grub os-prober efibootmgr networkmanager neovim git intel-ucode      # (+186)

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt
```

```bash
echo "KEYMAP=es" > /etc/vconsole.conf
nvim /etc/locale.gen
    # uncomment en_GB.UTF line
locale-gen
ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime

systemctl enable NetworkManager
echo "127.0.0.1         localhost" >> /etc/hosts
echo "archbox" > /etc/hostname

grub-install --efi-directory=/boot/efi --bootloader-id=GRUB --target=x86_64-efi
grub-mkconfig -o /boot/grub/grub.cfg

useradd -m -g users -G wheel username
passwd username
passwd root
EDITOR=nvim visudo
    # uncomment top %wheel ALL=(ALL:ALL) ALL

exit
umount -R /mnt
reboot          # remove again
```

- If encounter Boot problems, manage the BIOS/UEFI boot options

```bash
# Remove the Windows drive to avoid confusing boot entries info
# Also take a look at the actual BIOS/UEFI boot order prior to the following actions
# Now boot into Ventoy Arch again...

loadkeys es
efibootmgr
    # Let's delete everything that isn't USB, Network or Windows...
efibootmgr -b 0000 -B   # GRUB (hd1)
efibootmgr -b 0005 -B   # arch  << former entry in BIOS/UEFI Secure Boot submenu
shutdown now        # Remove Ventoy

# Power on and enter UEFI menu
# Enable SecureBoot
# Security >> Erase all SecureBoot settings && Restore SecureBoot to factory default
# Reboot
# Security >> Select UEFI file as trusted >> HDD0/EFI/GRUB/grubx64.efi >> ArchDB
# Reboot
# Boot order >> set ArchDB up only after USB
# Disable SecureBoot and power off

# Power on, succesful Arch login
# Power off, reattach Windows 11 drive
# Power on, enter BIOS/UEFI, move Windows Boot Manager boot entry to the bottom
# Reboot to Arch Linux successfully
```

- Set GRUB for **Dual Boot**...

```bash
sudo nvim /etc/default/grub
    # uncomment OS_PROBER line at the end
sudo mkdir /mnt/win11
sudo mount /dev/sdb1 /mnt/win11
# sudo os-prober    # should identify Windows
grub-mkconfig -o /boot/grub/grub.cfg
```

- Set WM, install yay

```bash
sudo pacman -S alacritty dmenu feh i3-gaps i3status lightdm lightdm-gtk-greeter light-locker picom unzip xdg-utils

sudo systemctl enable lightdm
sudo nvim /etc/lightdm/lightdm.conf
    # uncomment and change greeter-session=example... for lightdm-gtk-greeter

git clone https://github.com/pabloqpacin/dotfiles
ln -s ~/dotfiles/.config/alacritty/ ~/.config/
ln -s ~/dotfiles/.config/i3/ ~/.config/

sudo unzip ~/dotfiles/fonts/FiraMonoNerd.zip -d /usr/share/fonts/FiraMonoNerd
sudo nvim /usr/share/fontconfig/conf.avail/69-unifont.conf
    # change FreeMono for FiraMono Nerd Font
fc-cache -fv
# fc-match monospace

git clone https://aur.archlinux.org/yay.git
cd ~/yay && makepkg -si
cd $HOME && rm -rf ~/yay
yay -S brave-bin cheat-bin nvim-packer-git --nocleanmenu --nodiffmenu
yay -S librewolf-bin --nocleanmenu --nodiffmenu
# PARU ?!

sudo pacman -S brightnessctl pamixer pulseaudio
sudo systemctl --global mask pulseaudio.socket
pamixer --unmute --set-volume 80

sudo localectl set-x11-keymap es
reboot
```

- Custom environment: zsh neovim tmux ...

```yaml
# Brave browser settings
Page zoom: 90%
Appearance: Dark
# Downloads: Ask where to save: off

# Librewolf browser settings
- ...
```

```bash
sudo pacman -S bat btop exa fzf git-delta man man-pages neofetch ranger ripgrep tldr tmux zsh

ln -s ~/dotfiles/.gitconfig ~/
ln -s ~/dotfiles/.config/bat ~/.config/
ln -s ~/dotfiles/.config/btop ~/.config/
tldr -u

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
rm .zshrc && ln -s ~/dotfiles/.zshrc ~/

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
zsh && nvm install node
npm install --global live-server
# sudo pacman -S deno webkit2gtk
ln -s ~/dotfiles/.config/nvim/ ~/.config/
cd ~/.config/nvim && nvim lua/pabloqpacin/packer.lua
# :so && :PackerUpdate && :PackerCompile
    # NOTE :: problems with peek and live-server

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -s ~/dotfiles/.config/tmux/ ~/.config/
cd .config/tmux
tmux && nvim tmux.conf              # prefix-I to install plugins

cheat   # Y
ln -sf ~/dotfiles/.config/cheat/conf.yml ~/.config/cheat/
mkdir ~/.config/cheat/cheatsheets/wip
rmdir ~/.config/cheat/cheatsheets/personal
ln -s ~/dotfiles/.config/cheat/cheatsheets/personal ~/.config/cheat/cheatsheets/
```

```bash
# yay -Si timeshift
```


- Set Wi-Fi, prep disk other distros

```bash
sudo nmtui
sudo cfdisk         # two new 100GB partitions
```

- GRUB customization -- **after all other distros**

```bash
sudo mount /dev/sda4 /mnt/pop
sudo mount /dev/sda5 /mnt/suse
sudo mount /dev/sdb1 /mnt/win11

sudo nvim /etc/default/grub     # DEFAULT=6 (Win11) + TIMEOUT=15

sudo pacman -S wget
wget -O - https://github.com/shvchk/poly-dark/raw/master/install.sh | bash

sudo umount -R /mnt/*
```

<hr>


### Pop!_OS 22.04

- Ventoy installation

```yaml
Language: English US
Keyboard: Spanish Default
Install: Custom
  /dev/sda4: /          # Format: ext4
  /dev/sda1: /boot/efi  # NO FORMAT
Username: pabloqpacin
Password: ...
```

- Login back in Arch

```bash
sudo mkdir /mnt/pop
sudo mount /dev/sda4 /mnt/pop
sudo mount /dev/sdb1 /mnt/win11
sudo grub-mkconfig -o /boot/grub/grub.cfg
reboot
```

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
```bash
sudo apt update
sudo apt upgrade -y
# dpkg -l | wc -l       # (1761)
```

- Custom environment

```bash
git clone https://github.com/pabloqpacin/dotfiles
sudo unzip ~/dotfiles/fonts/FiraMonoNerd.zip -d /usr/share/fonts/FiraMonoNerd
fc-cache -fv
#   # Gnome Terminal: mine: Font: FiraMono Nerd Font
sudo apt install alacritty
ln -s ~/dotfiles/.config/alacritty ~/.config/

# zsh
sudo apt install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
rm .zshrc && ln -s ~/dotfiles/.zshrc ~/
reboot

# Rust stuff
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh  # default
# zsh     # restart Shell
cargo install bat git-delta exa ripgrep
ln -s ~/dotfiles/.config/bat ~/.config
ln -s ~/dotfiles/.gitconfig ~/
```
```bash
# Neovim
sudo apt install ninja-build gettext cmake unzip curl
git clone --depth 1 https://github.com/neovim/neovim
cd neovim && make CMAKE_BUILD_TYPE=Release
sudo make install
cd .. && rm -rf neovim

# sudo apt install build-essential
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
# zsh     # restart Shell
nvm install node
npm install --global live-server
curl -fsSL https://deno.land/x/install/install.sh | sh
# sudo apt install libwebkit2gtk-4.0-37

ln -s ~/dotfiles/.config/nvim ~/.config
cd .config/nvim && nvim lua/pabloqpacin/packer.lua
# skip error messages
# :so && :PackerUpdate && :PackerCompile

    # issues with live-server & peek...
```
```bash
sudo apt install btop fzf neofetch tldr
ln -s ~/dotfiles/.config/btop ~/.config
tldr -u
# dpkg -l | wc -l       # (1808)

# CHEAT
# TMUX
```


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