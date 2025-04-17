#!/bin/bash

# Tested on the latest:
#   - Debian (xfce) --> debian --- XFCE
#   - Ubuntu ---------> ubuntu --- ubuntu:GNOME
#   - PopOS ----------> pop ------ pop:GNOME
#   - Arch (i3) ------> arch ----- i3

# Print distro
grep "^ID=" /etc/os-release | awk -F '=' '{print $2}' || true

# Print DE/WM
echo "${XDG_CURRENT_DESKTOP}"

# ---

identify_package_manager(){
    # https://unix.stackexchange.com/questions/46081/identifying-the-system-package-manager

    # Initialize an associative array to map release files to package managers
    declare -A osInfo=(
        ["/etc/alpine-release"]="apk"
        ["/etc/arch-release"]="pacman"
        ["/etc/debian_version"]="apt-get"
        ["/etc/gentoo-release"]="emerge"
        ["/etc/redhat-release"]="dnf"
        ["/etc/SuSE-release"]="zypp"
    )

    # Loop through each release file in the array
    for release_file in "${!osInfo[@]}"; do
        # Check if the release file exists
        if [[ -f "${release_file}" ]]; then
            # Assign the package manager based on the found release file
            DISTRO="${osInfo[${release_file}]}"
            break  # Exit the loop once a release file is found
        fi
    done

    # If no release file is found, set a default package manager
    if [[ -z "${DISTRO}" ]]; then
        DISTRO="unknown"
    fi

    # # Print the detected package manager
    # echo "Package manager: $DISTRO"
}

# identify_package_manager
