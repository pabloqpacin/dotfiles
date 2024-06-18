# Raspberry Pi 5

> CPU: aarch64 (ARM)

- [Raspberry Pi 5](#raspberry-pi-5)
  - [Ubuntu 23.10 aarch64](#ubuntu-2310-aarch64)
    - [500GB NVMe](#500gb-nvme)
    - [**HOMESERVER**](#homeserver)
      - [IP ESTÁTICA 192.168.1.5](#ip-estática-19216815)
      - [NFS `/**/pi-nfs`](#nfs-pi-nfs)
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
bash -c "$(curl -fsSL https://raw.githubusercontent.com/pabloqpacin/dotfiles/main/scripts/autosetup/FOO.sh)"

    agi libssl-dev
    cargo install cargo-update

sudo apt-get install raspi-config
```

```bash
# https://github.com/flameshot-org/flameshot/blob/master/docs/Sway%20and%20wlroots%20support.md
sudo apt install \
  flameshot sway xdg-desktop-portal-wlr \
  kazam

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


**Hide top bar**

```bash
# brave: extension: gnome-shell-integration
sudo apt-get install gnome-browser-connector
  # brave: https://extensions.gnome.org/extension/6454/panel-free/
```

### 500GB NVMe

- Install the HAT...
- Disks:
    - Benchmark: (avg read 442MB/s, avg write 305 MB/s)
    - Format Partition > VolumeName=Pi-NFS, Type=Ext4
- cfdisk > gpt partition table > 20G (nvme0n1p1)
- PARTITION AND MOUNT with persistency:

```bash
sudo cfdisk /dev/nvme0n1
# - gpt
# - 20G
# - label?

sudo mkfs.ext4 /dev/nvme0n1p1
  # mke2fs 1.47.0 (5-Feb-2023)
  # Discarding device blocks: done
  # Creating filesystem with 5242880 4k blocks and 1310720 inodes
  # Filesystem UUID: 5e61c244-4bd8-42af-95dc-548699888e18
  # Superblock backups stored on blocks:
  #         32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
  #         4096000

  # Allocating group tables: done
  # Writing inode tables: done
  # Creating journal (32768 blocks): done
  # Writing superblocks and filesystem accounting information: done


echo -e "UUID=5e61c244-4bd8-42af-95dc-548699888e18\t /var/pi-nfs\t ext4\t defaults\t 0\t 2" | \
  sudo tee -a /etc/fstab

sudo systemctl daemon-reload
sudo mkdir /var/pi-nfs
sudo mount

sudo blkid
# ...
```

### **HOMESERVER**


#### IP ESTÁTICA 192.168.1.5

<details>
<summary>pre-checks</summary>

```bash
cat /etc/dhcpcd.conf
hostname -I
ip r

# https://pimylifeup.com/ubuntu-20-04-static-ip-address/
ip link
```
```yaml
# $ ls -la /etc/netplan
Permissions Size User Date Modified Name
.rw-r--r--   104 root 22 Sep  2023   01-use-network-manager.yaml
.rw----r--   703 root  5 Feb 15:37   90-NM-dbbf914e-7c18-440a-9f65-7ab100fa3b97.yaml

# $ for file in /etc/netplan/*; do bat $file; done
───────┬────────────────────────────────────────────────────────────────────────────
       │ File: /etc/netplan/01-use-network-manager.yaml
───────┼────────────────────────────────────────────────────────────────────────────
   1   │ # Let NetworkManager manage all devices on this system
   2   │ network:
   3   │   version: 2
   4   │   renderer: NetworkManager
───────┴────────────────────────────────────────────────────────────────────────────
───────┬────────────────────────────────────────────────────────────────────────────
       │ File: /etc/netplan/90-NM-dbbf914e-7c18-440a-9f65-7ab100fa3b97.yaml
───────┼────────────────────────────────────────────────────────────────────────────
   1   │ network:
   2   │   version: 2
   3   │   wifis:
   4   │     NM-dbbf914e-7c18-440a-9f65-7ab100fa3b97:
   5   │       renderer: NetworkManager
   6   │       match:
   7   │         name: "wlan0"
   8   │       dhcp4: true
   9   │       dhcp6: true
  10   │       access-points:
  11   │         "TP-Link_0DF6":
  12   │           auth:
  13   │             key-management: "psk"
  14   │             password: "66096160"
  15   │           networkmanager:
  16   │             uuid: "dbbf914e-7c18-440a-9f65-7ab100fa3b97"
  17   │             name: "TP-Link_0DF6"
  18   │             passthrough:
  19   │               wifi-security.auth-alg: "open"
  20   │               ipv6.addr-gen-mode: "default"
  21   │               ipv6.ip6-privacy: "-1"
  22   │               proxy._: ""
  23   │       networkmanager:
  24   │         uuid: "dbbf914e-7c18-440a-9f65-7ab100fa3b97"
  25   │         name: "TP-Link_0DF6"
───────┴────────────────────────────────────────────────────────────────────────────
```

</details>

```bash
{
  echo 'network:'
  echo '  version: 2'
  echo '  ethernets:'
  echo '    eth0:'
  echo '      dhcp4: no'
  echo '      addresses: [192.168.1.5/24]'
  echo '      gateway4: 192.168.1.1'
  echo '      nameservers:'
  echo '        addresses: [8.8.8.8, 8.8.4.4]'
} | sudo tee -a /etc/netplan/50-static-ip.yaml

sudo netplan apply

# SUCCESS!
```

#### NFS `/**/pi-nfs`

- En Pi5

```bash
sudo apt-get update && sudo apt-get install \
  nfs-kernel-server

echo '/var/pi-nfs 192.168.1.0/24(rw,sync,no_root_squash,no_all_squash)' | \
  sudo tee -a /etc/exports

sudo systemctl restart nfs-kernel-server || echo "Failed to restart NFS server"

# sudo showmount -e localhost

sudo chmod o+w /var/pi-nfs
```

- En otro disposivo en LAN

```bash
sudo apt-get update && sudo apt-get install \
  nfs-common

sudo mkdir /mnt/pi-nfs
sudo mount -t nfs 192.168.1.5:/var/pi-nfs /mnt/pi-nfs || echo "Failed to mount NFS share"

# sudo umount /mnt/pi-nfs
```



---

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


---

<!--

- [ ] cyberdeck:
    - https://www.doscher.com/
