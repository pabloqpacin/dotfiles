# dotfiles

<!--
    TODO: blend zsh and bash configuration (aliases, variables, functions)
    TODO: scripts/autosetup: keep base, try move else elsewhere
-->

See the [docs](/docs/) for a **multiboot walkthrough** going over dependencies and tweaks.

Also see [scripts](/scripts/) and [windows/scripts](/windows/scripts/) for **automated setups**.

## Screenshots 

<details>
<summary>Click to view</summary>

### Pop!_OS

![pop_vscodium_alacritty](/img/screenshots/pop-vscodium-alacritty.png)
![pop_workspace](/img/screenshots/pop-workspace.png)

### NixOS Hyprland

![nixos-hypr_desktop](/img/screenshots/nixos-hypr_desktop.png)

<!--
### RaspberryPiOS

![pi1](/img/screenshots/Pi/pi-docker_up.png)
![pi2](/img/screenshots/Pi/pi-shell_wp.png)
![pi3](/img/screenshots/Pi/pi-file_explorer.png)
-->

### Arch i3

![nvim_telescope](/img/screenshots/i3-nvim_telescope.png)
![nvim_peek](/img/screenshots/i3-nvim_peek.png)
![i3_pacman](/img/screenshots/i3-pacman.png)

### Arch Hyprland

<!-- ![codium-nvim](/img/screenshots/hypr-vscodium_nvimLSP.png) -->
![hypr-nvim_brave](/img/screenshots/hypr-brave_nvimLSP.png)
![hypr-misc](/img/screenshots/hypr-neofetch_man_btm_eza.png)

### Debian_X95

![Debian_X95](/img/screenshots/debianX95.png)


<!--
https://github.com/lauroro/hyprland-dotfiles
https://github.com/hyper-dot/Arch-Hyprland
https://github.com/gasech/hyprland-dots
 -->
 <!--
### NixOS Hyprland
### Pop!_OS
- devilspie: codium
![a](/img/screenshots/a)

#### alacritty
#### btop
#### bat
#### **neovim**
#### mako
#### man
#### rofi
#### waybar
#### *zsh*

### Windows 11
#### *powershell*
#### windows terminal
#### winget
 -->

</details>


## Shell environment & Desktop utitilies


<table>
    <thead>
        <tr>
            <th>Component</th>
            <th>Linux</th>
            <th>Windows (<a style="font-weight:normal" href="https://github.com/microsoft/winget-cli">WinGet</a>)</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><b>Browser</b></td>
            <td colspan="2">Brave</td>
        </tr>
        <tr>
            <td><b>Passmgr</b></td>
            <td colspan=2><a href="https://keepassxc.org/">KeePassXC</a></td>
        </tr>
        <tr>
            <td><b>Shell</b></td>
            <td>zsh + ohmyzsh</td>
            <td>pwsh + ohmyposh</td>
        </tr>
        <tr>
            <td><b>Terminal</b></td>
            <td>alacritty + tmux</td>
            <td>Windows Terminal</td>
        </tr>
        <tr>
            <td><b>Nerd Fonts</b></td>
            <td colspan="2">FiraCode & CaskaydiaCove</td>
        </tr>
        <tr>
        <tr>
            <td><b>DE/WM</b></td>
            <td>Gnome (Cosmic) & Hyprland</td>
            <td></td>
        </tr>
        <tr>
            <td><b>Hyprland</b></td>
            <td>hypr mako rofi swaybg thunar waybar ...</td>
            <td></td>
        </tr>
        <tr>
            <td><b>Editor</b></td>
            <td colspan="2">vscode/vscodium & neovim (LSPs + DAPs)</td>
        </tr>
        <tr>
            <td><b>Shell Misc</b></td>
            <td colspan="2">bat bottom btop cheat eza fzf lf ripgrep tldr zoxide</td>
        </tr>
        <tr>
            <td><b>Other Misc</b></td>
            <td>flameshot grimshot nmapsi4</td>
            <td>powertoys sysinternals zenmap</td>
        </tr>
        <!-- <tr>
            <td><b>More Misc</b></td>
            <td colspan="2">Wireshark -- KVM Hyper-V</td>
        </tr> -->
    </tbody>
</table>


## Homelab Boxes


```mermaid
flowchart LR

%% ...

MACHINES((Machines/OS))
HOMELAB[(VMs)]

GL76[MSI GL76 Workstation]
EX2511[Acer EX2511 Laptop]
RPi5[Raspberry Pi 5 SBC]
Pentium4[Pentium 4 Relic]
OPPO[Android Smartphone]

Proxmox[/<s>Proxmox VE</s>/]
Pop2204[/Pop!_OS 22.04/]
Pop2404[/Pop!_OS 24.04/]
Arch[/Arch Linux/]
Arch32[/Arch Linux 32/]
Nix2311[/NixOS 23.11/]
UbuntuARM[/Ubuntu 24.04 arm64/]
WinXP[\Windows XP\]
Termux[/Termux/]
Kali[/Kali Linux/]
Parrot[/Parrot/]
WinServer19[\Windows Server 2019\]
Win10[\Windows 10 Home|Pro\]
Win11[\Windows 11 Home|Pro\]
Debian12[/Debian 12/]

%% ...

MACHINES ---- GL76
GL76 -- Hyprland --- Nix2311
GL76             ---> Pop2204 --- HOMELAB

MACHINES ..- OPPO .- Termux

MACHINES ..- EX2511
EX2511 -- Hyprland ---> Arch
EX2511 -- COSMIC --- Pop2404
EX2511          --> Proxmox

MACHINES ..- RPi5 --> UbuntuARM

MACHINES ..- Pentium4
Pentium4 -- i3 --> Arch32
Pentium4 .- WinXP

%% ...

HOMELAB -- vagrant/ansible --- Debian12
HOMELAB --- WinServer19
HOMELAB --- Win10
HOMELAB --- Win11
HOMELAB --- Kali
HOMELAB --- Parrot

%% ...

click Pentium4 "https://youtu.be/nyHKHrXjybA" "This is a YouTube link"
click EX2511 "https://icecat.biz/en/p/acer/nx.ef6eb.006/extensa-notebooks-4713392421143-ex2511-55pf-30284410.html" "Specs (mind RAM & SSD upgrades)"

```

<!-- Microcontrollers>Microcontrollers]
UNO(Arduino UNO)
Pico(Raspberry Pi Pico)

Microcontrollers ..- Pico
Microcontrollers ..- UNO -->


<!-- 
<table style="text-align: center;">
    <thead>
        <tr>
            <th>Machine</th>
            <th>OS</th>
            <th>DE/WM<br>WSL</th>
            <th>HOMELAB</th>
            <th>Guests</th>
            <th>Services</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td rowspan=2>Raspberry Pi 5</td>
            <td colspan=5>...</td>
        </tr>
        <tr>
            <td colspan=5>...</td>
        </tr>
        <tr>
            <td rowspan=6>GL76</td>
            <td>NixOS unstable</td>
            <td>Hyprland</td>
            <td colspan=3></td>
        </tr>
        <tr>
            <td>Windows 11 Pro</td>
            <td>Tumbleweed</td>
            <td>Hyper-V</td>
            <td colspan=2>...</td>
        </tr>
        <tr>
            <td rowspan=4>Pop!_OS</td>
            <td rowspan=4>Cosmic</td>
            <td rowspan=4>VirtualBox<br>+ KVM</td>
            <td>Ubuntu Server</td>
            <td rowspan=3>...</td>
        </tr>
        <tr>
            <td>Windows Server 2022</td>
        </tr>
        <tr>
            <td>Debian_X95</td>
        </tr>
        <tr>
            <td>Windows 11</td>
            <td>mysql</td>
        </tr>
        <tr>
            <td rowspan=4>EX2511</td>
            <td>Arch Linux</td>
            <td>i3</td>
            <td colspan=3></td>
        </tr>
        <tr>
            <td>Windows 11</td>
            <td>Debian</td>
            <td>Hyper-V</td>
            <td colspan=2>...</td>
        </tr>
        <tr>
            <td rowspan=2 colspan=3>Proxmox</td>
            <td>Ubuntu Server</td>
            <td>...</td>
        </tr>
        <tr>
            <td colspan=2>...</td>
        </tr>
        <tr>
            <td rowspan=2>Pentium 4</td>
            <td>Arch 32</td>
            <td>i3</td>
            <td rowspan=2 colspan=3></td>
        </tr>
        <tr>
            <td colspan=2>Windows XP</td>
        </tr>
        <tr>
            <td>Phone</td>
            <td colspan=2>Termux</td>
            <td colspan=2></td>
            <td>mysql</td>
        </tr>
    </tbody>
</table>
 -->



<!-- ## Dev Tools
### R3C0N NM4P
- Arguments
- Screenshot
-->



