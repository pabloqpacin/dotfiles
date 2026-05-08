#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_MANAGER_MODULE="${SCRIPT_DIR}/../package-manager/config-apt.sh"

if [[ -r "${PKG_MANAGER_MODULE}" ]]; then
  # shellcheck disable=SC1090
  source "${PKG_MANAGER_MODULE}"
fi

detect_pkg_manager() {
  if command -v apt-get >/dev/null 2>&1; then
    echo "apt"
  elif command -v dnf >/dev/null 2>&1; then
    echo "dnf"
  else
    echo "unknown"
  fi
}

setup_vscodium_repo_apt() {
  if declare -F ensure_apt_available >/dev/null 2>&1; then
    ensure_apt_available
  elif ! command -v apt-get >/dev/null 2>&1; then
    echo "apt-get not available on this system" >&2
    return 1
  fi

  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends wget gpg ca-certificates

  wget -qO - "https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg" \
    | gpg --dearmor \
    | sudo dd of="/usr/share/keyrings/vscodium-archive-keyring.gpg" status=none

  sudo tee "/etc/apt/sources.list.d/vscodium.sources" >/dev/null <<'EOF'
Types: deb
URIs: https://download.vscodium.com/debs
Suites: vscodium
Components: main
Architectures: amd64 arm64
Signed-by: /usr/share/keyrings/vscodium-archive-keyring.gpg
EOF
  if [[ -f "/etc/apt/sources.list.d/vscodium.list" ]]; then
    sudo rm "/etc/apt/sources.list.d/vscodium.list"
  fi
}

install_vscodium_apt() {
  setup_vscodium_repo_apt
  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update

  if declare -F apt_install >/dev/null 2>&1; then
    apt_install codium
  else
    sudo apt-get install -y --no-install-recommends codium
  fi
}

setup_vscodium_repo_dnf() {
  sudo tee "/etc/yum.repos.d/vscodium.repo" >/dev/null <<'EOF'
[gitlab.com_paulcarroty_vscodium_repo]
name=gitlab.com_paulcarroty_vscodium_repo
baseurl=https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/rpms/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg
metadata_expire=1h
EOF
}

install_vscodium_dnf() {
  setup_vscodium_repo_dnf
  sudo dnf install -y codium
}

setup_vscodium() {
  if command -v codium >/dev/null 2>&1; then
    echo "VSCodium is already installed"
    return 0
  fi

  case "$(detect_pkg_manager)" in
    apt)
      install_vscodium_apt
      ;;
    dnf)
      install_vscodium_dnf
      ;;
    *)
      echo "Unsupported package manager for VSCodium automatic install"
      echo "See: https://vscodium.com/#install"
      return 1
      ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_vscodium
fi
