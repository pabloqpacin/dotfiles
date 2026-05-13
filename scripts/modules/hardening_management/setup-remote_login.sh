#!/usr/bin/env bash

set -euo pipefail

GRD_PACKAGE="${GRD_PACKAGE:-gnome-remote-desktop}"
RDP_PORT="${RDP_PORT:-3389}"
ENABLE_REMOTE_LOGIN="${ENABLE_REMOTE_LOGIN:-true}"
ENABLE_SCREEN_SHARING="${ENABLE_SCREEN_SHARING:-false}"

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

install_gnome_remote_desktop() {
  if command -v grdctl >/dev/null 2>&1; then
    return 0
  fi

  case "$(detect_pkg_manager)" in
    apt)
      export DEBIAN_FRONTEND=noninteractive
      sudo apt-get update
      sudo apt-get install -y --no-install-recommends "${GRD_PACKAGE}"
      ;;
    dnf)
      sudo dnf install -y "${GRD_PACKAGE}"
      ;;
    pacman)
      sudo pacman -S --noconfirm "${GRD_PACKAGE}"
      ;;
    *)
      echo "Unsupported package manager for ${GRD_PACKAGE} installation"
      return 1
      ;;
  esac
}

is_true() {
  local value="${1:-false}"
  [[ "${value,,}" == "true" || "${value}" == "1" || "${value,,}" == "yes" ]]
}

has_active_user_session() {
  [[ -n "${XDG_RUNTIME_DIR:-}" || -n "${DISPLAY:-}" || -n "${WAYLAND_DISPLAY:-}" ]]
}

configure_system_remote_login() {
  sudo grdctl --system rdp enable
  sudo grdctl --system rdp set-port "${RDP_PORT}" || true
  sudo systemctl enable --now gnome-remote-desktop.service
}

configure_user_screen_sharing() {
  grdctl rdp enable || true
  grdctl rdp set-port "${RDP_PORT}" || true
  gsettings set org.gnome.desktop.remote-desktop.rdp view-only false || true
  systemctl --user enable --now gnome-remote-desktop.service || true
}

disable_system_remote_login() {
  sudo grdctl --system rdp disable || true
  sudo systemctl stop gnome-remote-desktop.service || true
}

disable_user_screen_sharing() {
  grdctl rdp disable || true
  systemctl --user stop gnome-remote-desktop.service || true
}

print_remote_desktop_status() {
  echo "=== gnome-remote-desktop system status ==="
  sudo grdctl --system status || true
  echo "=== gnome-remote-desktop user status ==="
  grdctl status || true
}

setup_remote_login() {
  install_gnome_remote_desktop

  # Binary precedence:
  # 1) ENABLE_REMOTE_LOGIN=true -> enforce remote login only
  # 2) else ENABLE_SCREEN_SHARING=true -> enforce screen sharing only
  # 3) else -> disable both
  if is_true "${ENABLE_REMOTE_LOGIN}"; then
    disable_user_screen_sharing
    configure_system_remote_login
    if is_true "${ENABLE_SCREEN_SHARING}"; then
      echo "Both enabled; applying remote login only."
    fi
  elif is_true "${ENABLE_SCREEN_SHARING}"; then
    disable_system_remote_login
    if has_active_user_session; then
      configure_user_screen_sharing
    else
      echo "No active user session; cannot enable screen sharing."
      return 1
    fi
  else
    disable_system_remote_login
    disable_user_screen_sharing
    echo "Both disabled; remote login and screen sharing were stopped."
  fi

  print_remote_desktop_status
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_remote_login
fi
