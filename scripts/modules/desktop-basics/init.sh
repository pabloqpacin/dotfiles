#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=setup-nerdfonts.sh
source "${SCRIPT_DIR}/setup-nerdfonts.sh"
# shellcheck source=setup-alacritty.sh
source "${SCRIPT_DIR}/setup-alacritty.sh"
# shellcheck source=setup-brave.sh
source "${SCRIPT_DIR}/setup-brave.sh"
# shellcheck source=install-keepassxc.sh
source "${SCRIPT_DIR}/install-keepassxc.sh"
# shellcheck source=install-wireshark.sh
source "${SCRIPT_DIR}/install-wireshark.sh"
# shellcheck source=install-spotify.sh
source "${SCRIPT_DIR}/install-spotify.sh"
# shellcheck source=install-steam.sh
source "${SCRIPT_DIR}/install-steam.sh"
# shellcheck source=install-obs.sh
source "${SCRIPT_DIR}/install-obs.sh"
# shellcheck source=install-marktext.sh
source "${SCRIPT_DIR}/install-marktext.sh"
# shellcheck source=install-vlc.sh
source "${SCRIPT_DIR}/install-vlc.sh"


setup_desktop_basics() {
  # Core desktop baseline.
  setup_nerdfonts
  setup_alacritty
  setup_brave
  install_keepassxc
  install_wireshark
  install_spotify
  install_steam
  install_obs
  install_marktext
  install_vlc
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_desktop_basics
fi
