# WinServer22

<!-- > - **NOTE X**: OVA == -->
<!-- > - **NOTE 1**: ISO == Windows Server 2022 Standard Evaluation (10.0.20348.587 / x64 / en-US) -->
<!-- > - **NOTE 2**: ACTIVATION == 180 days -->


- [WinServer22](#winserver22)
  - [live installation](#live-installation)
  - [post-install config](#post-install-config)
    - [configuración escritorio](#configuración-escritorio)
    - [base](#base)
    - [dhcp + dns](#dhcp--dns)


<!-- ## documentation

- @softwarekeep.com: [Windows Server 2022 Installation Guide: Step by Step](https://softwarekeep.com/help-center/windows-server-2022-installation-guide-step-by-step#h_8995637521381682404524556) (Step 3.) -->


## live installation

- VM Settings

```yaml
# VirtualBox
Skip unattended installation: yes       # TODO: diff

Memory: 4096 MB
Processors: 4
Enable EFI: yes
Hard Disk: VDI 60 GB

Network: NAT
# Enable Secure Boot: yes
# Enable PAE/NX: yes
# Enable 3D Acceleration: no
```

<!-- ```yaml
# Proxmox
# Hyper-V
# KVM
``` -->

- Installation

```yaml
# Lang, Time and Keyboard
OS Edition: Windows Server 2022 Standard Evaluation (Desktop Experience)
Installation: Custom    # Next
```
<!-- 

=== CORE ===

```yaml
# C:\Windows\system32\LogonUI.exe
    # Administrator
    # The user's password must be changed before signing in.
OK: enter

# Enter new credentials for Administrator or hit ESC to cancel
New password:   # changeme
# Unable to update the password. The value provided for the new password does not meet the length, complexity or history requirements of the domain.
New password:   # susodicho882;;
```

- **SConfig**

```yaml
# WARNING: To stop SConfig from launching at sign-in, type "Set-SConfig -AutoLaunch $false"

# Welcome to Windows Server 2022 Standard Evaluation

# 1) Domain/workgroup:          Workgroup: WORKGROUP
# 2) Computer name:             WIN-VRQVQFS0HHP
# 3) Add local administrator
# 4) Remote management:         Enabled

# 5) Update setting:            Download only
# 6) Install updates
# 7) Remote desktop:            Disabled

# 8) Network setting
# 9) Date and time
# 10) Telemetry setting:        Required
# 11) Windows Activation:

# 12) Log off user
# 13) Restart server
# 14) Shut down server
# 15) Exit to command line (PowerShell)


6 - Install updates:
    # Search for: 1) All quality updates 2) Recommended quality updates only 3) Feature updates
    1 - All quality updates:
        # Available update(s): 2022-02, 2023-10, KB22267602
        All updates

# 2: Add local administrator: foo
``` -->

```yaml
Username: Administrator
Password: ...
```

## post-install config

> Ctrl+Alt+Del on Guest == Right Ctrl+Supr on Host

### configuración escritorio

```yaml
Configuracion:
    Personalizacion:
        Colores:
            Color: Oscuro
        Barra de tareas:
            Ocultar automaticamente: yes
            Usar botones pequenos: yes
    Actualizacion y seguridad:
        Para programadores:
            Explorador de archivos: Aplicar 5 casillas
```

### base

- brave

```ps1
$brave_pkg = 'BraveBrowserSetup-BRV011.exe'

Invoke-WebRequest -Uri https://referrals.brave.com/latest/$brave_pkg -OutFile $brave_pkg
Start-Process $brave_pkg -Wait

Remove-Item $brave_pkg
```

- vscode

```ps1
$vscode_pkg = 'VSCodeSetup-x64-1.84.2.exe'
$vscode_url = 'https://az764295.vo.msecnd.net/stable/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/'
Invoke-WebRequest -Uri ($vscode_url + $vscode_pkg) -OutFile $vscode_pkg

# no aplica el argumento 'addcontextmenufolder'
$arguments = '/SILENT /mergetasks=!runcode,addcontextmenufiles,addcontextmenufolder'
Start-Process -FilePath $vscode_pkg -ArgumentList $arguments -Wait

Remove-Item $vscode_pkg

# TODO: extensions ...
```

- Terminal

```ps1
$lib_pkg = 'Microsoft.VCLibs.x64.14.00.Desktop.appx'
Invoke-WebRequest -Uri https://aka.ms/$lib_pkg -OutFile $lib_pkg
Add-AppxPackage $lib_pkg

# $terminal_pkg = 'Microsoft.WindowsTerminal_1.7.1091.0_8wekyb3d8bbwe.msixbundle'
# Invoke-WebRequest -Uri https://github.com/microsoft/terminal/releases/download/$terminal_pkg -OutFile $terminal_pkg
$terminal_pkg = 'Microsoft.WindowsTerminal_Win10_1.14.2281.0_8wekyb3d8bbwe.msixbundle'
Invoke-WebRequest -Uri https://github.com/microsoft/terminal/releases/download/v1.14.2281.0/$terminal_pkg -OutFile $terminal_pkg
Add-AppxPackage $terminal_pkg

Remove-Item $lib_pkg
Remove-Item $terminal_pkg

# TODO: settings.json ...
```

- pwsh7

```ps1
$pwsh7_pkg = 'PowerShell-7-4-0-win-x64.msixbundle'

Invoke-WebRequest -Uri https://github.com/PowerShell/PowerShell/releases/download/v7.4.0/$pwsh7_pkg -OutFile $pwsh7_pkg

Add-AppxPackage $pwsh7_pkg

Remove-Item $pwsh7_pkg
```


### dhcp + dns

> ...



<!--

```yaml
# Networks
# Do you want to allow your PC to be discoverable by other PCs and devices on this network?
Discoverable Host: yes

# Server Manager
# Windows Admin Center brings together new and familiar features in one browser-based app. It runs on a server or a PC, and there's no additional cost beyond your Windows licenses.
Don't show this mssage again: no
```
- VBox guest additions
 
```yaml
CD: execute
    # C:\Program Files\Oracle\VirtualBox Guest Additions
    # Reboot now
```

- Updates and tweaks

```yaml
# Settings
Windows Update:
    check for updates
    # some settings are managed by the organizacion **(View policies)**
        # automatically download and install updates, except on metered connections; in that case, automatically download only those required to keep Windows running smoothly
        # Policies set on device:
            # - Download the updates automatically and notify when they are ready to be installed -- Source:Administrator -- Type:Group Policy
            # - Set Automatic Update options -- Source:Administrator -- Type:Group Policy

For developers:
    File Explorer: Apply   # show file extensions, show hidden and system files, full path in title bar, show Run as different user in Start, show empty drives

Personalization:
    # Colors: ...
    Taskbar:
        - Automatically hide the taskbar: yes
        - Use small taskbar buttons: yes
```

```yaml
# Server Manager
# Try Windows Admin Center and Azure Arc today
# Instead of Server Manager, you can use Azure Arc and the new Windows Admin Center built into the Azure portal to manage individual servers and clusters-on-premises and in Azure.
# With Azure Arc you can secure and govern Windows Server at scale-on-premises and across clouds. You can also automate operations and apply best practices across the lifecycle of your server with Azure Automanage.
```

- PowerShell

```ps1
# ...
```

-->