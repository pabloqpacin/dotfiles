#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/dotfiles}"

symlink_with_backup() {
  local source_file="${1:?source file required}"
  local target_file="${2:?target file required}"

  if [[ ! -f "${source_file}" ]]; then
    echo "Settings source not found: ${source_file}"
    return 1
  fi

  mkdir -p "$(dirname "${target_file}")"

  if [[ -L "${target_file}" ]] && [[ "$(readlink -f "${target_file}")" == "${source_file}" ]]; then
    return 0
  fi

  if [[ -e "${target_file}" ]]; then
    mv "${target_file}" "${target_file}.bak.$(date +%s)"
  fi

  ln -s "${source_file}" "${target_file}"
}

setup_ide_settings() {
  local ide="${1:-all}"
  local codium_source="${DOTFILES_DIR}/.config/code/User/settings.json"
  local codium_target="${HOME}/.config/VSCodium/User/settings.json"
  local cursor_source="${DOTFILES_DIR}/.config/Cursor/settings.jsonc"
  local cursor_target="${HOME}/.config/Cursor/User/settings.json"

  case "${ide}" in
    vscodium)
      symlink_with_backup "${codium_source}" "${codium_target}"
      ;;
    cursor)
      symlink_with_backup "${cursor_source}" "${cursor_target}"
      ;;
    all)
      symlink_with_backup "${codium_source}" "${codium_target}"
      symlink_with_backup "${cursor_source}" "${cursor_target}"
      ;;
    *)
      echo "Unknown IDE target for settings: ${ide}"
      return 1
      ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_ide_settings
fi
