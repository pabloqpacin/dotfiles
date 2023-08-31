# dotfiles

<!-- TODO

- Tweak waybar >> https://github.com/hyper-dot/Arch-Hyprland
  - Add screenshots
- Dependencies
  - ok as is?
 -->


## Screenshots 

> WIP

<!--

https://github.com/lauroro/hyprland-dotfiles
https://github.com/gasech/hyprland-dots

1. NixOS desktop: tiling & floating
   1. neofetch
   2. steam
   3. codium

2. PopOS
   1. Neofetch
   2. Codium

x. Arch 32

 -->


## *NIX environment

- See the [docs](/docs/) for a **multiboot walkthrough** going over dependencies and tweaks

| Component     | Software
| :--           | :--
| **Browser**   | Brave
| **Passmgr**   | [KeePassXC](https://keepassxc.org/)
| **Shell**     | zsh + ohmyzsh
| **Terminal**  | alacritty + tmux
| **Font**      | FiraCode Nerd Font
| **DE/WM**     | Cosmic & Hyprland
| **Editor**    | codium & nvim (LSPs + DAPs)
| **Misc**      | bat btop cheat exa fzf lf ripgrep tldr
| **Hyprland**  | hypr mako rofi swaybg thunar waybar


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
