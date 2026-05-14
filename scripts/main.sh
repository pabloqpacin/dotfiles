#!/usr/bin/env bash

# NOTA: lo primero que se hace es instalar y confgurar Timeshift (ojo con config. discos durante instalación OS...).
# TODO: diferenciar instalación para desktop personal vs servidor desktop (ojo desktop-basics/).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMON_DIR="${SCRIPT_DIR}/common"
MODULES_DIR="${SCRIPT_DIR}/modules"

# shellcheck source=check-distro.sh
source "${COMMON_DIR}/check-distro.sh"
# shellcheck source=check-headless_or_desktop.sh
source "${COMMON_DIR}/check-headless_or_desktop.sh"
# shellcheck source=check-shell.sh
source "${COMMON_DIR}/check-shell.sh"
# shellcheck source=modules/package-manager/config-apt.sh
source "${MODULES_DIR}/package-manager/config-apt.sh"
# shellcheck source=modules/hardening_management/setup-timeshift.sh
source "${MODULES_DIR}/hardening_management/setup-timeshift.sh"
# shellcheck source=modules/cli-basics/cli-basics.sh
source "${MODULES_DIR}/cli-basics/cli-basics.sh"
# shellcheck source=modules/dotfiles/dotfiles-clone.sh
source "${MODULES_DIR}/dotfiles/dotfiles-clone.sh"
# shellcheck source=modules/dotfiles/dotfiles-symlink.sh
source "${MODULES_DIR}/dotfiles/dotfiles-symlink.sh"
# shellcheck source=modules/dotfiles/git-config.sh
source "${MODULES_DIR}/dotfiles/git-config.sh"
# shellcheck source=modules/desktop-basics/init.sh
source "${MODULES_DIR}/desktop-basics/init.sh"
# shellcheck source=modules/shell/setup-zsh.sh
source "${MODULES_DIR}/shell/setup-zsh.sh"
# shellcheck source=modules/vim-nvim/setup-vim.sh
source "${MODULES_DIR}/vim-nvim/setup-vim.sh"
# shellcheck source=modules/desktop-ides/setup-vscodium.sh
source "${MODULES_DIR}/desktop-ides/setup-vscodium.sh"
# shellcheck source=modules/desktop-ides/setup-cursor.sh
source "${MODULES_DIR}/desktop-ides/setup-cursor.sh"
# shellcheck source=modules/desktop-environments/gnome-init.sh
source "${MODULES_DIR}/desktop-environments/gnome-init.sh"
# shellcheck source=modules/containers/setup-docker.sh
source "${MODULES_DIR}/containers/setup-docker.sh"
# shellcheck source=modules/devops-programs/init.sh
source "${MODULES_DIR}/devops-programs/init.sh"
# shellcheck source=modules/hardening_management/init.sh
source "${MODULES_DIR}/hardening_management/init.sh"

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

echo "=== SYSTEM SNAPSHOTS ==="
setup_timeshift
echo "Timeshift installed/configured: yes"

echo "=== CLI BASICS INSTALL ==="
install_cli_basics
echo "CLI basics installed: yes"

echo "=== DOTFILES SETUP ==="
clone_dotfiles_repo
create_dotfiles_symlinks
setup_gitconfig
echo "Dotfiles cloned/symlinked: yes"

echo "=== SHELL SETUP ==="
setup_zsh
echo "Shell configured: yes"

echo "=== VIM SETUP ==="
setup_vim
echo "Vim installed/configured: yes"

echo "=== DESKTOP BASICS ==="
setup_desktop_basics
echo "Desktop basics installed/configured: yes"

echo "=== DESKTOP IDES ==="
setup_vscodium
setup_cursor
echo "Desktop IDEs installed/configured: yes"

echo "=== CONTAINERS ==="
setup_docker
echo "Containers installed/configured: yes"

echo "=== DEVOPS PROGRAMS ==="
setup_devops_programs
echo "DevOps programs installed/configured: yes"

echo "=== HARDENING & MANAGEMENT ==="
setup_hardening_management
echo "Management services installed/configured: yes"

if [[ "${HEAD_MODE}" == "desktop" && "${XDG_CURRENT_DESKTOP:-}" == *GNOME* ]]; then
  echo "=== GNOME INIT ==="
  setup_gnome_init
  echo "GNOME init applied: yes"
else
  echo "GNOME init skipped: non-GNOME desktop or headless"
fi
