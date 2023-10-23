# Debian_X95

> **NOTE 1**: choose *XFCE* as Desktop Environment for [DebUbu-base.sh](/scripts/autosetup/DebUbu-base.sh) to help automate '[Chicago95](https://github.com/grassmunk/Chicago95)' setup

![Debian_X95](/img/screenshots/debianX95.png)

- [Debian\_X95](#debian_x95)
  - [live installation](#live-installation)
  - [post-install config](#post-install-config)


<!-- ## documentation

- **Debian**
  - https://wiki.debian.org/DebianUnstable#Does_Sid_have_package_.22X.22.3F
      - Use `apt upgrade` instead of `apt full-upgrade` to avoid unwanted removal of any packages that you depend on.
      - If a package cannot be upgraded safely put it on hold using `apt-mark`.
  - https://wiki.debian.org/DebianTesting
    - Please always upgrade to Debian Testing from current stable.
  - https://wiki.debian.org/DontBreakDebian
  - https://www.debian.org/releases/bookworm/installmanual
- Chicago95
  - https://github.com/grassmunk/Chicago95/blob/master/INSTALL.md -->


## live installation

<details>

- VM settings

```yaml
# VirtualBox
Memory: 4096
Processors: 4
Enable EFI: no
Disk: 40
Network: Bridged
Display: 64
```
```yaml
# KVM/qemu/virt-manager
Create a new VM:
    Local install: debian-12.2.0-amd64-netinst.iso
    Memory: 4096
    CPUs: 4
    # Storage: 30
    Select or create custom storage:
        Add pool:
            - Name: asir_vms
            - Type: dir:Filesystem Directory
            # - Target Path: /var/lib/libvirt/images/pool
            - Target Path: /media/pabloqpacin/ASIR/KVM_VMs
        asir_vms:
            Create new volume:
                - Name: debian12
                - Format: qcow2
                - Capacity: 60
            Choose Volume: debian21.qcow2
    # The emulator may not have search pemissions for the path '/media/.../debian12.qcow2'.
        #### grep libvirt /etc/passwd
    Do you want to correct this now?: Yes
      # ...
```

- Installer

```yaml
# Graphical install
Language: English
Location: Other:Europe:Spain
Locales: en_US.UTF-8
Keyboard: Spanish

Hostname: DebianX95
Domain: -

Root passwd: ...
New user: pabloqpacin
Passwd: ...

Clock: Madrid

Partition disks: Guided - use entire disk # and set up *encrypted* LVM

Scan more media: no
Mirror: Spain - deb.debian.org
HTTP proxy: no

Popularity contest: no
```
```yaml
Software:
  - Debian desktop environment: yes
  - Gnome: no
  - XFCE: yes
  - SSH server: yes
  - Web server: yes

Install GRUB: yes   # /dev/sda
```

</details>

## post-install config

- Debian sudo

```bash
su -   # login as root
usermod -aG sudo $USER
exit
# sudo reboot
```

- Update

```bash
# echo 'APT::Get::Show-Versions "true";' | sudo tee /etc/apt/apt.conf.d/99show-versions

sudo apt update
sudo apt upgrade -y
sudo apt install neofetch --no-install-recommends
# sudo apt install software-properties-common   # add-apt-repository
```

> **VM snapshot**: 'Fresh Install'

- [DebUbu-base.sh](/scripts/autosetup/DebUbu-base.sh)

```bash
curl https://raw.githubusercontent.com/pabloqpacin/dotfiles/main/scripts/autosetup/DebUbu-base.sh \
-o setup.sh && chmod +x setup.sh && ./setup.sh
```

```yaml
# VirtualBox Guest Additions        # NOTE: VBox v7.0.10_Ubuntu on host
Devices: Insert Guest Additions CD
Terminal:
    # - apt search virtualbox
    - cd /media/$USER/VBox_GAs
    - ./autorun.sh
    - sudo eject /dev/sr0
    - reboot
```


<details>
<summary>Chicago95</summary>

```bash
sudo apt install git
sudo apt install xfce4-panel-profiles
git clone https://github.com/grassmunk/Chicago95

cd Chicago95
./installer.py
  # Components: all (GTK Theme, Icons, Cursors, Background, Sound theme, Fonts)
  # Customizations: all but zsh (Thunar spinner, terminal theme, bash prompt, XFCE panel)

# Tweaks
sudo mv /etc/fonts/conf.d/70-no-bitmaps.conf /etc/fonts/conf.d/70-no-bitmaps.conf.bak
# Settings manager: Appearance: Fonts: Helvetica Regular 8px; enable anti-aliasing, hinting full
```

</details>

