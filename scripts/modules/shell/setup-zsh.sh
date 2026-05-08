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

install_zsh_package() {
  if command -v zsh >/dev/null 2>&1; then
    echo "zsh is already installed"
    return 0
  fi

  local pkg_manager
  pkg_manager="$(detect_pkg_manager)"

  case "${pkg_manager}" in
    apt)
      export DEBIAN_FRONTEND=noninteractive
      sudo apt-get update
      sudo apt-get install -y --no-install-recommends zsh
      ;;
    dnf)
      sudo dnf install -y zsh
      ;;
    pacman)
      sudo pacman -S --noconfirm zsh
      ;;
    *)
      echo "Unsupported package manager for zsh installation"
      return 1
      ;;
  esac
}

ensure_dotfiles_repo() {
  local dotfiles_dir="${HOME}/dotfiles"

  if [[ -d "${dotfiles_dir}" ]]; then
    return 0
  fi

  git clone --depth=1 --branch=develop "https://github.com/pabloqpacin/dotfiles" "${dotfiles_dir}"
}

install_oh_my_zsh() {
  if [[ -d "${HOME}/.oh-my-zsh" ]]; then
    echo "Oh My Zsh is already installed"
    return 0
  fi

  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

symlink_dotfiles_zshrc() {
  local source_file="${HOME}/dotfiles/.zshrc"
  local target_file="${HOME}/.zshrc"

  if [[ ! -f "${source_file}" ]]; then
    echo "Dotfiles .zshrc not found at ${source_file}"
    return 1
  fi

  if [[ -L "${target_file}" ]]; then
    return 0
  fi

  if [[ -e "${target_file}" ]]; then
    mv "${target_file}" "${target_file}.bak.$(date +%s)"
  fi

  ln -s "${source_file}" "${target_file}"
}

install_dotfiles_zsh_plugins() {
  local plugins_dir="${HOME}/dotfiles/zsh/plugins"
  mkdir -p "${plugins_dir}"

  if [[ ! -d "${plugins_dir}/zsh-autosuggestions" ]]; then
    git clone --depth 1 \
      "https://github.com/zsh-users/zsh-autosuggestions" \
      "${plugins_dir}/zsh-autosuggestions"
  fi

  if [[ ! -d "${plugins_dir}/zsh-syntax-highlighting" ]]; then
    git clone --depth 1 \
      "https://github.com/zsh-users/zsh-syntax-highlighting" \
      "${plugins_dir}/zsh-syntax-highlighting"
  fi
}

run_oh_my_zsh_theme_helper() {
  local file="${HOME}/.oh-my-zsh/themes/random.zsh-theme"

  if [[ ! -f "${file}" ]]; then
    echo "Oh My Zsh random theme file not found at ${file}"
    return 0
  fi

  grep -e "loaded" "${file}" || true
  sed -i '/loaded/ { /^[[:space:]]*#/! s/^/# /; }' "${file}"
  grep -e "loaded" "${file}" || true
}

set_default_shell_to_zsh() {
  local zsh_path
  zsh_path="$(command -v zsh)"
  local current_default="${SHELL:-}"

  if [[ "${current_default}" == "${zsh_path}" ]]; then
    return 0
  fi

  if command -v chsh >/dev/null 2>&1; then
    sudo chsh -s "${zsh_path}" "${USER}" || true
  fi
}

setup_zsh() {
  install_zsh_package
  ensure_dotfiles_repo
  install_oh_my_zsh
  symlink_dotfiles_zshrc
  install_dotfiles_zsh_plugins
  run_oh_my_zsh_theme_helper
  set_default_shell_to_zsh
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_zsh
fi
