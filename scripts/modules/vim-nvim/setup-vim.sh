#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/dotfiles}"
VIMRC_SOURCE="${DOTFILES_DIR}/.vimrc"

ensure_dotfiles_repo() {
  if [[ -d "${DOTFILES_DIR}" ]]; then
    return 0
  fi

  git clone --depth=1 --branch=develop "https://github.com/pabloqpacin/dotfiles" "${DOTFILES_DIR}"
}

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

install_vim() {
  if command -v vim >/dev/null 2>&1; then
    echo "vim is already installed"
    return 0
  fi

  case "$(detect_pkg_manager)" in
    apt)
      export DEBIAN_FRONTEND=noninteractive
      sudo apt-get update
      sudo apt-get install -y --no-install-recommends vim
      ;;
    dnf)
      sudo dnf install -y vim
      ;;
    pacman)
      sudo pacman -S --noconfirm vim
      ;;
    *)
      echo "Unsupported package manager for vim installation"
      return 1
      ;;
  esac
}

symlink_vimrc_for_user() {
  local target_file="${HOME}/.vimrc"

  if [[ -L "${target_file}" ]] && [[ "$(readlink -f "${target_file}")" == "${VIMRC_SOURCE}" ]]; then
    return 0
  fi

  if [[ -e "${target_file}" ]]; then
    mv "${target_file}" "${target_file}.bak.$(date +%s)"
  fi

  ln -s "${VIMRC_SOURCE}" "${target_file}"
}

symlink_vimrc_for_root() {
  local target_file="/root/.vimrc"

  if sudo test -L "${target_file}" && [[ "$(sudo readlink -f "${target_file}")" == "${VIMRC_SOURCE}" ]]; then
    return 0
  fi

  if sudo test -e "${target_file}"; then
    sudo mv "${target_file}" "${target_file}.bak.$(date +%s)"
  fi

  sudo ln -s "${VIMRC_SOURCE}" "${target_file}"
}

setup_vim() {
  ensure_dotfiles_repo

  if [[ ! -f "${VIMRC_SOURCE}" ]]; then
    echo ".vimrc not found at ${VIMRC_SOURCE}"
    return 1
  fi

  install_vim
  symlink_vimrc_for_user
  symlink_vimrc_for_root
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_vim
fi
