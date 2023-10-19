# Proxmox VE

<!--
---
---

# Multiboot 2.0

- Key points:
  - First drive (240GB): Windows 11 (100GB)  + Arch Linux (40G) + empty (100GB)
  - Second drive (500GB): Proxmox VE (all)
  - [Avoid unified multiboot menu across disks with Proxmox](https://forum.proxmox.com/threads/warning-os-prober.115087/)

---

## 0. Preps

- Existing: one drive Win, another Lin
- Clear UEFI
  - **BIOS**
    - Secure boot: enable
    - Erase all Secure Boot Settings: yes
    - Restore Secure Boot to Factory Default: yes
    - # Select an UEFI file as trusted for executing: foo
    - Secure boot: disable
    - INSERT VENTOY
    - Save and Exit
  - **Ventoy**
    - Archlinux
      - `cfdisk /dev/sda`: delete everything
      - `efibootmgr -b XXX -B`: delete as needed
      - `reboot`: verify


## 1. Drive A - Bootloader


## 1.1 Windows

- Ventoy
  - Windows 11
    - Drive 0 (224GB):
      - New: 102500MB --  C:\ == 99.32GB ...
      - [setup (base update only)](/docs/windows/Win11_Pro.md)

## 1.2 Linux

- BIOS
  - Boot Order: lower WindowsBootManager just above NetworkBoot
---
- Ventoy
  - Archlinux
    - [installation guide](/docs/linux/Arch_Hypr.md)
    - `cfdisk /dev/sda`
      - sda5: 1G EFI
      - sda6: 6GB swap
      - sda7: else Linux (116GB)
    - `mkfs` ...
    - `mount`
---
  - **BIOS**
    - Secure boot: enable
    - Select an UEFI file as trusted for executing: yes
      - HDD0: EFI: GRUB: grubx64.efi == ArchBox
    - Save and quit; come back
    - Secure Boot: disable
    - Boot order: EFI up only after USB
---
- **Arch**
  - add Win to GRUB
    - `mkdir /mnt/win`
    - `mount /dev/sda1 /mnt/win`
    - ...

## 2. Drive B - VE

### 3.1  Proxmox VE 8.0

- Graphical installer

> ***SELF***

- **ARCHLINUX** ((DON'T))
  - `mkdir /mnt/pve`
  - `mount /dev/sdb2 /mnt/pve`


- BIOS
  - enable SB
  - find hdd2: EFI: proxmox: grubx64.efi ((NOT EFI: boot: bootx64.efi))
  - save, quit and bak
  - boot order: 

- Now from another PC, visit https://192.168.1.200:8006

---
---
-->


- [Proxmox VE](#proxmox-ve)
  - [live installation](#live-installation)
  - [post-install configuration](#post-install-configuration)
  - [VMs](#vms)
    - [Ubuntu Server](#ubuntu-server)


> - **NOTE 1**: humble first-ever installation
> - **NOTE 2**: if hardware runs Legacy BIOS, VMs should do too; if hardware runs UEFI, VMs should do too <!-- because odd and unexpected outcomes when it comes to memory allocation, CPU instructions or Hardware sharing and pass-through -->
> - **NOTE 3**: for them VMs, overassigning resources isn't denying them elsewhere ([thin provisioning](https://en.wikipedia.org/wiki/Thin_provisioning)). <!--OVERALLOCATION is GOOD as long as within HW BOUNDARIES-->
> - **NOTE 4**: Network Bridge == network path between VM, through Proxmox, out to a physical network adapter (NIC).


| VM Settings   | Legacy    | UEFI
| ---           | ---       | ---
| Machine       | i440fx    | q35
| BIOS          | SeaBIOS   | OVMF

| VM Settings   | Linux     | Windows
| ---           | ---       | ---
| TPM           | no        | yes
| Guest NIC     | VirtIO    | E1000

| CPU Type          | Supported CPUs (host >=)          | Instructions Supported
| ---               | ---                               | ---
| KVM64             | Intel Pentium 4, AMD Phenom       | x86_64 SSE SSE2 SSE3
| x86_64-v2-AES     | Intel Westmere, AMD Opteron G4    | + cx16 lahf-lm popcnt pni sse4.2 aes
| x86_64-v3         | Intel Broadwell, AMD v1 Naples    | + avx avx2 bmi1/2 f16c fma movbe xsave
| x86_64-v4         | Intel Skylake, AMD v4 Genoa       | + avx512 f/bw/cd/dq/vl


<details>
<summary>About Network & CPU virtualization</summary>

>[@CraftComputing: Let's Install Proxmox 8.0!](https://www.youtube.com/watch?v=sZcOlW-DwrU)

- VMs exist only through a combination of hardware sharing and software emulation
- Networking (https://pve.proxmox.com/wiki/network_configuration)
    - 'Not only are we virtualizing PC hardware to create VMs on the server, but Proxmox's Network System acts as a... Virtual Switch for all the virtual network interfaces on each individual VM.'
    - EARLY STATIC IP: virtual network bridge/adapter (vmbr0)
        - DOES: link two or more network adapters together, whether virtual or physical
        - E.G.: 192.168.1.200/24 for Proxmox, x.x.x.225 x.x.x.226 for VMs (!!)
    - Network Bridge: can be linked to multiple physical network devices (redundant pathways)
    - VMs: virtual network adapters connect to NB for eventual physical connection
        - Through virtual links: operate NB as a managed network switch (VLANs, internal...)
            <!-- Network Bridge as Virtual Switch -->
- CPU ALLOCATION == DYNAMIC BY PROXMOX & HARDWARE (VT-X||SVM)
  - Assigning a thread to a VM does not exlude that thread from being used elsewhere on the machine, either by Proxmox for overhead use, or by another VM itself.
  - Threads are max to use if available, 80% is about fine for every one... Not limited on how many threads can be allocated based on the number of cores and threads in the actual hardware; e.g. 8 c. 16 t. != only 16 t. across VMs.
- Virtual CPU Types
    - OLD Default: KVM_64 (as for Pentium_4; now P4 is always compatible on Proxmox )
    - NEW Default: x86_64_v2-AES <!--(AVX INOP ??)-->
    - Type == Features (AVX microcode instructions, AES encryption...)
    - Modern CPU: might need another Type than v2...

</details>


## live installation

- Graphical installer

```yaml
Target Harddisk:
    - Drive: /dev/sdb
    - Filesystem: ext4      # single drive installation :^(     # https://forum.proxmox.com/threads/does-it-make-sense-to-use-zfs-for-a-single-volume-hdd.117389/   # https://www.reddit.com/r/Proxmox/comments/is7wt0/single_ssd_best_practices_for_zfs/
    - Swapsize: 8GB

# Location, Time, Keyboard

Admin:
    # - User: root
    - Passwd: ...
    - Email: ...

Management Network Config:
    - Mgmt int: enp2s0
    - Hostname FQDN: homelabdiy.pqp.local           # default 'pve.homestation'
    - IP Address CIDR: 192.168.1.200/24             # default x.x.x.46
    - Gateway: 192.168.1.1
    - DNS Server: 80.58.64.250
```

## post-install configuration

```bash
# Comment out Enterprise sources tampering with 'apt update'
sed -i '/enterprise/s/^/# /' /etc/apt/sources.list/.d/cepth.list
sed -i '/enterprise/s/^/# /' /etc/apt/sources.list/.d/pve-enterprise.list
echo 'APT::Get::Show-Versions "true";' | tee /etc/apt/apt.conf.d/99show-versions

# lscpu

apt update
apt install grc btop lf nmap
apt install neofetch --no-install-recommends
```

---


## VMs


- Access web interface

```yaml
# Browser on another computer on the network: 192.168.1.200:8006
Username: root
Password: ...
```


### Ubuntu Server


- VM preps

```yaml
# Server View = local network, storage & filesystem
homelabdiy:
    local storage:
        ISO Images:     # LINUX ONLY
            File: ubuntu-22.04.3-live-server-amd64.iso

homelabdiy:
    right click:
        Create VM: WIZARD
```


- VM config

```yaml
# Create VM WIZARD
General:
    Node: homelabdiy
    VM ID: 101
    Name: HL-Ubuntu
    Resource Pool: —
OS:
    Storage: local
    ISO image: ubuntu-22.04.3-live-server-amd64.iso
    Type: Linux
    Version: 6.x Kernel
System:
    Graphic card: Default
    Machine: q35            # UEFI VM for UEFI hardware
    BIOS: OVMF              # UEFI VM for UEFI hardware
    EFI Storage: local-lvm
    SCSI Controller: VirtIO SCSI single
    Qemu Agent: no
    Add TPM: no
Disks:
    Storage: local-lvm
    Disk size GiB: 80
CPU:
    Sockets: 1
    Cores: 4                # ...
    Type: x86-64-v2-AES     # as per Gen
Memory:
    Memory MiB: 4096        # VTX == dynamically shared between host & guests
    ADVANCED:
        Ballooning Device: yes
Network:
    Bridge: vmbr0
    Model: VirtIO           # if Windows, E1000
Confirm:
    Finish: yes
```

- First VM boot

```yaml
101 HL-Ubuntu:
    Console:
        Start Now: yes

# Ubuntu Server installation
    # ...
    # network: enp6s18 == 192.168.1.36/24
    # disk: 0QEMU_foo_drive-scsi0
    # ubuntu-lv: size == max

# Remove installation medium: just ENTER
```

