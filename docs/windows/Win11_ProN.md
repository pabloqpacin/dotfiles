# Windows 11 Pro N


- [Windows 11 Pro N](#windows-11-pro-n)
  - [live-installation](#live-installation)
  - [post-install config](#post-install-config)
    - [Windows Desktop](#windows-desktop)
    - [Basic Environment](#basic-environment)
    - [Shell Environment](#shell-environment)


> - **NOTE 1:** `winget`-heavy approach
> - **NOTE 2:** ditching Home for the Pro N edition
> - **NOTE 3:** Home won't allow for Sandbox or Hyper-V
> - **NOTE 4:** VirtualBox VMs don't allow for WSL|Docker apparently
> - **NOTE 5:** Accounts --> offline anon for VMs, licenced personal for bare-metal
> - **NOTE 6:** getting to grips with the PowerShell environment -- even on my [Pop!_OS](/docs/linux/Pop!_OS.md) box

<!--
> - TODO: vmware/qemu
> - TODO: WSL1 -- no nested virt
> - TODO: OneNote (personal account) << MS Store
> - TODO: winver lusrmgr.msc gpedit.msc secpol.msc
> - TODO: package-manager solutions, PowerShell, HKEYs, containers, ...
 -->


## live-installation

- VM settings

```yaml
# VirtualBox Settings
ISO: Win11_22H2_EnglishInternational_x64v2.iso

Memory: 8192 MB
Processors: 4
Enable EFI: yes
Hard Disk: VDI 80 GB

Network: Bridged Adapter
Skip Unattended Installation: yes
Enable 3D Acceleration: no
Enable PAE/NX: yes
```
<!-- ```yaml
# Other Hypervisors -- KVM
# ...
``` -->

- Windows installation

```yaml
# Set: Lang Locale Keyboard
Activate Windows: I don't have a product key
Operating System: Windows 11 Pro N                          # Home OK
Type of installation: Customised
  # Drive X: HDD for backups
  # Drive Y: 2TB NVMe for Linux
  Drive Z: New            # either Virtual Disk or 1TB NVMe for Windows
    Size: 81920 MB      # if VM...
    Size: 204900 MB     # if baremetal...
                        # min. 3 Partitions atm: System MSR Primary -- + baremetal 2: DriverCD Unallocated
```
```yaml
# Set: Region Keyboard Hostname
Setup: Personal use

# VM: offline anon account
Sign in: no@thankyou.com
  # Password: anything
  # Name: somename
  # Password: ...
  # Security questions: changeme

# Baremetal: licenced MS account
Sign in: myaccount@gmail.com
  # Restore: Set up as new device
  # PIN: ...

Location: No
Find device: No
Diagnostic data: Required only
Improve inking: No
Tailored exp: No
Ad ID: No
# Customise experience: Skip

# Use Phone from PC: Skip
# OneDrive: Next
# Microsoft 365: Decline
# 100 GB Cloud: Decline
```

- If VM, set drivers asap

```yaml
# Virtual Box VM
Devices: Insert Guest Additions CD Image
File Explorer: .\VBoxWindowsAdditions-amd64.exe   # C:\Program Files\Oracle\VirtualBox Guest Additions
# Eject and Reboot now
```
<!-- ```yaml
# TODO: KVM
# ...
``` -->


## post-install config


### Windows Desktop

- Tweak them settings & system update (GUI)

```yaml
Settings:
  # System:
    # -- Activation: Windows is activated with a digital licence linked to your Microsoft account
    # -- Activation: Troubleshoot                # 90 days if Enterprise Evaluation
    # Power and Battery: Energy Recommendations .. Balanced Power Mode
  Personalization:
    Themes: Windows (dark)
    # Background: Choose a photo
    # Lock screen: Windows spotlight
    # Colors: Purple shadow + Show accent colour on title bars and window borders
    Taskbar:
      - Items: OFF Search TaskView Widgets Chat
      - Behavior: Automatically hide the taskbar
    Start:
      - Folders: ON Settings
  Privacy and Security:
    For developers:
      - File Explorer: ON all
      - Default Terminal: Windows Terminal
      # - PowerShell: OFF Allow local scripts without signing.
    # Windows Security: all green if possible
  Windows Update: Download & install all
    # Advanced options: Optional updates: ...

MS Store:
  Library: Get updates & Update all
```

- Debloat Windows 11 (Home|Pro)

```yaml
# TODO: double-check
Start Menu:
  Uninstall: Instagram Messenger Netflix Prime_Video

Settings:
  Apps:
    Uninstall: Clipchamp Family MS_News Solitaire Weather
    Startup:    # likely later
      OFF: MS_Edge MS_Teams Steam Discord
      ON: Spotify
```

- If baremetal: manage disks, drivers & install them desktop apps

```yaml
# Better keep the OS and the Data apart dawg
Disk Management:
  Disk Z (Unallocated 750 GB): New Simple Volume
    D: NTFS Data .. Enable file and folder compression
```
```powershell
# Likely after WinGet tweaks
winget install Spotify.Spotify
winget install Discord.Discord
winget install Valve.Steam
```
<!-- # Install DS1 -> D:\STEAMLIBRARY ~~C:\PROGRAM FILES (X86)\STEAM~~ -- FIXME: Start Menu shortcut -->

```yaml
# Prep Nvidia if applicable -- likely after WinGet & Brave
nvidia.es: 'GeForce RTX 3060 Laptop GPU drivers'
    # Extraction path: C:\NVIDIA\DisplayDriver\5.36.40
installer: NVIDIA Graphics Driver and GeForce Experience
  options: Express      # || Custom...
    # NVIDIA Login :: Google account
```


### Basic Environment

<!-- - PowerShell 101: [WinGet](/windows/settings/WinGet/settings.jsonc), dotfiles, [$PROFILE](/windows/Microsoft.PowerShell_profile.ps1), shell & system packages -->


- Tweak WinGet & install PowerShell 7

```powershell
$PSVersionTable             # PSVersion: 5.1
$PROFILE                  # C:\Users\User(\OneDrive)\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1

winget --info; winget settings

<#  // notepad.exe $env:LocalAppData\Packages\Microsoft.DesktopAppInstaller_...\settings.json
  "telemetry": { "disable": true },
  "network": { "downloader": "wininet" },
  "visual": { "progressBar": "rainbow" }
#>

winget install Microsoft.Powershell
  # Downloading https://github.com/PowerShell/PowerShell/releases/download/v7.3.6/PowerShell-7.3.6-win-x64.msi
```
```powershell
$PSVersionTable             # PSVersion: 7.3
$PROFILE                      # C:\Users\User(\OneDrive)\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
$PROFILE | Select-Object *      # ...

<#
  Get-ExecutionPolicy -List
  Set-ExecutionPolicy Unrestricted -Scope Process
  Install-Module PSWindowsUpdate  # [A]
  Import-Module PSWindowsUpdate; Install-WindowsUpdate -AcceptAll
  Restart-Computer
#>

winget list; winget update
winget upgrade --all
```

- Install Brave, clone them dotfiles, tweak VSCode & Windows Terminal

<!--
(exe|msi): Add Open with Code action to Windows Explorer menu 
# todo: ~~git~~ + GH auth + ~~dotfiles~~
# $ winget install neofetch


# $ winget install devcom.lua
# $ winget install gnuwin32.tree -- DON'T!!!
# https://mark0.net/soft-trid-e.html << file command... sec vul
winget show exiftool

libre office
 -->


```powershell
winget install Microsoft.VCRedist.2015+.x64
winget install VSCode Brave.Brave
winget install Git.Git

git clone https://github.com/pabloqpacin/dotfiles "$env:HOMEPATH\dotfiles"

New-Item -ItemType SymbolicLink -Target "$env:HOMEPATH\dotfiles\.gitconfig" -Path "$env:HOMEPATH\.gitconfig"
New-Item -ItemType SymbolicLink -Target "$env:HOMEPATH\dotfiles\.config\powershell\Microsoft.PowerShell_profile.ps1" -Path "$PROFILE"   # VERIFY

<#
  - Download, extract and install a NerdFont -- https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip
  - Install VSCode extensions as needed -- https://github.com/pabloqpacin/dotfiles/blob/main/.config/code/User/extensions.log
#>
```
<details>

```jsonc
// VSCode|VSCodium settings -- tweak as needed

{
    "telemetry.telemetryLevel": "crash",
    "explorer.confirmDragAndDrop": false,
    "explorer.confirmDelete": false,
    "workbench.startupEditor": "none",
    "editor.fontFamily": "FiraCode Nerd Font",
    // "terminal.integrated.fontSize": 13,
    // "editor.fontSize": 13,
    "editor.rulers": [
      80, 115       
    ],
    "window.zoomLevel": -0.5,
    "workbench.iconTheme": "vscode-icons",
    "workbench.colorTheme": "One Dark Pro Darker",
    "vsicons.dontShowNewVersionMessage": true
} 
```

```jsonc
// Windows Terminal settings -- WSL is dealt with later on

{
  // "actions": [ <tmux-like vim-motions> ],
  "defaultProfile": "<pwsh>",
  "launchMode": "maximized",
  "profiles":
  {
    "list":
    [
      {
        "font": { "size": 10.0, "face": "FiraCode Nerd Font" },
        "name": "PowerShell",
        "opacity": 80
      },
      { "name": "Azure Cloud Shell" },
      { "name": "Command Prompt" },
      { "name": "Windows PowerShell", "hidden": true },
      /* WSL
          - Debian
          - openSUSE-Tumbleweed
          - Ubuntu
          - Kali
          - ... Arch?
          - ... Nix?
      */
    ]
  },
  // "schemes": [ ... ]
  // "themes": [ ... ]
    "useAcrylicInTabRow": true
}
```

</details>


### Shell Environment

- Basic cross-platform utitilies

```powershell
winget install fzf zoxide
winget install 'ripgrep gnu'
winget install dandavison.delta
winget install sharkdp.bat jftuga.less

mkdir $env:AppData\bat
echo '--theme="OneHalfDark"' >> $env:AppData\bat\config

winget install tldr
tldr --update
```
- Neovim setup -- prep Chocolatey

```powershell
winget install Neovim.Neovim.Nightly
git clone https://github.com/wbthomason/packer.nvim "$env:LocalAppData\nvim-data\site\pack\packer\start\packer.nvim"

winget install 'nvm for windows'
nvm install node
nvm use <20.5.1>

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco install mingw -y

New-Item -ItemType SymbolicLink -Target "$env:HOMEPATH\dotfiles\.config\nvim" -Path "$env:LocalAppData\nvim"
cd $env:LOCALAPPDATA\nvim; nvim lua\pabloqpacin\packer.lua
  # :so :PackerSync :MasonUpdate
```

<!-- - Set up oh-my-posh

```powershell
# TODO
``` -->

<!-- BUILD lf LOL
$env:CGO_ENABLED = '0'
go install -ldflags="-s -w" github.com/gokcehan/lf@latest -->

<!-- 
# $ choco install python vscode git WSL2 openssh openvpn
# winget install llvm clangd

# keepassxc cli??
 -->

- Proper workstation

```powershell
# winget install imhex
winget install KeePassXC
winget install npcap wireshark
# winget install SleuthKit.Autopsy
winget install CPUID.CPU-Z REALiX.HWiNFO
winget install 9P7KNL5RWT25 --source msstore          # Sysinternals Suite
winget install Microsoft.Powertoys --source winget    # tweak 'Run at startup' -- see 'TaskScheduler'/logon
```

<!-- 
---


### Pro Environment

- aye: wsl docker hyper-v sandbox -->

<!--



- TODO: virtualbox

```powershell
winget install Oracle.VirtualBox --source winget
```

- TODO: WSL 'Docker Desktop'

```powershell
# TODO: wsl --update; wsl --install
# TODO: winget install 'Docker Desktop'
```

- Set up Windows Sandbox, Hyper-V & WSL -- mind actual GUI -- **VirtualBox INOP**

```bash
# FAIL to enable nested virtualization for VirtualBox on Linux host
vboxmanage list vms
vboxmanage modifyvm <VMName> --nested-hw-virt on
```
```powershell
# Enable nested virtualization on Windows host -- Hyper-V??
Set-VMProcessor -VMName <VMName> -ExposeVirtualizationExtensions $true
```
```powershell
# Install Windows Sandbox -- !Home
Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online

# Install Hyper-V -- !Home
Enable-WindowsOptionalFeature -FeatureName "Microsoft-Hyper-V" -All -Online
    # $ DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V
```
```powershell
# Install Virtual Machine Platform + WSL (MS Store) + <distro>
wsl -l -o
wsl --install -d Ubuntu
# wsl --install -d Debian
# wsl --install -d openSUSE-Tumbleweed
# wsl --set-default <distro>


# wsl --update
wsl -l -v
wsl --status
wsl --version

# wsl --inbox           # TODO
# wsl --web-download    # TODO
                        # import || export
```

> See WSL distros setup: [Debian](/docs/windows/WSL_Debian.md), Tumbleweed


- Set up Docker with WSL

```powershell
# PowerShell INOP...
# $ winget install --id Docker.DockerCLI --source winget          # ??
# $ winget install --id Docker.DockerDesktop --source winget      # 'Installer hash does not match'
```

```yaml
Brave:
  docker.com: Download Docker Desktop Installer for Windows

File Explorer: Docker_Desktop_Installer.exe

# 'Installing Docker Desktop 4.21.0 (113844)'
Use WSL 2 instead of Hyper-V: yes
Add shortcut to desktop: no

# ... Restart
```


