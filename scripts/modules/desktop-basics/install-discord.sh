#!/usr/bin/env bash

set -euo pipefail

DISCORD_FLATPAK_APP_ID="${DISCORD_FLATPAK_APP_ID:-com.discordapp.Discord}"

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

install_flatpak_runtime() {
  if command -v flatpak >/dev/null 2>&1; then
    return 0
  fi

  case "$(detect_pkg_manager)" in
    apt)
      export DEBIAN_FRONTEND=noninteractive
      sudo apt-get update
      sudo apt-get install -y --no-install-recommends flatpak
      ;;
    dnf)
      sudo dnf install -y flatpak
      ;;
    pacman)
      sudo pacman -S --noconfirm flatpak
      ;;
    *)
      echo "Unsupported package manager for Flatpak installation"
      return 1
      ;;
  esac
}

install_discord() {
  if command -v discord >/dev/null 2>&1; then
    echo "Discord is already installed"
    return 0
  fi
  if command -v flatpak >/dev/null 2>&1 && flatpak info "${DISCORD_FLATPAK_APP_ID}" >/dev/null 2>&1; then
    echo "Discord Flatpak is already installed"
    return 0
  fi

  install_flatpak_runtime

  sudo flatpak remote-add --if-not-exists flathub \
    https://flathub.org/repo/flathub.flatpakrepo
  sudo flatpak install -y flathub "${DISCORD_FLATPAK_APP_ID}"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_discord
fi
