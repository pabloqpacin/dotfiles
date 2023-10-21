#!/bin/bash

# Tested on the latest:
#   - Debian (xfce) --> debian --- XFCE
#   - Ubuntu ---------> ubuntu --- ubuntu:GNOME
#   - PopOS ----------> pop ------ pop:GNOME
#   - Arch (i3) ------> arch ----- i3

# Print distro
grep "^ID=" /etc/os-release | awk -F '=' '{print $2}'

# Print DE/WM
echo $XDG_CURRENT_DESKTOP
