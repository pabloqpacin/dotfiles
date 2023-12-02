# Ubuntu Server

- [Ubuntu Server](#ubuntu-server)
  - [documentation](#documentation)
  - [live installation](#live-installation)
  - [post-install config](#post-install-config)


> - **NOTE 1**: VMs only atm
> - **NOTE 2**: linode.com/craftcomputing == 100$ FREE

## documentation
- [@Ubuntu: installation overview](https://ubuntu.com/tutorials/install-ubuntu-server#1-overview)
- [@SavvyNik: Ubuntu Server 22.04 LTS Install and Bonus! Web Server](https://www.youtube.com/watch?v=zs2zdVPwZ7E)


## live installation

- VM settings

```yaml
# VirtualBox
VM:
  Memory: 8
  Processors: 4
  Enable EFI: yes
  Hard Disk: 60
  # Enable PAE/NX: ...
  Network: Bridged
```
> See [Proxmox setup](/docs/Proxmox_VE.md)


- Installation Wizard

```yaml
Language: English
# Installer Update: Continue without updating     # 23.09.1 while 23.08.1
Keyboard: Spanish

Base: Ubuntu Server
Search for third-party drivers: yes

Network: enp0s3; DHCPv4 192.168.1.41/24       # Info; Edit IPv4, IPv6; Add a VLAN tag -- Manual: Subnet, Address, Gateway, Name servers (IPs), Search domains (Domains)
Proxy: no

Mirror: https://es.archive.ubuntu.com/ubuntu

Use an entire disk: yes
Set up this dis as an LVM group: yes
Encrypt the LVM group with LUKS: no     # ...

Device:
    ubuntu-lv: size == max  # ext4

Hostname: ubuntu-server
Username: pabloqpacin
Passwd: ...

Ubuntu Pro: no

OpenSSH: yes
Import SSH identity: no             # GitHub

Snaps: no
```

## post-install config

- System Update

```bash
sudo apt update \
 && sudo apt upgrade -y

echo 'APT::Get::Show-Versions "true";' | sudo tee /etc/apt/apt.conf.d/99show-versions
sudo apt install neofetch nmap tree 
```

> **WIP**!!!

- Web Server

```bash
sudo apt install apache2
tree /var/www
ip a

# Visitt <IP>:80 from another computer on the network

less /usr/share/doc/apache2/README.Debian.gz
# vim /var/www/html/index.html
tree /etc/apache2
```

- BASE

<!-- > **LEFT-OUT**: ipcalc nvim

```bash
sudo apt install bat grc nmap tasksel

```

- LAMP (https://www.youtube.com/watch?v=1JBCKNIT2Ys)
    - apache
    - wordpress + mysql

---
### i3

# Redes

## DHCP
 -->


```bash
passwd $USER    # changeme

git clone https://github.com/pabloqpacin

sudo apt install exa zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


rm ~/.zshrc && ln -s ~/dotfiles/.zshrc ~/
  # nvim ~/dotfiles/zsh/aliases.zsh   # eza -- exa
ln -s ~/dotfiles/.gitconfig ~
ln -s ~/dotfiles/.config/tmux ~/.config

mkdir $HOME/dotfiles/zsh/plugins && \
  git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions $HOME/dotfiles/zsh/plugins/zsh-autosuggestions && \
  git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting $HOME/dotfiles/zsh/plugins/zsh-syntax-highlighting && \
  bash $HOME/dotfiles/scripts/setup/omz-msg_random_theme.sh
```

```bash
sudo apt install bat ripgrep
sudo mv /usr/bin/batcat /usr/bin/bat
ln -s ~/dotfiles/.config/bat ~/.config

sudo apt install golang --no-install-recommends
go install github.com/gokcehan/lf@latest
ln -s ~/dotfiles/.config/lf ~/.config
# vim .zshrc ... change nvim for vim...
```

> TEMP snapshot

```bash
sudo apt install build-essential fzf golang nmap ripgrep tldr unzip

sudo systemctl disable ssh

# Insert VBox Guest Additions
sudo mkdir -p /media/pabloqpacin/VBoxGA
sudo mount /dev/sr0 /media/pabloqpacin/VBoxGA
bash /media/pabloqpacin/VBoxGA/VBoxLinuxAdditions.run

sudo apt install xorg xdg-utils --no-install-recommends

### i3 -- https://i3wm.org/docs/repositories.html
/usr/lib/apt/apt-helper download-file https://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2023.02.18_all.deb keyring.deb SHA256:a511ac5f10cd811f8a4ca44d665f2fa1add7a9f09bef238cdfad8461f5239cc4
sudo apt install ./keyring.deb
echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe" | sudo tee /etc/apt/sources.list.d/sur5r-i3.list
sudo apt update
sudo apt install i3
# ln -s ~/dotfiles/.config/i3 ~/.config

echo "exec i3" > ~/.xinitrc
startx

sudo add-apt-repository ppa:aslatter/ppa -y && \
  sudo apt update && sudo apt install alacritty && \
  ln -s ~/dotfiles/.config/alacritty ~/.config


wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/CascadiaCode.zip
sudo unzip CascadiaCode.zip -d /usr/share/fonts/CascadiaCodeNerd && fc-cache -f rm CascadiaCode.zip

sudo apt install feh picom dkms


env CGO_ENABLED=0 /usr/local/go/bin/go install -ldflags="-s -w" github.com/gokcehan/lf@latest

agi lightdm -y

vim



# sudo apt install cargo
```

- no need to do the following because TMUX saves the day

```bash
# i3-gaps
# lightdm
#

```


---
---
---

- 101

```bash
sudo ln -s ~/dotfiles/.vimrc /root
```
