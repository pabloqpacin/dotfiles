#!/usr/bin/env bash

set -euo pipefail

ENABLE_WALLPAPER_CAROUSEL="${ENABLE_WALLPAPER_CAROUSEL:-yes}"
WALLPAPER_CAROUSEL_INTERVAL="${WALLPAPER_CAROUSEL_INTERVAL:-15m}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
WALLPAPER_DIR="${WALLPAPER_DIR:-${DOTFILES_ROOT}/img/wallpapers}"
CAROUSEL_RUNNER="${CAROUSEL_RUNNER:-${SCRIPT_DIR}/gnome-wallpaper-carousel-runner.sh}"

is_gnome_session_for_wallpapers() {
  [[ "${XDG_CURRENT_DESKTOP:-}" == *GNOME* ]] || [[ "${DESKTOP_SESSION:-}" == *gnome* ]]
}

wallpaper_files_exist() {
  [[ -d "${WALLPAPER_DIR}" ]] || return 1

  local images=()
  local ext
  shopt -s nullglob
  for ext in jpg jpeg png; do
    images+=("${WALLPAPER_DIR}"/*.${ext} "${WALLPAPER_DIR}"/*.${ext^^})
  done
  shopt -u nullglob

  [[ ${#images[@]} -gt 0 ]]
}

configure_wallpaper_carousel() {
  if [[ "${ENABLE_WALLPAPER_CAROUSEL}" != "yes" ]]; then
    return 0
  fi
  if ! is_gnome_session_for_wallpapers; then
    return 0
  fi
  if ! command -v gsettings >/dev/null 2>&1; then
    return 0
  fi
  if ! command -v systemctl >/dev/null 2>&1; then
    return 0
  fi
  if ! wallpaper_files_exist; then
    echo "Wallpaper carousel skipped: no images found in ${WALLPAPER_DIR}"
    return 0
  fi

  local user_systemd_dir="${HOME}/.config/systemd/user"
  local user_config_dir="${HOME}/.config"
  local env_file="${user_config_dir}/gnome-wallpaper-carousel.env"

  mkdir -p "${user_systemd_dir}" "${user_config_dir}"

  if [[ ! -x "${CAROUSEL_RUNNER}" ]]; then
    echo "Wallpaper carousel runner missing or not executable: ${CAROUSEL_RUNNER}" >&2
    return 1
  fi

  cat > "${env_file}" <<EOF
WALLPAPER_DIR=${WALLPAPER_DIR}
EOF

  cat > "${user_systemd_dir}/gnome-wallpaper-carousel.service" <<EOF
[Unit]
Description=Rotate GNOME wallpaper from dotfiles carousel

[Service]
Type=oneshot
EnvironmentFile=${env_file}
ExecStart=${CAROUSEL_RUNNER}
EOF

  cat > "${user_systemd_dir}/gnome-wallpaper-carousel.timer" <<EOF
[Unit]
Description=Rotate GNOME wallpaper periodically

[Timer]
OnBootSec=2m
OnUnitActiveSec=${WALLPAPER_CAROUSEL_INTERVAL}
Persistent=true

[Install]
WantedBy=timers.target
EOF

  systemctl --user daemon-reload
  systemctl --user enable --now gnome-wallpaper-carousel.timer
  systemctl --user start gnome-wallpaper-carousel.service
  echo "Wallpaper carousel enabled from ${WALLPAPER_DIR} (every ${WALLPAPER_CAROUSEL_INTERVAL})."
}

setup_gnome_wallpapers() {
  configure_wallpaper_carousel
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_gnome_wallpapers
fi
