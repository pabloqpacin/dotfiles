# Windows 11 Pro


- [Windows 11 Pro](#windows-11-pro)
  - [live-installation](#live-installation)
  - [post-install config](#post-install-config)
    - [Windows Desktop](#windows-desktop)
    - [Basic Environment](#basic-environment)
    - [Proper Environment](#proper-environment)
      - [WSL](#wsl)
      - [Docker](#docker)
      - [Hyper-V ](#hyper-v-)
      - [AppLocker](#applocker)


> - **NOTE 1:** `winget`-heavy approach
> - **NOTE 2:** ditching Home for the Pro edition
> - **NOTE 3:** Home won't allow for Sandbox or Hyper-V
> - **NOTE 4:** VirtualBox VMs apparently don't allow for WSL|Docker
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

<details>

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
```yaml
# KVM/QEMU -- https://getlabsdone.com/how-to-install-windows-11-on-kvm

# Install Hypervisor
sudo apt install bridge-utils virt-manager libosinfo-bin

# Download latest drivers --> https://github.com/virtio-win/virtio-win-pkg-scripts/blob/master/README.md

# Create Win11 VM
Virtual Disk: from SATA for VirtIO
Virtual Network Interface: from e1000e to virtio

Hardware:
  Graphics: from Spice to VNC
  Storage:Manage: /home/pabloqpacin/Downloads/virtio-win-0.1.229.iso
    Device: from Disk to CDROM
  TPM: from CRB to TIS 2.0

Boot order: CDROM1 VirtIO1 CDROM2
CPUs: vCPU4, sockets1, cores2, threads2
Overview: Chipset ~~from Q35 to i440FX~~ /usr/share/OVMF/OVMF_CODE_4M.secboot.fd

# BEGIN INSTALLATION

Type: Custom
Load driver: E:\amd64\w11\viostor.inf
Disk 1 (UNALLOCATED): Next

# ... no internet
Shift+F10 (CMD): oobe\bypassnro

# local account...

Device Manager:
  Other Drivers:
    - Ethernet: update (E:\)
    - ... else: udpate (E:\)
  Display adaptor:
    - Microsoft: update (E:\)

# Shutdown

CDROM1: remove
CDROM2: remove

# For snapshots, change XML 'os' from 'pflash' to 'rom', take snapshot, then change again ([src](https://www.reddit.com/r/kvm/comments/9s6jt4/unable_to_create_snapshots/))

# TODO: tweak screen resolution -- https://gitlab.com/qemu-project/qemu/-/issues/731
```

<!--
VMware keyz
1F0N8-D6202-MJ829-0J9Z6-2LHHF
NZ212-6T04L-4JDG8-0AAQ4-8GRNA
HF0XU-82114-4JEX0-0T256-3U816
-->

<!-- ```yaml
# VMWare (Windows Host)

# IF HYPER-V ENABLED (NOT IF VANILLA(~~WSL~~)...):: Turn Windows features:: Windows Hypervisor Platform

VMware: new default locations (..\Downloads\VMware VMs)
  New VM:
    options: encrypt
    add hardware:
      - TPM
      # Processors: Virtualize intel VTX

# https://superuser.com/questions/1578372/run-wsl2-inside-vmware-workstation-15
# ?? wsl Host **incompatible** wsl Guest ?? 
``` -->


<!-- > If unsupported, try [bypassing TPM checks](https://www.tomshardware.com/how-to/bypass-windows-11-tpm-requirement)... -->


- Windows installation

```yaml
# Set: Lang Locale Keyboard
Activate Windows: "I don't have a product key"
Operating System: Windows 11 Pro                          # Home OK
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

</details>


## post-install config


### Windows Desktop

<details>

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
    # Start:
    #   - Folders: ON Settings
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
  # Especially 'App Installer' for WinGet=>1.5
```

- Debloat Windows 11 (Home|Pro)

```yaml
# TODO: double-check
Start Menu:
  Uninstall: Instagram Linkedin Messenger Netflix Prime_Video

Settings:
  Apps:
    Uninstall: Clipchamp Family MS_News Solitaire Weather
    Startup:    # likely later
      OFF: MS_Edge MS_Teams Steam Discord
      ON: Spotify
```
```sh
# notepad C:\Windows\System32\drivers\etc\hosts --  https://youtu.be/IJr2DcffquI
127.0.0.1       localhost
::1             localhost
127.0.0.1       data.microsoft.com
127.0.0.1       msftconnecttest.com
127.0.0.1       azureedge.net
127.0.0.1       activity.windows.com
127.0.0.1       bingapis.com
127.0.0.1       msedge.net
127.0.0.1       assets.msn.com
127.0.0.1       scorecardresearch.com
127.0.0.1       edge.microsoft.com
127.0.0.1       data.msn.com

# Edge: Clear browsing data
```

- If baremetal: fix time, manage disks, drivers & install them desktop apps

```powershell
# Fix two hours behind if multiboot -- https://wiki.archlinux.org/title/System_time#UTC_in_Microsoft_Windows
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /d 1 /t REG_DWORD /f
```
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

- If VM, install OpenGL drivers

```powershell
winget search opengl
winget install 9NQPSL29BFFF     # OpenCLTM and OpenGL Compatibility Pack
```

</details>


### Basic Environment

- Tweak WinGet, install PowerShell 7

```powershell
$PSVersionTable             # PSVersion: 5.1
$PROFILE                  # C:\Users\User(\OneDrive)\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1

winget --info; winget settings

<#  // notepad.exe $env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_...\settings.json
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
```

- Github SSH auth & installation script -- run `pwsh` as administrator

```powershell
# Set up SSH auth for Github
ssh-keygen -t ed25519 -C "my@email.com"     # skip
cat ~/.ssh/id_25519.pub
  # github.com > profile settings > add New SSH
ssh -T git@github.com                    # yes

# Curl and run big time script
curl https://raw.githubusercontent.com/pabloqpacin/dotfiles/main/windows/scripts/SW_install-symlink.ps1 --output self.ps1
.\self.ps1;   # rm self.ps1
```

- Tweak Brave, Terminal & VSCode
  - **Terminal**: tweak [settings.json](/windows/settings/Terminal/settings.jsonc)
  - **VSCode**: tweak [settings.json](/.config/code/User/settings.jsonc) and install the relevant [extensions](/.config/code/User/extensions.log)
  - **Brave**: enable the '*Dark Reader*' and '*KeePassXC*' extensions


### Proper Environment

- Tweak Taskbar for proper keybinds (`Win+number`)

```yaml
Taskbar:
  1: Terminal
  2: Brave
  3: Code
  4: ...
```

- Complete setup post-scripts

```powershell
# Verify TLDR and Neovim
tldr --update
nvim $PROFILE

# Python & fortunes
python -m pip list
python -m pip install --upgrade pip
pip install fortune
  # cd $env:HOMEPATH\dotfiles; .\windows\scripts\fortunes_curl.ps1
  # curl https://raw.githubusercontent.com/bmc/fortunes/master/fortunes --output $HOMEPATH\dotfiles\docs\fortunes\fortunes_bmc

# Chocolatey
  # Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    # choco install mingw -y

# Misc packages
winget install keepassxc `
               autohotkey.autohotkey `
               cpuid.cpu-z realix.hwinfo `
               nmap npcap wireshark portmaster `
               gitkraken 7zip.7zip `

# Sysinternals & Powertoys
winget install 9P7KNL5RWT25 --accept-package-agreements     # Sysinternals Suite
winget install Microsoft.Powertoys                          # tweak 'Run at startup' -- see 'TaskScheduler'/logon

go install crg.eti.br/go/neko@latest  # https://github.com/crgimenes/neko

# PWSH stuff
Find-Module -Name AdminToolbox | Install-Module   # Y
```

- If VM, tweak `nmap` with `--unprivileged` ([src](https://stackoverflow.com/questions/59571784/after-installing-nmap-dnet-failed-to-open-device-eth0))

```powershell
# nmap --iflist
nmap --unprivileged -Pn localhost
```

---

> WIP: Nested virtualization


#### WSL

```powershell
# wsl --update
wsl --install -d Debian

# Enable systemd -- https://gist.github.com/djfdyuruiry/6720faa3f9fc59bfdf6284ee1f41f950
sudo echo -e "[boot]\nsystemd=true" >> /etc/wsl.conf
  # https://learn.microsoft.com/en-us/windows/wsl/wsl-config#wslconf
```

#### Docker

```powershell
winget install docker.dockerdesktop
```

#### Hyper-V <!--/ VirtualBox-->

- If Windows Pro: Sandbox & Hyper-V

```powershell
# Enable Sandbox
Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online

# Enable Hyper-V
Enable-WindowsOptionalFeature -FeatureName "Microsoft-Hyper-V" -All -Online

# Enable nested virtualization for WSL on Windows VM via Hyper-V
Set-VMProcessor -VMName 'Win11' -ExposeVIrtualizationExtensions $true
  # GUI: Turn Windows optional feature: Virtual Machine platform

# For them Hyper-V VMs, might need to "create new Virtual Network Switch"
```

<!-- ```powershell
# Windows 11 Home HOST -- VirtualBox -- Windows 11 Home Guest ----- FAIL
# GUI: Turn Windows optional feature: Virtual Machine platform
cd $env:PROGRAMFILES\Oracle\VirtualBox; .\VBoxManage.exe modifyvm 'Win11' --nested-hw-virt on
``` -->

---

#### AppLocker


---

<!-- 
# $ choco install WSL2 openssh openvpn
# $ winget install imhex SleuthKit.Autopsy
# $ winget install neo-cowsay neofetch devcom.lua gnuwin32.tree(NOPE) exiftool libreoffice
# https://mark0.net/soft-trid-e.html << file command... sec vul


 -->

<!-- 
- TODO: virtualbox

$ winget install Oracle.VirtualBox --source winget


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
-->

