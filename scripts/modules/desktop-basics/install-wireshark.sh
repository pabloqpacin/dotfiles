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

install_wireshark_packages() {
  case "$(detect_pkg_manager)" in
    apt)
      export DEBIAN_FRONTEND=noninteractive
      sudo apt-get update
      if command -v debconf-set-selections >/dev/null 2>&1; then
        echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections || true
      fi
      sudo apt-get install -y --no-install-recommends wireshark tshark
      ;;
    dnf)
      sudo dnf install -y wireshark wireshark-cli
      ;;
    pacman)
      sudo pacman -S --noconfirm wireshark-qt wireshark-cli
      ;;
    *)
      echo "Unsupported package manager for Wireshark installation"
      return 1
      ;;
  esac
}

add_user_to_wireshark_group() {
  local target_user="${SUDO_USER:-${USER:-}}"
  [[ -z "${target_user}" ]] && return 0

  if ! getent group wireshark >/dev/null 2>&1; then
    sudo groupadd wireshark
  fi

  if id -nG "${target_user}" | rg -w "wireshark" >/dev/null 2>&1; then
    return 0
  fi

  sudo usermod -aG wireshark "${target_user}"
  echo "========================================================================"
  echo "User '${target_user}' added to wireshark group."
  echo "Log out/in (or run: newgrp wireshark) to apply group membership."
  echo "========================================================================"
}

install_wireshark() {
  if command -v wireshark >/dev/null 2>&1 || command -v tshark >/dev/null 2>&1; then
    echo "Wireshark/TShark already installed (ensuring permissions)"
  else
    install_wireshark_packages
  fi
  add_user_to_wireshark_group
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_wireshark
fi
