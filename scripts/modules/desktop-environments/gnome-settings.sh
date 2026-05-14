#!/usr/bin/env bash

set -euo pipefail

DISABLE_AUTO_SUSPEND_ON_AC="${DISABLE_AUTO_SUSPEND_ON_AC:-yes}"
ENABLE_DARK_MODE="${ENABLE_DARK_MODE:-yes}"

is_gnome_session_for_settings() {
  [[ "${XDG_CURRENT_DESKTOP:-}" == *GNOME* ]] || [[ "${DESKTOP_SESSION:-}" == *gnome* ]]
}

setup_gnome_settings() {
  if ! command -v gsettings >/dev/null 2>&1; then
    echo "gsettings not available, skipping GNOME runtime settings"
    return 0
  fi

  if ! is_gnome_session_for_settings; then
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

  # Custom keyboard shortcuts.
  local path_brave="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom90/"
  local path_term="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom91/"
  local path_files="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom92/"
  local current_list
  current_list="$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)"
  current_list="${current_list#@as }"

  if [[ "${current_list}" != *"'${path_brave}'"* ]]; then
    if [[ "${current_list}" == "[]" ]]; then
      current_list="['${path_brave}']"
    else
      current_list="${current_list%]}"
      current_list="${current_list}, '${path_brave}']"
    fi
  fi
  if [[ "${current_list}" != *"'${path_term}'"* ]]; then
    if [[ "${current_list}" == "[]" ]]; then
      current_list="['${path_term}']"
    else
      current_list="${current_list%]}"
      current_list="${current_list}, '${path_term}']"
    fi
  fi
  if [[ "${current_list}" != *"'${path_files}'"* ]]; then
    if [[ "${current_list}" == "[]" ]]; then
      current_list="['${path_files}']"
    else
      current_list="${current_list%]}"
      current_list="${current_list}, '${path_files}']"
    fi
  fi
  gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "${current_list}"

  gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:${path_brave}" name "Brave Browser"
  gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:${path_brave}" command "brave-browser"
  gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:${path_brave}" binding "<Super>b"
  gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:${path_term}" name "Alacritty"
  gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:${path_term}" command "alacritty"
  gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:${path_term}" binding "<Super>t"
  gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:${path_files}" name "Files"
  gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:${path_files}" command "nautilus --new-window"
  gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:${path_files}" binding "<Super>f"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_gnome_settings
fi
