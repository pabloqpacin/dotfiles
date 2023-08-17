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


 -->


## *NIX environment

- See my [docs](/docs/) for a **multiboot walkthrough** going over dependencies and tweaks

| Component     | Software
| :--           | :--
| **Browser**   | Brave
| **Shell**     |<span style="font-weight: normal; text-decoration: none;">zsh + ohmyzsh</span>
| **Terminal**  | alacritty + tmux
| **Font**      | FiraCode Nerd Font
| **DE/WM**     | Cosmic & Hyprland
| **Editor**    | codium & nvim (LSPs + DAPs)
| **Misc**      | bat btop cheat exa fzf lf ripgrep tldr
| **Hyprland**  | hypr mako rofi swaybg thunar waybar


## Boxes setup

- In addition my Android runs [*Termux*](https://termux.dev/en/) and my Pentium IV dual-boots *Windows XP* and [*Arch_32*](https://archlinux32.org) btw

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

Pop!_OS -.-> Kali{Kali}
NixOS ..- Hyprland
Arch ..- Hyprland

```



<!--

```mermaid

= Win 11 Home = WSL Debian
= Win 11 Pro = WSL Tumbleweed

```
 -->
