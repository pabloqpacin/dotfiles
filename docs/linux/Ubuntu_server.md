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

