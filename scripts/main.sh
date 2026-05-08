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
# shellcheck source=modules/cli-basics/cli-basics.sh
source "${MODULES_DIR}/cli-basics/cli-basics.sh"
# shellcheck source=modules/dotfiles/dotfiles-clone.sh
source "${MODULES_DIR}/dotfiles/dotfiles-clone.sh"
# shellcheck source=modules/dotfiles/dotfiles-symlink.sh
source "${MODULES_DIR}/dotfiles/dotfiles-symlink.sh"
# shellcheck source=modules/desktop-basics/setup-brave.sh
source "${MODULES_DIR}/desktop-basics/setup-brave.sh"
# shellcheck source=modules/desktop-basics/setup-alacritty.sh
source "${MODULES_DIR}/desktop-basics/setup-alacritty.sh"
# shellcheck source=modules/desktop-basics/setup-nerdfonts.sh
source "${MODULES_DIR}/desktop-basics/setup-nerdfonts.sh"
# shellcheck source=modules/shell/setup-zsh.sh
source "${MODULES_DIR}/shell/setup-zsh.sh"
# shellcheck source=modules/vim-nvim/setup-vim.sh
source "${MODULES_DIR}/vim-nvim/setup-vim.sh"
# shellcheck source=modules/desktop-ides/setup-vscodium.sh
source "${MODULES_DIR}/desktop-ides/setup-vscodium.sh"

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

echo "=== CLI BASICS INSTALL ==="
install_cli_basics
echo "CLI basics installed: yes"

echo "=== DOTFILES SETUP ==="
clone_dotfiles_repo
create_dotfiles_symlinks
echo "Dotfiles cloned/symlinked: yes"

echo "=== SHELL SETUP ==="
setup_zsh
echo "Shell configured: yes"

echo "=== VIM SETUP ==="
setup_vim
echo "Vim installed/configured: yes"

echo "=== DESKTOP BASICS ==="
setup_nerdfonts
setup_alacritty
setup_brave
echo "Desktop basics installed/configured: yes"

echo "=== DESKTOP IDES ==="
setup_vscodium
echo "Desktop IDEs installed/configured: yes"
