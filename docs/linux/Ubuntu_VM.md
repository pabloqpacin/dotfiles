# Ubuntu

> - **NOTE 1**: following PopOS setup via 'DebUbu-base'
<!-- > - **NOTE X**: -->

- [Ubuntu](#ubuntu)
  - [live installation](#live-installation)
  - [post-install config](#post-install-config)
- [DebUbu-services ((WordPress))](#debubu-services-wordpress)


## live installation

<details>

- VM config

```yaml
# VirtualBox
VM:
    Memory: 8192
    Processors: 4
    Enable EFI: yes
    Hard Disk: 60
    Network: Bridged
    Display: 64
```

- Installer

```yaml
Keyboard: Spanish

Apps: normal                # minimal == https://ubuntu-archive-team.ubuntu.com/seeds/ubuntu.bionic/desktop.minimal-remove
Download updates while installing: yes
Install third-party software: yes

Disk: Erase                 # because VM
Advanced features: LVM      # || ZFS
Location: Madrid

Username: pabloqpacin
Hostname: UbuntuBox
Passwd: ...
Use Active Directory: no
```

</details>

## post-install config

- Settings

```yaml
Online Accounts: no
Ubuntu Pro: no
Send info to Canonical: no
Location Services: no
```

```yaml
# System Settings
Background: ~/dotfiles/img/wallpapers/foo
Appearance:
    Style: Dark
    Color: Red
    Desktop Icons:
        - Size: Small
        # - Position of New Icons: ...
        # - Show Personal folder: ...
    Dock:
        - Auto-hide: yes
        - Icon size: 30
        # - Position: Left
# Applications: ...
Privacy:
    Connectivity Checking: no
    Location Services: no
    File History & Trash:
        - File History Duration: 30
        - Automatically Delete Trash Content: yes
        - Automatically Delete Temporary Files: yes
    Diagnostics: Manual
Power:
    Power Mode: Power Saver
Keyboard:
    View and customize shortcuts:
        Launchers:
            - Launch web browser: Super+B       # Brave default
        Navigation:
            # - Move to left ws: Super+Page Up
            # - Move to right ws: Super+Page Down
        Custom:
            - Codium: Super+C
```

- Update

```bash
# echo 'APT::Get::Show-Versions "true";' | sudo tee /etc/apt/apt.conf.d/99show-versions

sudo apt update
sudo apt upgrade -y
sudo apt install neofetch --no-install-recommends
```

> **VM snapshot**: 'Fresh Install'

- [DebUbu-base.sh](/scripts/autosetup/DebUbu-base.sh)

```bash
sudo apt install curl
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


```bash
# # Alacritty --  https://linux.how2shout.com/how-to-install-alacritty-terminal-on-ubuntu-22-04-lts/#2_Add_Alacritty_PPA_repository
# sudo add-apt-repository ppa:aslatter/ppa -y
# sudo apt update && sudo apt install alacritty


# # Install npm
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
# nvm install node
# # $ npm install --global live-server
```

---

> **WIP**!!!


# DebUbu-services ((WordPress))

- `ufw`

```bash
sudo ip addr add 192.168.1.48/24 dev enp0s3

cd /srv/www/wordpress
wp option get siteurl       # http://192.168.1.48

# ...

sudo ufw enable
sudo ufw allow OpenSSH
sudo ufw allow 80/tcp  # HTTP

# HOST
xdg-open http://192.168.1.49/course

```