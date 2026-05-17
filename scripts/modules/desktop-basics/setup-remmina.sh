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

install_remmina_apt() {
  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update
  sudo apt-get install -y remmina
}

install_remmina_dnf() {
  sudo dnf install -y remmina
}

install_remmina_pacman() {
  sudo pacman -S --noconfirm remmina
}

setup_remmina() {
  if command -v remmina >/dev/null 2>&1; then
    echo "Remmina is already installed"
    return 0
  fi

  case "$(detect_pkg_manager)" in
    apt)
      install_remmina_apt
      ;;
    dnf)
      install_remmina_dnf
      ;;
    pacman)
      install_remmina_pacman
      ;;
    *)
      echo "Unsupported package manager for Remmina installation"
      return 1
      ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_remmina
fi
