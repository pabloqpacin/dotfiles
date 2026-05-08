#!/usr/bin/env bash

set -euo pipefail

# Optional feature flags (override with env vars before running).
ENABLE_FLATPAK_PLUGIN="${ENABLE_FLATPAK_PLUGIN:-yes}"
DISABLE_AUTO_SUSPEND_ON_AC="${DISABLE_AUTO_SUSPEND_ON_AC:-yes}"
ENABLE_DARK_MODE="${ENABLE_DARK_MODE:-yes}"

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

install_gnome_packages() {
  case "$(detect_pkg_manager)" in
    apt)
      export DEBIAN_FRONTEND=noninteractive
      sudo apt-get update
      sudo apt-get install -y --no-install-recommends \
        gnome-tweaks gnome-shell-extensions gnome-shell-extension-manager dconf-cli
      if [[ "${ENABLE_FLATPAK_PLUGIN}" == "yes" ]]; then
        sudo apt-get install -y --no-install-recommends gnome-software-plugin-flatpak
      fi
      ;;
    dnf)
      sudo dnf install -y gnome-tweaks gnome-extensions-app dconf
      ;;
    pacman)
      sudo pacman -S --noconfirm gnome-tweaks gnome-shell-extensions dconf
      ;;
    *)
      echo "Unsupported package manager for GNOME tweaks bootstrap"
      return 1
      ;;
  esac
}

is_gnome_session() {
  [[ "${XDG_CURRENT_DESKTOP:-}" == *GNOME* ]] || [[ "${DESKTOP_SESSION:-}" == *gnome* ]]
}

apply_gnome_settings() {
  if ! command -v gsettings >/dev/null 2>&1; then
    echo "gsettings not available, skipping GNOME runtime settings"
    return 0
  fi

  if ! is_gnome_session; then
    echo "Not running a GNOME session, skipping runtime gsettings tweaks"
    return 0
  fi

  # Windows and focus behavior.
  gsettings set org.gnome.desktop.wm.preferences button-layout "appmenu:minimize,maximize,close"
  # gsettings set org.gnome.desktop.wm.preferences focus-mode "click"

  # Usability defaults.
  gsettings set org.gnome.desktop.interface clock-format "24h"
  gsettings set org.gnome.desktop.peripherals.keyboard delay 250
  gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 25
  # gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']"
  gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
  gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false

  # Top bar / shell quality-of-life.
  gsettings set org.gnome.desktop.interface show-battery-percentage true

  if [[ "${ENABLE_DARK_MODE}" == "yes" ]]; then
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
  fi

  if [[ "${DISABLE_AUTO_SUSPEND_ON_AC}" == "yes" ]]; then
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type "nothing"
  fi
}

setup_gnome_tweaks() {
  install_gnome_packages
  apply_gnome_settings
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_gnome_tweaks
fi
