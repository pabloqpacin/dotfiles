#!/usr/bin/env bash

set -euo pipefail

STEAM_DEB_URL="${STEAM_DEB_URL:-https://cdn.akamai.steamstatic.com/client/installer/steam.deb}"

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

install_steam_apt() {
  export DEBIAN_FRONTEND=noninteractive

  sudo dpkg --add-architecture i386
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends ca-certificates curl

  local tmp_pkg="/tmp/steam.deb"
  curl -fL "${STEAM_DEB_URL}" -o "${tmp_pkg}"
  sudo apt-get install -y "${tmp_pkg}"
  rm -f "${tmp_pkg}"
}

install_steam_dnf() {
  # Requires RPM Fusion on Fedora/RHEL-like systems.
  sudo dnf install -y steam
}

install_steam_pacman() {
  sudo pacman -S --noconfirm steam
}

install_steam() {
  if command -v steam >/dev/null 2>&1; then
    echo "Steam is already installed"
    return 0
  fi

  case "$(detect_pkg_manager)" in
    apt)
      install_steam_apt
      ;;
    dnf)
      install_steam_dnf
      ;;
    pacman)
      install_steam_pacman
      ;;
    *)
      echo "Unsupported package manager for Steam installation"
      return 1
      ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_steam
fi
