#!/usr/bin/env bash

set -euo pipefail

create_dotfiles_symlinks() {
  local source_root="${HOME}/dotfiles/.config"
  local target_root="${HOME}/.config"

  mkdir -p "${target_root}"

  local pkg
  for pkg in lf bat tmux; do
    if [[ ! -L "${target_root}/${pkg}" ]]; then
      ln -s "${source_root}/${pkg}" "${target_root}/${pkg}"
    fi
  done
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  create_dotfiles_symlinks
fi
