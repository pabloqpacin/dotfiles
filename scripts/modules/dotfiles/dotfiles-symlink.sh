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

  if command -v btm >/dev/null 2>&1 || command -v bottom >/dev/null 2>&1; then
    if [[ ! -L "${target_root}/bottom" ]]; then
      ln -s "${source_root}/bottom" "${target_root}/bottom"
    fi
  fi

  if command -v btop >/dev/null 2>&1; then
    if [[ ! -L "${target_root}/btop" ]]; then
      ln -s "${source_root}/btop" "${target_root}/btop"
    fi
  fi

  if command -v pgcli >/dev/null 2>&1; then
    if [[ ! -L "${target_root}/pgcli" ]]; then
      ln -s "${source_root}/pgcli" "${target_root}/pgcli"
    fi
  fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  create_dotfiles_symlinks
fi
