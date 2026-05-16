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

has_etckeeper_commits() {
  sudo etckeeper vcs rev-parse --verify HEAD >/dev/null 2>&1
}

create_initial_etckeeper_commit_if_needed() {
  if has_etckeeper_commits; then
    return 0
  fi

  local pending_changes
  pending_changes="$(sudo etckeeper vcs status --porcelain 2>/dev/null || true)"

  if [[ -n "${pending_changes}" ]]; then
    sudo etckeeper commit "Initial etckeeper snapshot"
  fi
}

setup_etckeeper() {
  install_etckeeper_package

  local just_initialized=false
  if ! is_etckeeper_repo_initialized; then
    sudo etckeeper init
    just_initialized=true
  else
    echo "etckeeper repository already initialized at /etc/.git"
  fi

  cleanup_stale_etckeeper_lock

  # Only snapshot right after first init; later /etc changes from main.sh are
  # picked up by etckeeper apt hooks and cron.daily autocommits.
  if [[ "${just_initialized}" == "true" ]]; then
    create_initial_etckeeper_commit_if_needed
  fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_etckeeper
fi

# Quick status:
#   sudo etckeeper vcs status
#   sudo etckeeper vcs status --porcelain
#
# View history (newest first):
#   sudo etckeeper vcs log --oneline --decorate --graph -n 20
#
# Inspect what changed in /etc:
#   sudo etckeeper vcs diff
#   sudo etckeeper vcs diff -- /etc/ssh/sshd_config
#
# Create a manual commit (recommended before risky edits):
#   sudo etckeeper commit "Describe why this /etc change is needed"
#
# Automatic commits (daily):
#   # Config file:
#   sudo rg -n "AVOID_DAILY_AUTOCOMMITS|AVOID_COMMIT_BEFORE_INSTALL" /etc/etckeeper/etckeeper.conf
#   # By default, cron.daily may run automatic commits:
#   ls -l /etc/cron.daily/etckeeper
#   # Optional systemd timer (usually disabled unless explicitly enabled):
#   systemctl is-enabled etckeeper.timer
#   systemctl status etckeeper.timer --no-pager
#   # Enable timer if you prefer systemd scheduling:
#   sudo systemctl enable --now etckeeper.timer
#
# Show last commit details:
#   sudo etckeeper vcs show --name-status --stat HEAD
#
# Restore a file from previous commit:
#   sudo etckeeper vcs checkout HEAD~1 -- /etc/<path-to-file>
#   # Then verify and commit the restore operation if desired.
