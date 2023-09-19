# NixOS 23.11

> minimal ISO: Ventoy

## documentation

<details>

- Hyprland
  - https://wiki.hyprland.org/Nix/Options-Overrides/
- stable
  - https://www.joseferben.com/posts/installing_only_certain_packages_from_an_unstable_nixos_channel
- unstable
  - https://nixos.org/manual/nixos/unstable
  - https://nixos.wiki/wiki/Using_X_without_a_Display_Manager
  - https://konfou.xyz/posts/nixos-without-display-manager
- packages
  - https://nixos.wiki/wiki/PipeWire
  - https://nixos.wiki/wiki/Nvidia
  - https://nixos.wiki/wiki/Sway
  - https://nixos.wiki/wiki/Zsh
- flakes
  - https://github.com/Ruixi-rebirth/flakes/tree/main
- HOME-MANAGER
  - https://github.com/iknacx/dotfiles
  - https://discourse.nixos.org/t/opening-i3-from-home-manager-automatically/4849/3
- memo
  - more than 3 password attempts >> `security.sudo.configFile || security.sudo.extraRules` 
  - memo: `boot.initrd.kernelModules`

</details>

## live install


<!-- 2023-08-01 -->

> 1. https://nixos.wiki/wiki/NixOS_Installation_Guide
> 2. https://nixos.org/manual/nixos/unstable/index.html#ch-installation


- Break the ice

```bash
# nixos-help

sudo -i
loadkeys es
# setfont ter-v32n
```

- Config Wifi [SKIPPED]

```bash
# ip a
# # ifconfig
# # nmtui
# # systemctl stop NetworkManager
# 
# sudo systemctl start wpa_supplicant
# wpa_cli
# # tldr wpa_cli
# 
# # scan  || scan_results
# add_network
# set_network 0 ssid "myhomenetwork"
# set_network 0 psk "mypassword"
# set_network 0 key_mgmt WPA-PSK
# enable_network 0
# # see: <3>CTRL-EVENT-CONNECTED - Connection to 32:85:ab:ef:24:5c completed [id=0 id_str=]
# quit
```

- Define partitions & file system

```bash
lsblk
# du && df
# parted || fdisk || gdisk || cfdisk || cgdisk
parted -l

# efibootmgr
parted /dev/nvmeXnY -- rm 1     # ... ??
parted /dev/nvmeXnY -- rm 2
parted /dev/nvmeXnY -- rm 3

# cfdisk
    # GPT: 1024MB EFI, 4GB Swap, 100GB Linux

# parted /dev/sda -- mklabel gpt
# parted foo -- mkpart root ext4 5120MB 414720MB      # Root part: 409600MB from 5th GB
# parted foo -- mkpart swap linux-swap 1024MB 5120MB  # Swap part: 4096MB from 1st GB
# parted foo -- mkpart ESP fat32 1MB 1024MB           # Boot part: first 1GB
# parted foo -- set 3 esp on

parted /dev/nvme0n1 -- mklabel gpt
parted foo -- mkpart ESP fat32 1MB 1024MB           # Boot part: first 1GB
parted foo -- set 1 esp on
parted foo -- mkpart swap linux-swap 1024MB 5120MB  # Swap part: next 4GB
    # ENSURE SWAP is OK for MULTIBOOT
parted foo -- mkpart root ext4 5120MB 404720MB      # Root part: next 400GB

mkswap -L swap /dev/nvme0n1p2
mkfs.fat -F 32 -n boot /dev/nvme0n1p1
mkfs.ext4 -L nixos /dev/nvme0n1p3

mount /dev/nvme0n1p3 /mnt
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
swapon /dev/nvme0n1p2
```

- 'Write' and build the [configuration.nix](/nix/configuration.nix) file

```bash
# TODO: wget https://github.com/pabloqpacin/dotfiles/nix/configuration.nix
nixos-generate-config --root /mnt
vim /mnt/etc/nixos/configuration.nix
    # ...

nixos-install

# New password: ...

shutdown now
```

---


## first boot

- Ensure BIOS/UEFI settings are right for NixOS, especially if *multibooting*

```yaml
# Boot priorities
1: UEFI OS (Disk)
2: Linux Boot Manager
3: Windows Boot Manager
```

- Configure the environment

```bash
tldr --update

# ssh...

git clone https://github.com/pabloqpacin/dotfiles

ln -s ~/dotfiles/.zshrc ~/
ln -s ~/dotfiles/.gitconfig ~/

ln -s ~/dotfiles/.config/bat ~/.config
ln -s ~/dotfiles/.config/btop ~/.config
ln -s ~/dotfiles/.config/tmux ~/.config
ln -s ~/dotfiles/.config/alacritty ~/.config

ln -s ~/dotfiles/.config/hypr ~/.config
ln -s ~/dotfiles/.config/mako ~/.config
ln -s ~/dotfiles/.config/rofi ~/.config
ln -s ~/dotfiles/.config/waybar ~/.config
ln -s ~/dotfiles/.config/swaylock ~/.config

# mkdir -p ~/.config/nvim/lua/pabloqpacin
# cd ~/dotfiles/.config/nvim/lua/pabloqpacin
# cp remap.lua set.lua ~/.config/nvim/lua/pabloqpacin
# echo -e "require('pabloqpacin.remap') \n
# require('pabloqpacin.set')" > ~/.config/nvim/init.lua
sudo cp ~/.config/nvim /root    # ... -- cp --parents

reboot
```


## TO-DO

```yaml
SUS:
  - swayidle/swaylock
  - btop desktop access
  - rebuild end (struggles with Swap)
```

```bash
# Update the system
sudo nixos-rebuild switch

# # Rust stuff
# rustup default stable

```
