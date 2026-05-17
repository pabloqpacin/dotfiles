#!/usr/bin/env bash

set -euo pipefail

detect_pkg_manager() {
  if command -v apt-get >/dev/null 2>&1; then
    echo "apt"
  elif command -v dnf >/dev/null 2>&1; then
    echo "dnf"
  elif command -v pacman >/dev/null 2>&1; then
    echo "pacman"
  else
    echo "unknown"
  fi
}

install_vlc_apt() {
  export DEBIAN_FRONTEND=noninteractive
  if ! command -v flatpak >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y --no-install-recommends flatpak
  fi

  # Use Flatpak on Debian to avoid missing RTSP/live555 libs in distro package.
  sudo flatpak remote-add --if-not-exists flathub \
    https://flathub.org/repo/flathub.flatpakrepo
  sudo flatpak install -y flathub org.videolan.VLC
}

install_vlc_dnf() {
  sudo dnf install -y vlc
}

install_vlc_pacman() {
  sudo pacman -S --noconfirm vlc
}

install_vlc() {
  if command -v vlc >/dev/null 2>&1 || \
    flatpak info org.videolan.VLC >/dev/null 2>&1; then
    echo "VLC is already installed"
    return 0
  fi

  case "$(detect_pkg_manager)" in
    apt)
      install_vlc_apt
      ;;
    dnf)
      install_vlc_dnf
      ;;
    pacman)
      install_vlc_pacman
      ;;
    *)
      echo "Unsupported package manager for VLC installation"
      return 1
      ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_vlc
fi
