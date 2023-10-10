# medocs

> WIP

---

## Multiboot

<details>
<summary>Documentation</summary>

- Youtube
  - @KskRoyal: [How to Dual Boot Arch Linux and Windows 11/10 [2022]](https://youtu.be/JRdYSGh-g3s)
  - @KskRoyal: [How to Dual Boot Pop OS 22.04 LTS and Windows 11 2023 (EASIEST WAY)](https://youtu.be/qYqPBrTudUY)
  - @SavvyNik: [Arch Linux Install and Dual Boot with Windows 10 (UEFI) | Step by Step w/ Networking Tutorial](https://youtu.be/LGhifbn6088)
- Gist/Article
  - @Weywot: [Dual Boot Pop!_OS with Windows using systemd-boot](https://github.com/spxak1/weywot/blob/main/Pop_OS_Dual_Boot.md)
  - @System76: [Dual-Booting Windows](https://support.system76.com/articles/windows/#installing-on-a-dedicated-drive)

</details>


### notes

- **Hyprland** won't perform well in a vm
- Using [Ventoy](https://github.com/ventoy/Ventoy) as the bootable flashdrive solution
- Nowadays never choosing to create a separate /home partition
- Mind the software selection in terms of CPU and GPU firmware
- Mind them differences between a vm and a baremetal installation
- One dedicated drive for Windows and another one with GRUB for them Linux distros
- Tried multiboot (Arch+Windows & ProxmoxVE) but GRUB won't create a menu entry for Proxmox
<!-- - Pretty basic *NixOS* setup atm, looking forward to incorporate **home-manager** and more
- Also looking forward to incorporate **cron**, a backup system and a proper password manager -->

### steps


1. If existing OS, back up everything as we'll fully format the drives
2. Take a look at the BIOS/UEFI boot and secure-boot settings
3. Install [Windows 11](/docs/windows/Win11_Pro.md) to drive A
   - Get a Home version licence, choose Home or Pro
   - Repartition the disk. There will be a boot partition and a primary C:\\. Create a another D:\\ partition for Data. Let's keep it clean.
4. Install [Arch Linux or NixOS](/docs/linux/) to drive B
   - The fun begins
   - Follow my documentation but mind the software selection in terms of CPU and GPU firmware
   - Focused on the WMs Hyprland and i3 but it's a lotta work, a whole DE should be just fine
   - Set the bootloader correctly for UEFI or BIOS. I use GRUB with `os-prober`. Theme it.
5. Reboot into Arch / NixOS
   - Probably fail, meaning the Windows bootloader hasn't relinquished its boot priority
6. Boot into the BIOS/UEFI
   - Move the Windows Bootloader down -- drive A
   - Move the relevant EFI partition with GRUB on top, just below the USBs -- drive B
   - The CLI tool `efibootmgr` may come in handy against boot problems
7. Boot into Arch / NixOS successfully
   - On minimal Arch, always `mkdir` mountpoints and `mount` the relevant partitions, then update GRUB
8. Install [another distro](/docs/linux/Pop!_OS.md) to drive B
   - Whatever the distro, just create one ext4 partition and mount the existing boot and swap partitions
   - I believe it's very important: whatever the distro, just create one ext4 partition and mount the existing boot and swap partitions
   - If installing *openSUSE-Tumbleweed*, be careful about [Btrfs](https://en.opensuse.org/SDB:BTRFS). Great filesystem but I couldn't multiboot into it.
   - Not sure how or why, but I couldn't install two instances of NixOS, they'd blend...
9.  Boot back into Arch / NixOS
    - Update or rebuild the bootloader
10. Verify and repeat
    -  Find all the OSs on the GRUB menu and verify they'll boot right
    -  That's about it!

---


### Windows documentation


<details>


- [Windows Terminal: custom actions](https://learn.microsoft.com/en-us/windows/terminal/customize-settings/actions):
- [Windows Enterprise Evaluation -- Windows 11 development environment (90 days)](https://developer.microsoft.com/en-us/windows/downloads/virtual-machines/)
- [MSIX -- Understanding how packaged desktop apps run on Windows](https://learn.microsoft.com/en-us/windows/msix/desktop/desktop-to-uwp-behind-the-scenes)
- PowerShell
  - [Installing PowerShell on Windows](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.3)
  - [Migrating from Windows PowerShell 5.1 to PowerShell 7](https://learn.microsoft.com/en-us/powershell/scripting/whats-new/migrating-from-windows-powershell-51-to-powershell-7?view=powershell-7.3)
  - [The Windows PowerShell ISE](https://learn.microsoft.com/en-us/powershell/scripting/windows-powershell/ise/introducing-the-windows-powershell-ise?view=powershell-7.3)
  - [about_Profiles](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.3)
  - [Customizing your shell environment](https://learn.microsoft.com/en-us/powershell/scripting/learn/shell/creating-profiles?view=powershell-7.3)
  - [The Help System](https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/02-help-system?view=powershell-7.3)
  - [Using dynamic help](https://learn.microsoft.com/en-us/powershell/scripting/learn/shell/dynamic-help?view=powershell-7.3)
  - [Using Visual Studio Code for PowerShell Development](https://learn.microsoft.com/en-us/powershell/scripting/dev-cross-plat/vscode/using-vscode?view=powershell-7.3)
- [Windows Sandbox](https://learn.microsoft.com/en-us/windows/security/application-security/application-isolation/windows-sandbox/windows-sandbox-overview)
- [Install Hyper-V on Windows 10](https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v)
- WinGet
  - [Use the winget tool to install and manage applications](https://learn.microsoft.com/en-us/windows/package-manager/winget/)
  - ["Download speed is slower than manually download."](https://github.com/microsoft/winget-cli/issues/1860)
  - [WinGet CLI Settings](https://github.com/microsoft/winget-cli/blob/master/doc/Settings.md)
- Chocolatey
  - [Installing Chocolatey](https://chocolatey.org/install#individual)
  - [Getting Started](https://docs.chocolatey.org/en-us/getting-started)
  - [Commands: Install](https://docs.chocolatey.org/en-us/choco/commands/install)
- [Scoop](https://scoop.sh/)
- *posh*
- [posh-git...](https://github.com/dahlbyk/posh-git)
- [nvim treesitter windows](https://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support)
---
- WSL
  - Setup
    - [WSL Install](https://learn.microsoft.com/en-us/windows/wsl/install)
    - [WSL Install manual](https://learn.microsoft.com/en-us/windows/wsl/install-manual)
    - [WSL Basic Commands](https://learn.microsoft.com/en-us/windows/wsl/basic-commands#install)
    - [WSL Environment Setup](https://learn.microsoft.com/en-us/windows/wsl/setup/environment)
    - [WSL Git credentials](https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-git#git-credential-manager-setup)
    - [WSL Containers](https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-containers)
    - [WSL Databases](https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-database)
    - [WSL Custom Distro](https://learn.microsoft.com/en-us/windows/wsl/build-custom-distro)
    - [WSL **Arch**](https://learn.microsoft.com/en-us/windows/wsl/use-custom-distro)
  - Troubleshooting
    - [FAQs about Windows Subsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/faq)
    - [VirtualBox Nested Virtualization -- Error 0x80370702](https://github.com/microsoft/WSL/issues/5430)
    - [WSL Troubleshooting -- INOP 0x80370102 INOP + Networking + ...](https://learn.microsoft.com/en-us/windows/wsl/troubleshooting)
    - [WSL2 not working within Windows 10 VM in VirtualBox on Ubuntu 18.04.5 LTS](https://askubuntu.com/questions/1286352/wsl2-not-working-within-windows-10-vm-in-virtualbox-on-ubuntu-18-04-5-lts)
  - More
    - `.wslconfig`
    - `wsl.conf`
    - [Version 1 VS 2](https://learn.microsoft.com/en-us/windows/wsl/compare-versions)
    - [@Fazt: Docker](https://youtu.be/ZO4KWQfUBBc)
    - [Custom Kernel](https://youtu.be/a6uR-iGVh7k)
    - [More on Kernel](https://youtu.be/6lqMeg_n7l4)
- QEmu
  - [Setting up a Windows 10 VM with QEmu on Ubuntu 22.04](https://rtbecard.gitlab.io/2022/07/23/QEmu_win10.html)
  - `apt show qemu-system virt-manager`
- File Systems
  - [Volumes](https://learn.microsoft.com/en-us/windows/win32/vds/volume-object)
- OneDrive
  - ['Duplicate Documents folder is driving me crazy'](https://www.reddit.com/r/onedrive/comments/kxlvxh/duplicate_documents_folder_is_driving_me_crazy/)
- Hyper-V
  - [Windows Server Hyper-V virtualization](https://learn.microsoft.com/en-us/training/paths/windows-server-hyper-v-virtualization/)
- Docker
  - [WSL](https://docs.docker.com/desktop/wsl/)
  - [Get Started](https://docs.docker.com/get-started/)

---

| PWSH              | 7                                 | 5
| ---               | ---                               | ---
|  Executable       | pwsh.exe                          | powershell.exe
| `$PROFILE`        | $HOME\Documents\PowerShell        | $HOME\Documents\WindowsPowerShell
| `$PSModulePath`   | $env:ProgramFiles\PowerShell\7    | $env:WINDIR\System32\WindowsPowerShell\v1.0


<!-- TODO:
- [ansible](https://www.ansible.com/for/windows)

 -->

</details>


### KVM documentation

<details>

- kvm
  - [qemu/kvm 101](https://www.youtube.com/watch?v=BgZHbCDFODk)
  - [GUIDE that froze on ex2511 upon wsl](https://www.youtube.com/watch?v=Zei8i9CpAn0)
  - [install ubuntu](https://www.linuxtechi.com/how-to-install-kvm-on-ubuntu-22-04/)
  - [pop_os-win10-kvm](https://github.com/mr2527/pop_OS-win10-KVM-setup)
  - [qemu win10](https://rtbecard.gitlab.io/2022/07/23/QEmu_win10.html)
  - [another win10](https://raphtlw.medium.com/how-to-set-up-a-kvm-qemu-windows-10-vm-ca1789411760)
  - [kvm nested virt](https://www.howtogeek.com/devops/how-to-enable-nested-kvm-virtualization/)
  - [proper kvm nested virt](https://docs.fedoraproject.org/en-US/quick-docs/using-nested-virtualization-in-kvm/)
  - [official nested guests](https://www.linux-kvm.org/page/Nested_Guests)
  - [some win11](https://getlabsdone.com/how-to-install-windows-11-on-kvm/)
- **gnome boxes**
  - [@System76](https://support.system76.com/articles/virtualization/)
  - [install win11](https://www.geekdashboard.com/install-windows-11-on-gnome-boxes/)
  - [more win11](https://www.ctrl.blog/entry/how-to-win11-in-gnome-boxes.html)
  - [even more win11](https://www.reddit.com/r/gnome/comments/q1wy49/install_windows_11_in_gnome_boxes/)
  - [and more win11](https://www.linuxadictos.com/en/como-instalar-windows-11-en-gnome-boxes-o-virtualbox.html)
  - [yet more](https://www.linuxtoday.com/developer/how-to-run-windows-11-in-gnome-boxes/)
  - [`gnome-boxes --checks`](https://help.gnome.org/users/gnome-boxes/stable/virtualization.html.en)
- misc
  - [kvm, gnome_boxes, else](https://www.youtube.com/watch?v=t-23HOKMer0)
  - [THE QUESTION](https://techcommunity.microsoft.com/t5/windows-11/windows-11-with-wsl2-enabled-nested-virtualization/m-p/3041341)
  - [proxmox freezes](https://forum.proxmox.com/threads/windows-11-vm-with-wsl2-enabled-freezes.101594/)


</details>

---


<!-- ## Labs

> WIP -->

