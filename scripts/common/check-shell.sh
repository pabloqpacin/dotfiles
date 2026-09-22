#!/usr/bin/env bash

set -euo pipefail

# Returns the default login shell for the current user (full path).
get_default_shell_path() {
  local shell_path=""
  local user_name="${USER:-}"

  if [[ -n "${user_name}" ]] && command -v getent >/dev/null 2>&1; then
    shell_path="$(getent passwd "${user_name}" 2>/dev/null | awk -F: '{print $7}')"
  fi

  if [[ -z "${shell_path}" && -n "${SHELL:-}" ]]; then
    shell_path="${SHELL}"
  fi

  printf '%s\n' "${shell_path:-unknown}"
}

# Returns a normalized default shell name: bash, zsh, other, or unknown.
detect_default_shell() {
  local shell_path
  shell_path="$(get_default_shell_path)"

  case "${shell_path##*/}" in
    bash)
      echo "bash"
      ;;
    zsh)
      echo "zsh"
      ;;
    unknown|"")
      echo "unknown"
      ;;
    *)
      echo "other"
      ;;
  esac
}

# Returns a normalized current shell name: bash, zsh, other, or unknown.
detect_current_shell() {
  local current_shell=""

  if command -v ps >/dev/null 2>&1; then
    current_shell="$(ps -p "${PPID}" -o comm= 2>/dev/null | awk '{print $1}')"
  fi

  if [[ -z "${current_shell}" && -n "${0:-}" ]]; then
    current_shell="${0##*/}"
  fi

  case "${current_shell##*/}" in
    bash)
      echo "bash"
      ;;
    zsh)
      echo "zsh"
      ;;
    "")
      echo "unknown"
      ;;
    *)
      echo "other"
      ;;
  esac
}

# Returns "yes" if the shell binary exists in PATH, "no" otherwise.
is_shell_installed() {
  local shell_name="${1:-}"
  [[ -z "${shell_name}" ]] && return 1

  if command -v "${shell_name}" >/dev/null 2>&1; then
    echo "yes"
  else
    echo "no"
  fi
}

# Returns "yes" if Oh My Zsh directory exists, "no" otherwise.
is_oh_my_zsh_installed() {
  local oh_my_zsh_dir="${ZSH:-${HOME}/.oh-my-zsh}"

  if [[ -d "${oh_my_zsh_dir}" ]]; then
    echo "yes"
  else
    echo "no"
  fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  default_shell="$(detect_default_shell)"
  current_shell="$(detect_current_shell)"
  zsh_installed="$(is_shell_installed zsh)"
  oh_my_zsh_installed="$(is_oh_my_zsh_installed)"

  echo "default_shell=${default_shell}"
  echo "current_shell=${current_shell}"
  echo "zsh_installed=${zsh_installed}"
  echo "oh_my_zsh_installed=${oh_my_zsh_installed}"
fi
