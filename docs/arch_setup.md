# Arch setup

- [Arch setup](#arch-setup)
  - [installation](#installation)
  - [configuration](#configuration)
    - [minimal DE / WM](#minimal-de--wm)
  - [credits and documentation](#credits-and-documentation)


## installation

> Consider **bridged network** for vm in order to **ssh**

<!--
<details>

```markdown
> Say I'm starting an arch installation in a vm. I want to connect to it via ssh from my host., whose IP is 192.168.1.47. Now if I do `ip a` in the guest, the IP seems to be 10.0.2.15. That means it can't be found in my network? How can I enable an IP I can ssh into? Anything to do with VirtualBox network configuration?

If you're using VirtualBox to run the Arch Linux VM, the default network configuration for VirtualBox uses NAT (Network Address Translation) mode. In this mode, the VM has its own internal network with IP addresses that are different from your host machine's network.
To enable SSH access to the Arch Linux VM from your host machine, you have a couple of options:

1. Port Forwarding: One way to access the VM is by configuring port forwarding in VirtualBox. You can forward incoming SSH connections from your host's IP address to the IP address of the VM. Here's how you can set it up:
- Shut down the VM if it's running.
- Open the VirtualBox Manager and go to the settings for the Arch Linux VM.
- Navigate to the "Network" section and select the "Adapter 1" tab.
- Click on the "Advanced" button to expand the advanced network settings.
- Under the "Port Forwarding" section, click the "+" icon to add a new rule.
- Specify the following settings for the port forwarding rule:
  - Name: SSH
  - Protocol: TCP
  - Host IP: 192.168.1.47 (your host machine's IP address)
  - Host Port: 2222 (or any other available port on your host)
  - Guest IP: 10.0.2.15 (your VM's IP address)
  - Guest Port: 22 (SSH port on the VM)
- Save the settings and start the VM.
With port forwarding configured, you can now SSH into the VM from your host machine using the following command:
`ssh -p 2222 user@192.168.1.47`
Replace user with your actual username on the Arch Linux VM.

1. Bridged Networking: Another option is to configure VirtualBox to use bridged networking mode. This allows the VM to obtain an IP address from your local network, making it directly accessible from your host machine. Here's how you can set it up:
- Shut down the VM if it's running.
- Open the VirtualBox Manager and go to the settings for the Arch Linux VM.
- Navigate to the "Network" section and select the "Adapter 1" tab.
- Change the "Attached to" setting to "Bridged Adapter".
- Optionally, you can select a specific network interface if you have multiple network adapters on your host.
Save the settings and start the VM.
Once the VM is booted up, it should obtain an IP address from your local network, allowing you to SSH into it directly using its assigned IP address. Use the following command to SSH into the VM:
`ssh user@<VM-IP-Address>`
Replace user with your actual username on the Arch Linux VM, and <VM-IP-Address> with the IP address assigned to the VM by your local network.

Choose the option that suits your needs and network configuration.


> Which one is safer

In terms of security, using bridged networking mode is generally considered safer than port forwarding with NAT.
When using bridged networking, the VM is connected directly to your local network, which means it gets an IP address from your router and behaves as a separate device on the network. This allows you to apply network security measures, such as firewall rules and network segmentation, directly to the VM. It also enables the VM to have its own IP address, making it easier to manage and control access.
On the other hand, when using port forwarding with NAT, the VM is behind a virtual network created by VirtualBox. The host machine acts as a gateway between the VM and the external network. While port forwarding allows you to access services on the VM, it involves opening specific ports on your host machine, which could potentially introduce security risks if not properly configured. Additionally, the VM's IP address is different from your local network, which may complicate network management and security configurations.
In summary, bridged networking provides a more direct and secure connection for the VM, allowing it to function as a separate device on your network. However, it's important to ensure that both your host machine and the VM have appropriate security measures in place, such as up-to-date software, strong passwords, and firewall configurations, to protect against potential threats.
```

</details>
-->

```bash
# loadkeys es
ip link
# SSH: systemctl enable --now sshd && passwd root
```

```bash
# Disks setup: BIOS
cfdisk
# DOS: 512M bootable linux, total-2G linux, rest linux_swap
mkfs.vfat -F 32 /dev/sda1
mkfs.ext4 /dev/sda2
mkswap /dev/sda3 && swapon /dev/sda3

mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
# lsblk -f
```

```bash
# Disks setup: UEFI
cfdisk
# GPT: 600MB efi, total-1GB linux, rest linux_swap
mkfs.vfat /dev/sda1
mkfs.ext4 /dev/sda2
mkswap /dev/sda3 && swapon /dev/sda3

mount /dev/sda2 /mnt
mkdir -p /mnt/boot/efi
mount /dev/sda2 /mnt/boot/efi
```
<!--if errors first install the kernel and then mount the boot/efi partition-->

```bash
# Disks setup: encryption
```

```bash
pacstrap /mnt linux linux-firmware base base-devel grub networkmanager neovim git
    # UEFI: efibootgr
genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt    # pacman -Q | wc -l

# echo "KEYMAP=es" > /etc/vconsole.conf
sed -i '/s/#en_GB.UTF/en_GB.UTF/' /etc/locale.gen || sed -i '/#en_GB.UTF/s/^#//' /etc/locale.gen
echo "LANG=en_GB.UTF-8" > /etc/locale.conf
locale-gen
ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
# timedatectl set-ntp true
# hwclock --systohc

systemctl enable NetworkManager
echo "127.0.0.1         localhost" >> /etc/hosts
echo "archbox" > /etc/hostname

# UEFI: grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
# DOS:
    grub-install /dev/sda
# grub-mkconfig -o /boot/grub/grub.cfg
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

useradd -m -g users -G wheel username
passwd username
passwd root
EDITOR=nvim visudo
# uncomment %wheel ALL=(ALL:ALL) ALL

exit
umount -R /mnt
reboot

eject /dev/sr0 &&
shutdown now    # if baremetal, unplug bootable USB
```

## configuration

```bash
# >> Login as non-root user into TTY (no DE/WM yet) <<

# If virtual-box VM, verify versions compatibility first!
sudo pacman -S virtualbox-guest-utils
sudo systemctl enable vboxservice.service

# localectl list-x11-keymap-layouts
# sudo localectl set-x11-keymap es || echo -e "\nsetxkbmap es" >> $HOME/.bashrc

sudo pacman -S alacritty bat exa fzf htop man man-pages neofetch ripgrep tldr tmux unzip zsh
    # code firefox ttf-fira-mono // glow mdcat mdp // python-pip python-virtualenv 
# >> Config files for alacritty bat and zsh are provided in this dotfiles repo <<

git clone https://aur.archlinux.org/yay.git
cd ~/yay && makepkg -si
cd $HOME && rm -rf ~/yay
yay -S brave-bin cheat-bin cbonsai-git keepassxc --nocleanmenu --nodiffmenu
tldr -u
cheat   # Y && Y

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# cd $HOME && git clone https://github.com/pabloqpacin/dotfiles
# now symlink whatever => ln -s ~/dotfiles/foo ~/foo
# NEOVIM requirements are addressed elsewhere in this repo

# NERD Font setup: Fira Mono Nerd -- check latest version
curl -Lo ~/FiraMonoNerd.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.1/FiraMono.zip
unzip FiraMonoNerd.zip -d FiraMonoNerd
sudo mkdir /usr/share/fonts/NERD
sudo cp ~/FiraMonoNerd/*.otf /usr/share/fonts/NERD/
fc-cache -fv && fc-list | rg Fira
```
```bash
# >> Tweaks for a baremetal minimal i3 BIOS build -- Unimportant for VMs <<

# Setup WiFi connection
sudo nmtui

# Mountpoint for USB connections
# lsblk
sudo mkdir /mnt/usb
sudo mount /dev/sdb /mnt/usb
# ...
sudo umount /mnt/usb
sudo eject /dev/sdb

# NTFS drives
sudo pacman -S ntfs-3g
pacman -Si udisks2 progress
sudo mkdir /mnt/ntfs
sudo mount -t ntfs-3g /dev/sdb1 /mnt/ntfs
# {{command}} & progress --monitor --pid $!
# https://wiki.archlinux.org/title/udisks -- udisksctl unmount -b /dev/sdb1 && udisksctl power-off -b /dev/sdb ?
sudo umount /mnt/ntfs
sudo eject /dev/sdb
```
### minimal DE / WM

> If stuck in DE with no terminal press `Ctrl+Alt+F2` to open a new TTY instance

```bash
# Xfce
sudo pacman -S xfce4 lightdm lightdm-gtk-greeter
sudo systemctl enable lightdm
```

```bash
# Gnome
sudo pacman -S gdm
sudo systemctl enable gdm
```

```bash
# KDE
sudo pacman -S plasma-desktop sddm
sudo systemctl enable sddm
```

```bash
# LXQt
sudo pacman -S lxqt breeze-icons sddm
sudo systemctl enable sddm
```

```bash
# i3
sudo pacman -S dmenu feh i3-gaps i3status lightdm lightdm-gtk-greeter light-locker picom xdg-utils   # noto-fonts-emoji ... nitrogen? wofi? polybar? ... file-managers?
sudo systemctl enable lightdm
sudo sed -i 's/#greeter-session=example-gtk-gnome/greeter-session=lightdm-gtk-greeter/' /etc/lightdm/lightdm.conf

sudo mkdir /usr/share/wallpapers
sudo cp /home/pabloqpacin/dotfiles/img/* /usr/share/wallpapers
sudo sed -i 's/#background=/background=\/usr\/share\/wallpapers\/er_nokstella.jpg/' /etc/lightdm/lightdm-gtk-greeter.conf

# ln -s ~/dotfiles/.config/i3 ~/.config/i3 << feh picom light-locker
```

```bash
# LXDE
```

```bash
# dwm
``` 

```bash
# hyprland
```


## credits and documentation

- @MentalOutlaw: [Arch Linux Installation Guide](https://www.youtube.com/watch?v=rUEnS1zj1DM) -- YouTube
- [Install Arch Linux in VirtualBox](https://gist.github.com/thomasheller/5b9b18917bbaabceb4f629b793428ee2) gist
- @ArchWiki: [Arch Installation Guide](https://wiki.archlinux.org/title/Installation_guide)
  - [VirtualBox Guest Additions for Arch Linux](https://wiki.archlinux.org/title/VirtualBox/Install_Arch_Linux_as_a_guest)
  - [General recommendations: config after install](https://wiki.archlinux.org/title/General_recommendations)
    - [Users and groups](https://wiki.archlinux.org/title/Users_and_groups#User_management)
    - [Sudo](https://wiki.archlinux.org/title/Sudo)
  - [Xfce...](https://wiki.archlinux.org/title/xfce) <!--[WAYLAND THO?](https://wiki.xfce.org/releng/wayland_roadmap)-->
- @DistroTube: [Arch Linux Installation Guide](https://www.youtube.com/watch?v=PQgyW10xD8s)
- @ILHAM -- YouTube
  - [Arch Linux EFI Installation Guide](https://www.youtube.com/watch?v=C1KqdAsgVAo)
  - [Installation and Getting Started With SWAY](https://www.youtube.com/watch?v=2t_v-zBbwbo) <!-- SWAY // [r/unixporn](https://www.reddit.com/r/unixporn/comments/128eco5/sway_i_love_wayland/), [dotfiles](https://github.com/aspectsides/dotfiles)-->
- KDE -- [@tuxinit: minimal install](https://tuxinit.com/minimal-kde-plasma-install-arch-linux/) article, [minimal install (UEFI & MBR)](https://github.com/XxAcielxX/arch-plasma-install#xorg--gpu-drivers) gist



<!--
    RESEARCH & TODO
    - curses-based interfaces
    - RAID setup
    - hwinfo 
    - Midnight Commander (CLI file manager)
-->
