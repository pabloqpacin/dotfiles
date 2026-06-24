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

install_keepassxc() {
  if command -v keepassxc >/dev/null 2>&1; then
    echo "KeePassXC is already installed"
    return 0
  fi

  case "$(detect_pkg_manager)" in
    apt)
      export DEBIAN_FRONTEND=noninteractive
      sudo apt-get update
      sudo apt-get install -y --no-install-recommends keepassxc
      ;;
    dnf)
      sudo dnf install -y keepassxc
      ;;
    pacman)
      sudo pacman -S --noconfirm keepassxc
      ;;
    *)
      echo "Unsupported package manager for KeePassXC installation"
      return 1
      ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_keepassxc
fi
