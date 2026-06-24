# Debian (13.4) en ThinkPad

- [Debian (13.4) en ThinkPad](#debian-134-en-thinkpad)
  - [Graphical Install](#graphical-install)
  - [Install (TUI)](#install-tui)
  - [Install (TUI - no LUKS)](#install-tui---no-luks)
  - [Configuración](#configuración)
    - [sudo user](#sudo-user)
    - [Timeshift](#timeshift)
    - [Implantar dotfiles y scripts](#implantar-dotfiles-y-scripts)
    - [Configuraciones interactivas](#configuraciones-interactivas)
      - [Gnome](#gnome)
      - [Apps](#apps)
    - [SSH Keys GitHub](#ssh-keys-github)
      - [Crear y configurar nuevas llaves](#crear-y-configurar-nuevas-llaves)
      - [Actualizar remote de ~/dotfiles](#actualizar-remote-de-dotfiles)
  - [Remote Access](#remote-access)
    - [Config server/cliente](#config-servercliente)



## Graphical Install

```yaml
Language: English
Location: Spain
Locales: en_IE.UTF-8
Keyboard: Spanish

Missing ath11k/WCN6855/hw2.1/firmware-2.bin network drivers, load from removable media: no
Primary network interface: enp1s0f0  # || wlp2s0

Hostname: tp-debian
Domain name: home.lan
Root password: Susodichojandemore882;;
User fullname: pquevedo
Username: pquevedo
User password: sherosh888

Clock: Madrid

Partitioning: Manual
# /dev/nvme0n1: new partition table removing all current partitions
# Configure encrypted volumes: 

Guided - entire disk and encrypted VLM - separar home y tal - luego si se puede pues montar / entero en 600 GB o así, y dejar los otros 300 y pico LIBRES, sin formato
```


## Install (TUI)

```yaml
Language: English
Location: Spain
Locales: en_IE.UTF-8
Keyboard: Spanish

Firmware missing, load from removable media: no
Interface: enp1s0f0

Hostname: tp-debian
Domain name: home.lan
Root password: susodichojandemore882;;
Username: pquevedo
Password: sherosh888
Clock: Madrid

Disks:
  - Guided - entire disk and set up encrypted LVM
  - /dev/nvme0n1
  # - Separate /home partition
  - All files in one partition
  - Encryption passphrase: sarandonga882
  - Amount of volume group for guided partitioninig: 700 GB

Debian package manager mirror country: Spain
Debian archive mirror: deb.debian.org # || debian.uvigo.es
# Proxy information: -

Popularity-contest: yes

Software to install:
  - GNOME
  - standard system utilities
  - SSH server
```


## Install (TUI - no LUKS)

> Ventoy: debian-13.4.0 > grub2

- [ ] partición Timeshift
  - [ ] standard, no largefile, para los inodos y tal
  - [ ] mejor sin montaje permanente (o poner exclusión en timeshift)

```yaml
Language: English
Location: Spain
Locales: en_IE.UTF-8
Keyboard: Spanish

Missing ath11k/WCN6855/hw2.1/firmware-2.bin network drivers, load from removable media: no
Primary network interface: enp1s0f0  # || wlp2s0

Hostname: tp-debian
Domain name: home.lan
Root password: Susodichojandemore882;;
User fullname: pquevedo
Username: pquevedo
User password: sherosh888

Clock: Madrid

# Manual partitioning (1.0 TB nvme)
Partitioning:
  /dev/nvme0n1: New empty partition table
  1.0 TB free space:
    - Create new partition:
        Size: 1 GB
        Location: Beginning
        Settings:
          Name: Bootloader
          Use as: EFI System Partition
          Bootable flag: on
    - Create new partition:
        Size: 8 GB
        Location: Beginning
        Settings:
          Name: SWAP
          Use as: swap area
    - Create new partition:
        Size: 200 GB
        Location: Beginning
        Settings:
          Name: root
          Use as: Ext4 journaling file
          Mount point: /
          Mount options: noatime
          Label: root
          Reserved blocks: 5%
          Typical usage: standard
    - Create new partition:
        Size: 200 GB
        Location: Beginning
        Settings:
          Name: snapshots
          Use as: Ext4 journaling file
          # Mount point: /mnt/snapshots
          Mount options: noatime
          Label: snapshots
          Reserved blocks: 1%
          # Typical usage: largefile
          Typical usage: standard
    - Create new partition:
        Size: 615.2 GB
        Location: Beginning
        Settings:
          Name: home
          Use as: Ext4 journaling file
          Mount point: /home
          Mount options: noatime
          Label: home
          Reserved blocks: 1%
          Typical usage: standard


Package manager:
  Debian archive mirror country: Spain
  Debian archive mirror: deb.debian.org

Software selection:
  - GNOME
  - SSH server
  - standard system utilities
  # - Debian Blend (https://www.debian.org/blends/)
```

## Configuración


### sudo user

```bash
su -

{
  SUDO_USER=pquevedo
  usermod -aG sudo adm $SUDO_USER
}

reboot
```


### Timeshift

```yaml
# Recommended: do not keep /mnt/snapshots mounted permanently.
# Let Timeshift mount snapshots partition by UUID on demand.
fstab:
  /dev/nvme0n1p4: noauto

timeshift:
  Via dotfiles script:
    - bash ~/dotfiles/scripts/main.sh
  Defaults (setup-timeshift.sh):
    Snapshot Type: RSYNC
    Snapshot Location: label=snapshots (UUID auto-detected)
    Snapshot Levels:
      Boot: off
      Hourly: off
      Daily: 5
      Weekly: 3
      Monthly: 2
    Excludes:
      - /run/timeshift/**
      - /mnt/snapshots/**
      - /home/<sudo_user>/**
      - /root/**
  Initial snapshot:
    - created automatically if repo has no snapshots
```


### Implantar dotfiles y scripts

- Login normal

```bash
sudo apt update && \
sudo apt install -y git
# git-gui gitweb ?

wget -qO- "https://raw.githubusercontent.com/pabloqpacin/dotfiles/refs/heads/feat/refactor-scripts/scripts/bootstrap.sh" | bash
```

- Reiniciar y repetir

```bash
bash dotfiles/scripts/main.sh
```


### Configuraciones interactivas

#### Gnome

```yaml
Extension Manager:
  Hide Top Bar:
    Show panel when mouse approaches edge of screen: true

Settings:
  # Displays:
  #   Scale: 100% # 125% por defecto
  System:
    Remote Desktop:
      Desktop Sharing: <TODO>
      Remote Login: <TODO>
```

#### Apps

- Brave + **Google account**

```yaml
Brave:
  Default browser: true
  Theme: match system setting
  Telemetry: true
  Settings:
    Search engine: Brave
    Appearance:
      Theme: GTK
      Use wide address bar: true
      Always show full URLs: true
```
```yaml
Brave:
  gmail.com:
    - Email: pquevedo267@gmail.com
      Password: <...>
      MFA: true
      # Save password to Password Manager on this device: Never
      Add account:
    - Email: pquevedo@setenova.es
      Password:
      TOTP: true
  github.com:
    Sign in:
      - Continue with Google: pquevedo267@gmail.com
        MFA: true
        Add account:
      - Continue with Google: pquevedo@setenova.es
        TOTP: true
```

- KeePassXC

```yaml
# mkdir ~/.KPXC

Brave:
  drive.google.com: <descargar Passwords.kdbx y guardar en ~/.KPXC>

KeePassXC:
  Open Database: ~/.KPXC/Passwords.kdbx
  Enter Password: <...>
  Database:
    Database Security:
      Change Password: <...>
```

- Cursor

```yaml
Cursor:
  Log in:
    Browser:
      Continue to sign in:
        Continue with Google: pquevedo267@gmail.com
    Plugins: Skip
```

- Spotify

```yaml
Spotify:
  Scan code to log in: true
```

- Steam

```yaml
Steam:
  Scan code to log in: true
```

- Discord

```yaml
Discord:
  Email: <...>@setenova.es
  Password: <...>
```

### SSH Keys GitHub

#### Crear y configurar nuevas llaves

> [!IMPORTANT]
> - Accounts: `pquevedo-stnv`, `pabloqpacin`
> - [WikiJS Setenova: Configuración Git Multicuenta](https://wiki.setenova.es/en/herramientas/Git/git-configuracion)


#### Actualizar remote de ~/dotfiles

```bash
git remote set-url origin git@github-personal:pabloqpacin/dotfiles.git
git remote -v
```


---

## Remote Access

### Config server/cliente

> [!WARNING]
> **Si se inicia Remote Login, siempre hacer el Log Out de la sesión gráfica.**

- Server:

```yaml
Settings:
  System:
    Remote Desktop:
      Desktop Sharing: off  # || on
      Remote Login: on      # || off
```

- Cliente:

```yaml
Remmina:

  # Conexión a sesión gráfica de usuario ya iniciada
  - New connection profile:
    Name: tp-debian--desktop-sharing
    Group: Setenova
    Protocol: RDP - Remote Desktop Protocol
    Basic:
      Server: 192.168.1.46:3389
      Username: pquevedo
      Password: <password-desktop-sharing>

  # Nuevos logins a PC con sesión gráfica
  - New connection profile:
    Name: tp-debian--remote-login
    Group: Setenova
    Protocol: RDP - Remote Desktop Protocol
    Basic:
      Server: 192.168.1.46:3389
      Username: pquevedo
      Password: <password-remote-login>
```
