# medocs

> WIP

---

## Multiboot

### notes

- **Hyprland** won't perform well in a vm
- Using [Ventoy](https://github.com/ventoy/Ventoy) as the bootable flashdrive solution
- Nowadays never choosing to create a separate /home partition
- Mind the software selection in terms of CPU and GPU firmware
- Mind them differences between a vm and a baremetal installation
- One dedicated drive for Windows and another one with GRUB for them Linux distros
- Pretty basic *NixOS* setup atm, looking forward to incorporate **home-manager** and more
- Also looking forward to incorporate **cron**, a backup system and a proper password manager

### steps


1. If existing OS, back up everything as we'll fully format the drives
2. Take a look at the BIOS/UEFI boot and secure-boot settings
3. Install [Windows 11](/docs/windows/Win11_Desktop.md) to drive A
   - Get a Home version licence, choose Home or Pro N
   - Repartition the disk. There will be a boot partition and a primary C:\\. Create a another D:\\ partition for Data. Let's keep it clean.
4. Install [Arch Linux or NixOS](/docs/linux/) to drive B
   - The fun begins
   - Follow my documentation but mind the software selection in terms of CPU and GPU firmware
   - Focused on the WMs Hyprland and i3 but it's a lotta work, a whole DE should be just fine
   - Set the bootloader correctly for UEFI or BIOS. I use GRUB with `os-prober`. Theme it.
5. Reboot into Arch / NixOS
   - Probably fail, meaning the Windows bootloader hasn't relinquished its boot priority
6. Boot into the BIOS/UEFI
   - Move the Windows Bootloader down -- drive A
   - Move the relevant EFI partition with GRUB on top, just below the USBs -- drive B
   - The CLI tool `efibootmgr` may come in handy against boot problems
7. Boot into Arch / NixOS successfully
   - On minimal Arch, always `mkdir` mountpoints and `mount` the relevant partitions, then update GRUB
8. Install [another distro](/docs/linux/PopOS.md) to drive B
   - Whatever the distro, just create one ext4 partition and mount the existing boot and swap partitions
   - I believe it's very important: whatever the distro, just create one ext4 partition and mount the existing boot and swap partitions
   - If installing *openSUSE-Tumbleweed*, be careful about [Btrfs](https://en.opensuse.org/SDB:BTRFS). Great filesystem but I couldn't multiboot into it.
   - Not sure how or why, but I couldn't install two instances of NixOS, they'd blend...
9.  Boot back into Arch / NixOS
    - Update or rebuild the bootloader
10. Verify and repeat
    -  Find all the OSs on the GRUB menu and verify they'll boot right
    -  That's about it!

---

## Labs

> WIP