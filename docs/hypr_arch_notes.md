# Hyprland Arch notes

> Hyprland on Arch Linux with Nvidia GPU

- [Hyprland Arch notes](#hyprland-arch-notes)
  - [Base install](#base-install)
  - [Hyprland](#hyprland)
  - [More](#more)
  - [Credits](#credits)


## Base install

```bash
# ... Disk ...

pacstrap /mnt linux linux-firmware linux-headers intel-ucode nvidia-open-dpkms sof-firmware alsa-firmware base base-devel networkmanager neovim git wget openssh    # grub os-prober efibootmgr

# ... chroot: locales, timedatectl set-ntp on, enable NetworkManager, (grub), useradd ...

sudo nvim /etc/pacman.conf
    # uncomment Misc options: Color VerbosePkgLists ParallelDownloads=5, add ILoveCandy
    # uncomment the [multilib] and Include... lines (to enable Steam repo)

# sudo nvim /etc/default/grub.grub
    # add 'nvidia_drm.modeset=1' at GRUB_CMDLINE_LINUX_DEFAULTS

sudo pacman -S nvtop nvidia-settings
sudo nvim /etc/mkinitcpio.conf
    # add MODULES=( nvidia nvidia_modeset nvidia_uvm nvidia_drm )
sudo mkinitcpio --config /etc/mkinitcpio.conf --generate /boot/initramfs-custom.img

```

## Hyprland

```bash
# Clone and makepkg YAY
# ...

# Hyprland base
sudo pacman -S hyprland qt5-wayland qt6-wayland xdg-desktop-portal-hyprland qt5ct wev

# Rofi launcher
yay -S rofi-lbonn-wayland-git rofi-power-menu

# Background and bar
sudo pacman -S swaybg swaybar   # || pacman -S hyprpaper && yay -S eww-wayland

# Screenlock...
sudo pacman swayidle
yay -S swaylock-effects
    # ... sudo pacman -S sddm && sudo systemctl enable sddm
    # sudo nvim /usr/lib/sddm/sddm.conf.d/default.conf  >> [Theme] Current=maldives...

# Notifications and auth manager
sudo pacman -S dunst polkit-kde-agent

# Audio
sudo pacman -S alsa-utils pamixer pipewire-alsa pipewire-audio pipewire-pulse
    sudo nvim /usr/share/alsa-card-profile/mixer/profile-sets/multiple.conf
        # https://wiki.archlinux.org/title/PipeWire#Simultaneous_output_to_multiple_sinks_on_the_same_sound_card

# Brightness and bluetooth
sudo pacman -S brightnessctl bluez bluez-utils blueman
    systemctl --user enable bluetooth

# File manager
sudo pacman -S thunar thunar-volman thunar-archive-plugin file-roller gvfs ntfs-3g tumbler

# Fonts and icons...
sudo pacman -S ttf-jetbrains-mono-nerd otf-font-awesome otf-firamono-nerd noto-fonts-emoji
sudo pacman -S gnome-themes-extra lxappearance papirus-icon-theme
yay -S win11-icon-theme-git kripton-theme-git
yay -S ttf-ms-win11-auto

```

## More

```bash
yay -S brave-bin
sudo pacman -S code

sudo pacman -S steam discord    # 2) lib32-nvidia-utils
sudo pacman -S spotify-launcher spotifyd
    # yay -Si librespot mpd

yay -S nmap zenmap
sudo pacman -S wireshark-qt
    sudo usermod -aG wireshark username

sudo pacman -S virtualbox virtualbox-guest-iso  # 2) virtualbox-host-dkms
    # exa /usr/lib/virtualbox/additions/VBoxGuestAdditions.iso
    # sudo nvim /etc/default/grub >> add itb=off ...


```


---


## Credits

- `hypr`: [hypr-dot](https://github.com/hyper-dot/Arch-Hyprland) and [lauroro](https://github.com/lauroro/hyprland-dotfiles)
- `waybar`: [gasech](https://github.com/gasech/hyprland-dots)
-  `rofi`, `dunstrc`: [ericmurphyxyz](https://github.com/ericmurphyxyz/dotfiles)