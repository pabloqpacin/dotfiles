#!/usr/bin/env bash

set -euo pipefail

# Ref: https://obsproject.com/kb/linux-installation

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

install_obs_apt() {
  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends ffmpeg obs-studio
}

install_obs_dnf() {
  sudo dnf install -y ffmpeg obs-studio
}

install_obs_pacman() {
  sudo pacman -S --noconfirm ffmpeg obs-studio
}

install_obs() {
  if command -v obs >/dev/null 2>&1 || command -v obs-studio >/dev/null 2>&1; then
    echo "OBS Studio is already installed"
    return 0
  fi

  case "$(detect_pkg_manager)" in
    apt)
      install_obs_apt
      ;;
    dnf)
      install_obs_dnf
      ;;
    pacman)
      install_obs_pacman
      ;;
    *)
      echo "Unsupported package manager for OBS Studio installation"
      return 1
      ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_obs
fi
