#!/usr/bin/env bash

set -euo pipefail

HASHICORP_KEYRING_PATH="/usr/share/keyrings/hashicorp-archive-keyring.gpg"
HASHICORP_REPO_LIST_PATH="/etc/apt/sources.list.d/hashicorp.list"
HASHICORP_DNF_REPO_PATH="/etc/yum.repos.d/hashicorp.repo"

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

setup_vagrant_apt() {
  local codename=""
  local arch=""

  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends gnupg software-properties-common wget

  codename="$(detect_apt_codename)"
  arch="$(dpkg --print-architecture)"

  wget -O - https://apt.releases.hashicorp.com/gpg \
    | sudo gpg --dearmor -o "${HASHICORP_KEYRING_PATH}"

  echo "deb [arch=${arch} signed-by=${HASHICORP_KEYRING_PATH}] https://apt.releases.hashicorp.com ${codename} main" \
    | sudo tee "${HASHICORP_REPO_LIST_PATH}" >/dev/null

  sudo apt-get update
  sudo apt-get install -y vagrant
}

setup_vagrant_dnf() {
  sudo dnf install -y dnf-plugins-core
  wget -O- https://rpm.releases.hashicorp.com/fedora/hashicorp.repo \
    | sudo tee "${HASHICORP_DNF_REPO_PATH}" >/dev/null

  # Informational check from HashiCorp docs; keep non-fatal.
  sudo dnf list available | rg -i hashicorp || true
  sudo dnf -y install vagrant
}

setup_vagrant() {
  case "$(detect_pkg_manager)" in
    apt)
      setup_vagrant_apt
      ;;
    dnf)
      setup_vagrant_dnf
      ;;
    *)
      echo "setup_vagrant currently supports apt (Debian/Ubuntu) and dnf (Fedora)."
      return 1
      ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_vagrant
fi
