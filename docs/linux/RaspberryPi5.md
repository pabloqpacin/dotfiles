# Raspberry Pi 5

> CPU: aarch64 (ARM)

- [Raspberry Pi 5](#raspberry-pi-5)
  - [Ubuntu 23.10 aarch64](#ubuntu-2310-aarch64)
  - [Raspberri Pi OS Full (64-bit)](#raspberri-pi-os-full-64-bit)
  - [Raspberri Pi OS Lite (64-bit)](#raspberri-pi-os-lite-64-bit)
    - [Installation - `rpi-imager`](#installation---rpi-imager)
    - [Configuration - `RasPiOS-base.sh`](#configuration---raspios-basesh)
  - [Other OSs](#other-oss)
    - [Proxmox/Pimox](#proxmoxpimox)
    - [OpenWRT](#openwrt)

---

## Ubuntu 23.10 aarch64

```bash
wget https://raw.githubusercontent.com/pabloqpacin/dotfiles/main/scripts/autosetup/FOO.sh
bash FOO.sh

    agi libssl-dev
    cargo install cargo-update

sudo apt-get install raspi-config
```


```bash
sudo apt install \
  flameshot sway xdg-desktop-portal-wlr

# https://github.com/flameshot-org/flameshot/blob/master/docs/Sway%20and%20wlroots%20support.md
```

```bash
# https://github.com/obsproject/obs-studio/wiki/install-instructions#linux
sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt update
sudo apt install obs-studio
# ...
```


```bash
# Provide selection number for alacritty TUI menu -- https://itsfoss.com/change-default-terminal-ubuntu/
sudo update-alternatives --config x-terminal-emulator | grep 'alacritty' | GET THE 1 | \
  sudo update-alternatives --config x-terminal-emulator
```

- screenkey & screenrecording
    - https://github.com/AlynxZhou/showmethekey
    - https://gitlab.com/screenkey/screenkey/-/issues/61
    - https://www.makeuseof.com/tag/ways-can-record-desktop-linux-raspberry-pi/
    - https://linuxhint.com/install-obs-studio-pi-apps-raspberry-pi/
    - https://github.com/obsproject/obs-studio/wiki/install-instructions#linux

- **Hide top bar**

```bash
# brave: extension: gnome-shell-integration
sudo apt-get install gnome-browser-connector

# brave: https://extensions.gnome.org/extension/6454/panel-free/
```


## Raspberri Pi OS Full (64-bit)


```bash
wget https://raw.githubusercontent.com/pabloqpacin/dotfiles/main/scritps/autosetup/RaspPiOS-base.sh
wget https://short.link/RaspPiOS-base.sh
```




---

## Raspberri Pi OS Lite (64-bit)

### Installation - `rpi-imager`

```yaml
# Apply OS customisation settings
hostname: pi5
username: pabloqpacin
password: ...
wireless LAN: no                  # always Ethernet 
locale settings:
  timezone: Europe/Madrid
  keyboard: es
enable ssh: use password authentication
```

### Configuration - `RasPiOS-base.sh`

- Base

```bash
# power on the pi
ssh $USER@pi5
sudo apt update && sudo apt upgrade -y && \
    sudo apt install htop wget && reboot
```

```bash
ssh $USER@pi5
wget https://raw.githubusercontent.com/pabloqpacin/dotfiles/main/scripts/autosetup/RasPiOS-base.sh &&
chmod +x RaspiOS-base.sh && bash $_
```

- More

```bash
sudo raspi-config

bash $HOME/dotfiles/scripts/rpi_sysbench.sh
```

<!-- - Next up

> - https://www.docker.com/blog/getting-started-with-docker-for-arm-on-linux/
> - @RaidOwl: [Raspberry Pi Home Server - Docker, Portainer, Plex, Wordpress, and More](https://www.youtube.com/watch?v=yFuTAKq_j3Q) -->

---

## Other OSs

### Proxmox/Pimox

- https://github.com/jiangcuo/Proxmox-Port
  - https://github.com/jiangcuo/Proxmox-Arm64/wiki
  - https://www.makeuseof.com/raspberry-pi-proxmox-virtualization-how-to-install/
  - https://medium.com/@arsalan.sahab/virtual-machines-on-the-raspberry-pi-3292ce60acdb



### OpenWRT

> - @NetworkChuck: [my SUPER secure Raspberry Pi Router (wifi VPN travel router)](https://www.youtube.com/watch?v=jlHWnKVpygw)
