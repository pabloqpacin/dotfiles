#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_MANAGER_MODULE="${SCRIPT_DIR}/../package-manager/config-apt.sh"

if [[ -r "${PKG_MANAGER_MODULE}" ]]; then
  # shellcheck disable=SC1090
  source "${PKG_MANAGER_MODULE}"
fi

detect_local_distro() {
  local distro_id=""

  if [[ -r "/etc/os-release" ]]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    distro_id="${ID:-unknown}"
  fi

  case "${distro_id}" in
    pop|pop_os|popos)
      echo "popos"
      ;;
    *)
      echo "${distro_id}"
      ;;
  esac
}

setup_brave() {
  if command -v brave-browser >/dev/null 2>&1; then
    echo "Brave is already installed"
    return 0
  fi

  local distro
  distro="$(detect_local_distro)"
  if [[ "${distro}" != "debian" && "${distro}" != "ubuntu" && "${distro}" != "popos" ]]; then
    echo "Brave APT setup is only supported on debian/ubuntu/popos (detected: ${distro})"
    return 1
  fi

  if declare -F ensure_apt_available >/dev/null 2>&1; then
    ensure_apt_available
  elif ! command -v apt-get >/dev/null 2>&1; then
    echo "apt-get not available on this system" >&2
    return 1
  fi

  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends ca-certificates curl gnupg

  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL "https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg" \
    | sudo gpg --dearmor -o /etc/apt/keyrings/brave-browser-archive-keyring.gpg
  sudo chmod a+r /etc/apt/keyrings/brave-browser-archive-keyring.gpg

  echo "deb [signed-by=/etc/apt/keyrings/brave-browser-archive-keyring.gpg arch=$(dpkg --print-architecture)] https://brave-browser-apt-release.s3.brave.com/ stable main" \
    | sudo tee /etc/apt/sources.list.d/brave-browser-release.list >/dev/null

  sudo apt-get update
  if declare -F apt_install >/dev/null 2>&1; then
    apt_install brave-browser
  else
    sudo apt-get install -y --no-install-recommends brave-browser
  fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_brave
fi
