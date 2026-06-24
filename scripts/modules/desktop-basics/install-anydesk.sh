#!/usr/bin/env bash

set -euo pipefail

ANYDESK_KEYRING_PATH="/etc/apt/keyrings/anydesk-archive-keyring.gpg"
ANYDESK_REPO_LIST_PATH="/etc/apt/sources.list.d/anydesk-stable.list"
ANYDESK_UDEV_RULE_PATH="/etc/udev/rules.d/99-anydesk-uinput.rules"

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

install_anydesk_apt() {
  export DEBIAN_FRONTEND=noninteractive

  sudo apt-get update
  sudo apt-get install -y --no-install-recommends ca-certificates curl gnupg

  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL "https://keys.anydesk.com/repos/DEB-GPG-KEY" \
    | gpg --dearmor \
    | sudo tee "${ANYDESK_KEYRING_PATH}" >/dev/null
  sudo chmod a+r "${ANYDESK_KEYRING_PATH}"

  echo "deb [signed-by=${ANYDESK_KEYRING_PATH} arch=$(dpkg --print-architecture)] http://deb.anydesk.com/ all main" \
    | sudo tee "${ANYDESK_REPO_LIST_PATH}" >/dev/null

  sudo apt-get update
  sudo apt-get install -y --no-install-recommends anydesk
}

install_anydesk() {
  if command -v anydesk >/dev/null 2>&1; then
    echo "AnyDesk is already installed"
    return 0
  fi

  case "$(detect_pkg_manager)" in
    apt)
      install_anydesk_apt
      ;;
    *)
      echo "AnyDesk auto-install currently supports apt-based distros only."
      return 1
      ;;
  esac
}

configure_anydesk_uinput_access() {
  if [[ ! -e /dev/uinput ]]; then
    echo "/dev/uinput not found; skipping AnyDesk input injection fix"
    return 0
  fi

  sudo chown root:input /dev/uinput
  sudo chmod 660 /dev/uinput

  echo 'KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"' \
    | sudo tee "${ANYDESK_UDEV_RULE_PATH}" >/dev/null

  sudo udevadm control --reload-rules
  sudo udevadm trigger

  if command -v systemctl >/dev/null 2>&1; then
    sudo systemctl restart anydesk || true
  fi
}

print_anydesk_post_install_notes() {
  echo "AnyDesk note: open AnyDesk -> Settings -> Security and enable unattended access."
  echo "Set a password there, otherwise remote users will not be able to connect unattended."
}

setup_anydesk() {
  install_anydesk
  configure_anydesk_uinput_access
  print_anydesk_post_install_notes
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_anydesk
fi
