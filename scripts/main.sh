#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DETECTIONS_DIR="${SCRIPT_DIR}/detections"
MODULES_DIR="${SCRIPT_DIR}/modules"

# shellcheck source=detect-distro.sh
source "${DETECTIONS_DIR}/detect-distro.sh"
# shellcheck source=detect-head.sh
source "${DETECTIONS_DIR}/detect-head.sh"
# shellcheck source=detect-shell.sh
source "${DETECTIONS_DIR}/detect-shell.sh"
# shellcheck source=modules/package-manager/config-apt.sh
source "${MODULES_DIR}/package-manager/config-apt.sh"

echo "=== DETECTIONS ==="
DISTRO="$(detect_distro)"
HEAD_MODE="$(detect_head_mode)"
DEFAULT_SHELL="$(detect_default_shell)"
CURRENT_SHELL="$(detect_current_shell)"
ZSH_INSTALLED="$(is_shell_installed zsh)"
OH_MY_ZSH_INSTALLED="$(is_oh_my_zsh_installed)"

echo "Detected distro: ${DISTRO}"
echo "System mode: ${HEAD_MODE}"
echo "Default shell: ${DEFAULT_SHELL}"
echo "Current shell: ${CURRENT_SHELL}"
echo "Zsh installed: ${ZSH_INSTALLED}"
echo "Oh My Zsh installed: ${OH_MY_ZSH_INSTALLED}"
echo "====="


if [[ "${DISTRO}" == "debian" || "${DISTRO}" == "ubuntu" || "${DISTRO}" == "popos" ]]; then
  echo "=== APT defaults ==="
  configure_apt_defaults
  echo "APT defaults configured: yes"
else
  echo "APT defaults configured: n/a for distro ${DISTRO}"
fi
