#!/usr/bin/env bash

# NOTA: en wayland, no funciona.

set -euo pipefail

detect_pkg_manager() {
  if command -v apt-get >/dev/null 2>&1; then
    echo "apt"
  elif command -v dnf >/dev/null 2>&1; then
    echo "dnf"
  elif command -v pacman >/dev/null 2>&1; then
    echo "pacman"
  elif command -v zypper >/dev/null 2>&1; then
    echo "zypper"
  else
    echo "unknown"
  fi
}

detect_session_type() {
  local session_type="${XDG_SESSION_TYPE:-}"
  if [[ -n "${session_type}" ]]; then
    printf '%s\n' "${session_type,,}"
    return 0
  fi
  echo "unknown"
}

detect_portal_backend_package() {
  local desktop="${XDG_CURRENT_DESKTOP:-}"
  desktop="${desktop,,}"

  case "${desktop}" in
    *kde*|*plasma*)
      echo "xdg-desktop-portal-kde"
      ;;
    *gnome*)
      echo "xdg-desktop-portal-gnome"
      ;;
    *sway*|*hypr*|*wlroots*|*river*|*wayfire*)
      echo "xdg-desktop-portal-wlr"
      ;;
    *)
      echo "xdg-desktop-portal-gtk"
      ;;
  esac
}

install_flameshot_apt() {
  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends flameshot
}

install_flameshot_dnf() {
  sudo dnf install -y flameshot
}

install_flameshot_pacman() {
  sudo pacman -S --noconfirm flameshot
}

install_flameshot_zypper() {
  sudo zypper -n install flameshot
}

ensure_wayland_portal() {
  local pkg_manager="$1"
  local backend_pkg
  backend_pkg="$(detect_portal_backend_package)"

  case "${pkg_manager}" in
    apt)
      export DEBIAN_FRONTEND=noninteractive
      sudo apt-get update
      sudo apt-get install -y --no-install-recommends xdg-desktop-portal "${backend_pkg}" || true
      ;;
    dnf)
      sudo dnf install -y xdg-desktop-portal "${backend_pkg}" || true
      ;;
    pacman)
      sudo pacman -S --noconfirm xdg-desktop-portal "${backend_pkg}" || true
      ;;
    zypper)
      sudo zypper -n install xdg-desktop-portal "${backend_pkg}" || true
      ;;
    *)
      ;;
  esac
}

print_wayland_notes() {
  echo "========================================================================"
  echo "Wayland session detected."
  echo "Flameshot works on Wayland using xdg-desktop-portal."
  echo "If capture fails, restart the session and ensure the portal service is active."
  echo "========================================================================"
}

install_flameshot() {
  local pkg_manager
  pkg_manager="$(detect_pkg_manager)"

  if command -v flameshot >/dev/null 2>&1; then
    echo "Flameshot is already installed"
  else
    case "${pkg_manager}" in
      apt)
        install_flameshot_apt
        ;;
      dnf)
        install_flameshot_dnf
        ;;
      pacman)
        install_flameshot_pacman
        ;;
      zypper)
        install_flameshot_zypper
        ;;
      *)
        echo "Unsupported package manager for Flameshot installation"
        return 1
        ;;
    esac
  fi

  if [[ "$(detect_session_type)" == "wayland" ]]; then
    ensure_wayland_portal "${pkg_manager}"
    print_wayland_notes
  fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_flameshot
fi
