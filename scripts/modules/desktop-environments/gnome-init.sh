#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# # shellcheck source=gnome-extensions.sh
# source "${SCRIPT_DIR}/gnome-extensions.sh"
# shellcheck source=gnome-settings.sh
source "${SCRIPT_DIR}/gnome-settings.sh"
# # shellcheck source=gnome-wallpapers.sh
# source "${SCRIPT_DIR}/gnome-wallpapers.sh"

is_gnome_session_for_init() {
  [[ "${XDG_CURRENT_DESKTOP:-}" == *GNOME* ]] || [[ "${DESKTOP_SESSION:-}" == *gnome* ]]
}

setup_gnome_init() {
  if ! is_gnome_session_for_init; then
    echo "GNOME init skipped: non-GNOME session"
    return 0
  fi

  setup_gnome_settings
  # setup_gnome_extensions
  # setup_gnome_wallpapers
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_gnome_init
fi
