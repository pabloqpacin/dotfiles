# Raspberry Pi 5

> CPU: aarch64 (ARM)

- [Raspberry Pi 5](#raspberry-pi-5)
  - [Raspberri Pi OS Lite (64-bit)](#raspberri-pi-os-lite-64-bit)
    - [Installation - `rpi-imager`](#installation---rpi-imager)
    - [Configuration - `RasPiOS-base.sh`](#configuration---raspios-basesh)
  - [Other OSs](#other-oss)
    - [Proxmox/Pimox](#proxmoxpimox)
    - [OpenWRT](#openwrt)

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