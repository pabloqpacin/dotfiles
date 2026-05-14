#!/usr/bin/env bash

# NOTE: $ sudo etckeeper vcs log

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

install_etckeeper_package() {
  if command -v etckeeper >/dev/null 2>&1; then
    echo "etckeeper is already installed"
    return 0
  fi

  case "$(detect_pkg_manager)" in
    apt)
      export DEBIAN_FRONTEND=noninteractive
      sudo apt-get update
      sudo apt-get install -y --no-install-recommends etckeeper git
      ;;
    dnf)
      sudo dnf install -y etckeeper git
      ;;
    pacman)
      sudo pacman -S --noconfirm etckeeper git
      ;;
    *)
      echo "Unsupported package manager for etckeeper installation"
      return 1
      ;;
  esac
}

is_etckeeper_repo_initialized() {
  sudo test -d /etc/.git
}

is_etckeeper_git_process_running() {
  ps -eo pid=,args= | rg -q "[g]it .*\/etc\/.git"
}

cleanup_stale_etckeeper_lock() {
  local lock_file="/etc/.git/index.lock"

  if ! sudo test -e "${lock_file}"; then
    return 0
  fi

  if is_etckeeper_git_process_running; then
    echo "etckeeper git lock exists and a git process is active: ${lock_file}"
    return 1
  fi

  echo "Removing stale etckeeper git lock: ${lock_file}"
  sudo rm -f "${lock_file}"
}

create_initial_etckeeper_commit_if_needed() {
  local pending_changes
  pending_changes="$(sudo etckeeper vcs status --porcelain 2>/dev/null || true)"

  if [[ -n "${pending_changes}" ]]; then
    sudo etckeeper commit "Initial etckeeper snapshot"
  fi
}

setup_etckeeper() {
  install_etckeeper_package

  if ! is_etckeeper_repo_initialized; then
    sudo etckeeper init
  else
    echo "etckeeper repository already initialized at /etc/.git"
  fi

  cleanup_stale_etckeeper_lock
  create_initial_etckeeper_commit_if_needed
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_etckeeper
fi
