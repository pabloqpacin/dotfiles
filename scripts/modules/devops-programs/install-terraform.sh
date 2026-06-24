#!/usr/bin/env bash

set -euo pipefail

HASHICORP_KEYRING_PATH="/usr/share/keyrings/hashicorp-archive-keyring.gpg"
HASHICORP_REPO_LIST_PATH="/etc/apt/sources.list.d/hashicorp.list"

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

detect_apt_codename() {
  local codename=""

  if [[ -r /etc/os-release ]]; then
    # shellcheck disable=SC1091
    source /etc/os-release
    codename="${UBUNTU_CODENAME:-${VERSION_CODENAME:-}}"
  fi

  if [[ -z "${codename}" ]] && command -v lsb_release >/dev/null 2>&1; then
    codename="$(lsb_release -cs)"
  fi

  if [[ -z "${codename}" ]]; then
    echo "Could not detect distro codename for HashiCorp repository."
    return 1
  fi

  printf '%s\n' "${codename}"
}

setup_terraform_apt() {
  local codename=""
  local arch=""

  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends gnupg wget
  codename="$(detect_apt_codename)"
  arch="$(dpkg --print-architecture)"

  wget -O- https://apt.releases.hashicorp.com/gpg \
    | gpg --dearmor \
    | sudo tee "${HASHICORP_KEYRING_PATH}" >/dev/null

  echo "=== HashiCorp repository key fingerprint ==="
  gpg --no-default-keyring \
    --keyring "${HASHICORP_KEYRING_PATH}" \
    --fingerprint

  echo "deb [arch=${arch} signed-by=${HASHICORP_KEYRING_PATH}] https://apt.releases.hashicorp.com ${codename} main" \
    | sudo tee "${HASHICORP_REPO_LIST_PATH}" >/dev/null
  sudo apt-get update
  sudo apt-get install -y terraform
}

setup_terraform_dnf() {
  sudo dnf install -y dnf-plugins-core
  sudo dnf config-manager addrepo --from-repofile=https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
  sudo dnf -y install terraform
}

setup_terraform() {
  if command -v terraform >/dev/null 2>&1; then
    echo "terraform is already installed"
    return 0
  fi

  case "$(detect_pkg_manager)" in
    apt)
      setup_terraform_apt
      ;;
    dnf)
      setup_terraform_dnf
      ;;
    *)
      echo "setup_terraform currently supports apt (Debian/Ubuntu) and dnf (Fedora)."
      return 1
      ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_terraform
fi
