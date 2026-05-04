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
  elif command -v pacman >/dev/null 2>&1; then
    echo "pacman"
  else
    echo "unknown"
  fi
}

ensure_bat_command() {
  if command -v bat >/dev/null 2>&1; then
    return 0
  fi

  if command -v batcat >/dev/null 2>&1; then
    local batcat_path
    batcat_path="$(command -v batcat)"
    local target_path="/usr/local/bin/bat"

    if [[ ! -e "${target_path}" ]]; then
      sudo ln -s "${batcat_path}" "${target_path}"
    fi
  fi
}

install_cli_basics() {
  local pkg_manager
  pkg_manager="$(detect_pkg_manager)"

  case "${pkg_manager}" in
    apt)
      if declare -F configure_apt_defaults >/dev/null 2>&1; then
        configure_apt_defaults
      fi
      sudo apt-get update
      if declare -F apt_install >/dev/null 2>&1; then
        apt_install python3-pip python3-venv bat fzf git grc jq lf ripgrep nmap tmux tree yq
      else
        sudo apt-get install -y --no-install-recommends \
          python3-pip python3-venv bat fzf git grc jq lf ripgrep nmap tmux tree yq
      fi
      ;;
    dnf)
      sudo dnf install -y python3-pip bat fzf git grc jq lf ripgrep nmap tmux tree yq
      ;;
    pacman)
      sudo pacman -S --noconfirm python-pip bat fzf git grc jq lf ripgrep nmap tmux tree yq
      ;;
    *)
      echo "Unsupported package manager. Install manually: bat fzf git grc jq lf ripgrep nmap tmux tree yq"
      return 1
      ;;
  esac

  ensure_bat_command
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_cli_basics
fi
