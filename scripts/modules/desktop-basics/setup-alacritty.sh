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

install_alacritty() {
  if command -v alacritty >/dev/null 2>&1; then
    echo "Alacritty is already installed"
    return 0
  fi

  local pkg_manager
  pkg_manager="$(detect_pkg_manager)"

  case "${pkg_manager}" in
    apt)
      export DEBIAN_FRONTEND=noninteractive
      sudo apt-get update
      sudo apt-get install -y --no-install-recommends alacritty
      ;;
    dnf)
      sudo dnf install -y alacritty
      ;;
    pacman)
      sudo pacman -S --noconfirm alacritty
      ;;
    *)
      echo "Unsupported package manager for Alacritty installation"
      return 1
      ;;
  esac
}

symlink_alacritty_config() {
  local source_dir="${HOME}/dotfiles/.config/alacritty"
  local target_dir="${HOME}/.config/alacritty"

  mkdir -p "${HOME}/.config"

  if [[ ! -d "${source_dir}" ]]; then
    echo "Dotfiles alacritty config not found at ${source_dir}"
    return 1
  fi

  if [[ -L "${target_dir}" ]]; then
    return 0
  fi

  if [[ -e "${target_dir}" ]]; then
    echo "Existing ${target_dir} found (not a symlink), skipping"
    return 0
  fi

  ln -s "${source_dir}" "${target_dir}"
}

setup_alacritty() {
  install_alacritty
  symlink_alacritty_config
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_alacritty
fi
