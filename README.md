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

### Shared

| Component     | Software
| :--           | :--
| **Browser**   | Brave
| **Passmgr**   | [KeePassXC](https://keepassxc.org/)
| **Font**      | FiraCode Nerd Font
| **Editor**    | code\|codium & nvim (LSPs + DAPs)
| **Misc**      | bat bottom cheat exa fzf lf ripgrep tldr zoxide

#### *NIX

| Component     | Software
| :--           | :--
| **Shell**     | zsh + ohmyzsh
| **Terminal**  | alacritty + tmux
| **DE/WM**     | Cosmic & Hyprland
| **Hyprland**  | hypr mako rofi swaybg thunar waybar
<!-- | **Tools**     | KVM -->

#### Windows environment

| Component     | Software
| :--           | :--
| **Pkgmgr**    | winget <!--& choco-->
| **Edition**   | Home \| Pro N <!--something WSL-->
| **Shell**     | pwsh + ohmyposh
| **Terminal**  | Windows Terminal
| **Tools**     | <!--cpu-z hwinfo--> powertoys sysinternals
<!-- | **OS tools**  | ... -->


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
