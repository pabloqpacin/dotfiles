# WinServer22

<!-- > - **NOTE X**: OVA == -->
> - **NOTE 1**: ISO == Windows Server 2022 Standard Evaluation (10.0.20348.587 / x64 / en-US)
> - **NOTE 2**: ACTIVATION == 180 days


- [WinServer22](#winserver22)
  - [live installation](#live-installation)
  - [post-install config](#post-install-config)
    - [101](#101)


<!-- ## documentation

- @softwarekeep.com: [Windows Server 2022 Installation Guide: Step by Step](https://softwarekeep.com/help-center/windows-server-2022-installation-guide-step-by-step#h_8995637521381682404524556) (Step 3.) -->


## live installation

- VM Settings

```yaml
# VirtualBox
Skip unattended installation: yes       # TODO: diff

Memory: 8192 MB
Processors: 4
Enable EFI: yes
Hard Disk: VDI 60 GB

Network: Bridged Adapter
Enable Secure Boot: yes
Enable PAE/NX: yes
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
<!-- ```yaml
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
User name: Administrator
Password: ...
```

## post-install config

> Ctrl+Alt+Del on Guest == Right Ctrl+Supr on Host

### 101

- First boot

```yaml
# ...
```

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