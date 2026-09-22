#!/usr/bin/env bash

set -euo pipefail

FONT_BASE_DIR="/usr/share/fonts"
FIRA_DIR="${FONT_BASE_DIR}/FiraCodeNerd"
CASCADIA_DIR="${FONT_BASE_DIR}/CascadiaCodeNerd"
NERDFONTS_VERSION="v3.4.0"

ensure_font_tools() {
  if command -v unzip >/dev/null 2>&1 && command -v curl >/dev/null 2>&1; then
    return 0
  fi

  if command -v apt-get >/dev/null 2>&1; then
    export DEBIAN_FRONTEND=noninteractive
    sudo apt-get update
    sudo apt-get install -y --no-install-recommends curl unzip
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y curl unzip
  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -S --noconfirm curl unzip
  else
    echo "Missing curl/unzip and no supported package manager found"
    return 1
  fi
}

install_nerd_font_zip() {
  local font_name="${1:?font name required}"
  local target_dir="${2:?target dir required}"
  local zip_path="/tmp/${font_name}.zip"
  local url="https://github.com/ryanoasis/nerd-fonts/releases/download/${NERDFONTS_VERSION}/${font_name}.zip"

  if [[ -d "${target_dir}" ]]; then
    echo "${font_name} Nerd Font already installed"
    return 0
  fi

  echo "Installing ${font_name} Nerd Font"
  curl -fL "${url}" -o "${zip_path}"
  sudo mkdir -p "${target_dir}"
  sudo unzip -o "${zip_path}" -d "${target_dir}" >/dev/null
  rm -f "${zip_path}"
}

setup_nerdfonts() {
  ensure_font_tools

  install_nerd_font_zip "FiraCode" "${FIRA_DIR}"
  install_nerd_font_zip "CascadiaCode" "${CASCADIA_DIR}"

  if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -f
  fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_nerdfonts
fi
