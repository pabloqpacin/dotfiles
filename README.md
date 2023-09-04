# dotfiles

## Screenshots 

<details>
<summary>Click to view</summary>

> WIP

<!--
https://github.com/lauroro/hyprland-dotfiles
https://github.com/hyper-dot/Arch-Hyprland
https://github.com/gasech/hyprland-dots
 -->
<!--
### Arch Hyprland
### Arch32 i3
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

- See the [docs](/docs/) for a **multiboot walkthrough** going over dependencies and tweaks

<table>
    <thead>
        <tr>
            <th><b>Component</b></th>
            <th>Linux</th>
            <th>Windows (<a href="https://github.com/microsoft/winget-cli">WinGet</a>)</th>
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
            <td><b>Font</b></td>
            <td colspan="2">FiraCode Nerd Font</td>
        </tr>
        <tr>
        <tr>
            <td><b>DE/WM</b></td>
            <td>Cosmic & Hyprland</td>
            <td></td>
        </tr>
        <tr>
            <td><b>Hyprland</b></td>
            <td>hypr mako rofi swaybg thunar waybar</td>
            <td></td>
        </tr>
        <tr>
            <td><b>Editor</b></td>
            <td colspan="2">vscode | codium & neovim (LSPs + DAPs)</td>
        </tr>
        <tr>
            <td><b>Shell Misc</b></td>
            <td colspan="2">bat bottom cheat exa fzf lf ripgrep tldr zoxide</td>
        </tr>
        <tr>
            <td><b>Other Misc</b></td>
            <td>flameshot nmapsi4</td>
            <td>sysinternals powertoys</td>
        </tr>
        <!-- <tr>
            <td><b>More Misc</b></td>
            <td colspan="2">Wireshark -- KVM Hyper-V</td>
        </tr> -->
    </tbody>
</table>


## Boxes setup


```mermaid
flowchart LR

MACHINES{Machines/OS}
GL76[GL76 Nvidia powerhouse]
EX2511[EX2511 humble laptop]
WSLd[Windows 11: WSL Debian]
WSLt[Windows 11: WSL Tumbleweed]


             GL76 ..- WSLd
MACHINES ..- GL76 --> NixOS
             GL76 --- Pop!_OS
             EX2511 --- Pop!_OS
MACHINES ..- EX2511 --> Arch
             EX2511 ..- WSLt

Pop!_OS -.-> Parrot{Parrot}
NixOS ..- Hyprland
Arch ..- Hyprland


Android[MAR-LX1A smartphone]
Pentium[Pentium IV oldie goldie]
WinXP[Windows XP]


MACHINES..- Pentium --> Arch32[Arch 32] ..- i3
            Pentium ..- WinXP[Windows XP]
            
MACHINES..- Android -.-> Termux
            
click Pentium "https://youtu.be/nyHKHrXjybA" "This is a YouTube link"
click EX2511 "https://icecat.biz/en/p/acer/nx.ef6eb.006/extensa-notebooks-4713392421143-ex2511-55pf-30284410.html" "Specs (mind RAM & SSD upgrades)"

```



<!--

```mermaid

= Win 11 Home = WSL Debian
= Win 11 Pro = WSL Tumbleweed

```
 -->
