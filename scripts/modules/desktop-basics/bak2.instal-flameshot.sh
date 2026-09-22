#!/usr/bin/env bash

set -euo pipefail

FLATHUB_NAME="flathub"
FLATHUB_URL="https://flathub.org/repo/flathub.flatpakrepo"
FLAMESHOT_APP_ID="org.flameshot.Flameshot"

detect_portal_backend_pkg() {
  local desktop="${XDG_CURRENT_DESKTOP:-}"
  desktop="${desktop,,}"

  case "${desktop}" in
    *gnome*)
      echo "xdg-desktop-portal-gnome"
      ;;
    *kde*|*plasma*)
      echo "xdg-desktop-portal-kde"
      ;;
    *)
      echo "xdg-desktop-portal-gtk"
      ;;
  esac
}

ensure_wayland_portal_stack() {
  local backend_pkg
  backend_pkg="$(detect_portal_backend_pkg)"

  sudo apt-get update
  sudo apt-get install -y --no-install-recommends \
    xdg-desktop-portal \
    "${backend_pkg}" \
    gnome-shell-extension-appindicator
}

apply_flatpak_wayland_overrides() {
  # Keep access tight but explicit so the app can talk to screenshot portal.
  flatpak override --user "${FLAMESHOT_APP_ID}" \
    --socket=wayland \
    --socket=fallback-x11 \
    --talk-name=org.freedesktop.portal.Desktop
}

print_wayland_debug_hints() {
  echo "Wayland detected."
  echo "If capture still fails, restart session and verify portal:"
  echo "  systemctl --user status xdg-desktop-portal.service"
  echo "  systemctl --user status xdg-desktop-portal-gnome.service"
  echo "Run test:"
  echo "  flatpak run ${FLAMESHOT_APP_ID} gui"
}

install_flameshot_debian_flatpak() {
  if ! command -v apt-get >/dev/null 2>&1; then
    echo "This script is intended for Debian/apt systems." >&2
    return 1
  fi

  export DEBIAN_FRONTEND=noninteractive

  if ! command -v flatpak >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y --no-install-recommends flatpak
  fi

  flatpak remote-add --user --if-not-exists "${FLATHUB_NAME}" "${FLATHUB_URL}"

  if flatpak info --user "${FLAMESHOT_APP_ID}" >/dev/null 2>&1; then
    echo "Flameshot Flatpak is already installed (${FLAMESHOT_APP_ID})."
  else
    flatpak install -y --noninteractive --user "${FLATHUB_NAME}" "${FLAMESHOT_APP_ID}"
  fi

  if [[ "${XDG_SESSION_TYPE:-}" == "wayland" ]]; then
    ensure_wayland_portal_stack
    apply_flatpak_wayland_overrides
    print_wayland_debug_hints
  fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_flameshot_debian_flatpak
fi
