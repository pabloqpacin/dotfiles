#!/usr/bin/env bash

# NOTA: no se usa, convendría revisarlo y asegurarnos de que cumple lo que queremos
# TODO: flatseal (?)

set -euo pipefail

FLATHUB_NAME="flathub"
FLATHUB_URL="https://flathub.org/repo/flathub.flatpakrepo"

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

install_flatpak_if_missing() {
  if command -v flatpak >/dev/null 2>&1; then
    return 0
  fi

  case "$(detect_pkg_manager)" in
    apt)
      export DEBIAN_FRONTEND=noninteractive
      sudo apt-get update
      sudo apt-get install -y --no-install-recommends flatpak
      ;;
    dnf)
      sudo dnf install -y flatpak
      ;;
    pacman)
      sudo pacman -S --noconfirm flatpak
      ;;
    zypper)
      sudo zypper --non-interactive install --no-recommends flatpak
      ;;
    *)
      echo "Unsupported package manager: cannot install flatpak automatically" >&2
      return 1
      ;;
  esac
}

ensure_flathub_remote() {
  local scope="${1:-user}"
  if [[ "${scope}" == "system" ]]; then
    sudo flatpak remote-add --system --if-not-exists "${FLATHUB_NAME}" "${FLATHUB_URL}"
    return 0
  fi

  flatpak remote-add --user --if-not-exists "${FLATHUB_NAME}" "${FLATHUB_URL}"
}

flatpak_install_app() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: flatpak_install_app <app-id> [remote] [scope:user|system]" >&2
    return 1
  fi

  local app_id="$1"
  local remote="${2:-${FLATHUB_NAME}}"
  local scope="${3:-user}"
  if [[ "${scope}" == "system" ]]; then
    sudo flatpak install -y --noninteractive --system "${remote}" "${app_id}"
    return 0
  fi

  flatpak install -y --noninteractive --user "${remote}" "${app_id}"
}

flatpak_update_all() {
  flatpak update -y --noninteractive --user

  # Keep system-wide apps/runtime updated when available.
  if command -v sudo >/dev/null 2>&1; then
    sudo flatpak update -y --noninteractive --system || true
  fi
}

flatpak_cleanup_unused() {
  flatpak uninstall -y --unused --user

  if command -v sudo >/dev/null 2>&1; then
    sudo flatpak uninstall -y --unused --system || true
  fi
}

flatpak_audit_permissions() {
  local app_id
  local perms
  local flagged=0

  while IFS= read -r app_id; do
    [[ -z "${app_id}" ]] && continue

    perms="$(flatpak info --show-permissions "${app_id}" 2>/dev/null || true)"
    if [[ "${perms}" == *"filesystem=host"* ]] || \
      [[ "${perms}" == *"filesystem=/"* ]] || \
      [[ "${perms}" == *"device=all"* ]] || \
      [[ "${perms}" == *"socket=session-bus"* ]]; then
      flagged=1
      echo "Review permissions for ${app_id}:"
      echo "${perms}"
      echo
    fi
  done < <(flatpak list --app --columns=application --user)

  if [[ "${flagged}" -eq 0 ]]; then
    echo "No high-risk permissions detected in user Flatpak apps."
  fi
}

configure_flatpak_auto_updates_user() {
  local user_systemd_dir="${HOME}/.config/systemd/user"

  mkdir -p "${user_systemd_dir}"

  tee "${user_systemd_dir}/flatpak-update.service" >/dev/null <<'EOF'
[Unit]
Description=Update user Flatpak apps and runtimes

[Service]
Type=oneshot
ExecStart=/usr/bin/flatpak update -y --noninteractive --user
ExecStartPost=/usr/bin/flatpak uninstall -y --unused --user
EOF

  tee "${user_systemd_dir}/flatpak-update.timer" >/dev/null <<'EOF'
[Unit]
Description=Run user Flatpak updates daily

[Timer]
OnCalendar=daily
Persistent=true
RandomizedDelaySec=30m

[Install]
WantedBy=timers.target
EOF

  systemctl --user daemon-reload
  systemctl --user enable --now flatpak-update.timer
}

setup_flatpak_baseline() {
  install_flatpak_if_missing
  ensure_flathub_remote user
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_flatpak_baseline
fi