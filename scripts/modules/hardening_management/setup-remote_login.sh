#!/usr/bin/env bash

# NOTA: SIEMPRE hacer Log out al terminar sesiones gráficas, NUNCA desconectarse sin más.

set -euo pipefail

GRD_PACKAGE="${GRD_PACKAGE:-gnome-remote-desktop}"
RDP_PORT="${RDP_PORT:-3389}"
ENABLE_REMOTE_LOGIN="${ENABLE_REMOTE_LOGIN:-true}"
ENABLE_SCREEN_SHARING="${ENABLE_SCREEN_SHARING:-false}"

# Mode intent:
# - ENABLE_REMOTE_LOGIN=true  => system-level RDP at GDM (headless-friendly, no user session required)
# - ENABLE_SCREEN_SHARING=true => user-session sharing (requires active graphical login)
# If both are true, system-level remote login wins.

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

install_gnome_remote_desktop() {
  if command -v grdctl >/dev/null 2>&1; then
    return 0
  fi

  case "$(detect_pkg_manager)" in
    apt)
      export DEBIAN_FRONTEND=noninteractive
      sudo apt-get update
      sudo apt-get install -y --no-install-recommends "${GRD_PACKAGE}"
      ;;
    dnf)
      sudo dnf install -y "${GRD_PACKAGE}"
      ;;
    pacman)
      sudo pacman -S --noconfirm "${GRD_PACKAGE}"
      ;;
    *)
      echo "Unsupported package manager for ${GRD_PACKAGE} installation"
      return 1
      ;;
  esac
}

is_true() {
  local value="${1:-false}"
  [[ "${value,,}" == "true" || "${value}" == "1" || "${value,,}" == "yes" ]]
}

has_active_user_session() {
  # Minimal runtime check used to avoid configuring user-mode RDP in non-graphical contexts.
  [[ -n "${XDG_RUNTIME_DIR:-}" || -n "${DISPLAY:-}" || -n "${WAYLAND_DISPLAY:-}" ]]
}

configure_system_remote_login() {
  # System mode uses sudo/grdctl --system and survives user logout.
  sudo grdctl --system rdp enable
  sudo grdctl --system rdp set-port "${RDP_PORT}" || true
  sudo systemctl enable --now gnome-remote-desktop.service
}

configure_user_screen_sharing() {
  # User mode depends on a live desktop session and user bus/systemd --user.
  grdctl rdp enable || true
  grdctl rdp set-port "${RDP_PORT}" || true
  gsettings set org.gnome.desktop.remote-desktop.rdp view-only false || true
  systemctl --user enable --now gnome-remote-desktop.service || true
}

disable_system_remote_login() {
  sudo grdctl --system rdp disable || true
  sudo systemctl stop gnome-remote-desktop.service || true
}

disable_user_screen_sharing() {
  grdctl rdp disable || true
  systemctl --user stop gnome-remote-desktop.service || true
}

print_remote_desktop_status() {
  echo "=== gnome-remote-desktop system status ==="
  sudo grdctl --system status || true
  echo "=== gnome-remote-desktop user status ==="
  grdctl status || true
}

setup_remote_login() {
  install_gnome_remote_desktop

  # Binary precedence:
  # 1) ENABLE_REMOTE_LOGIN=true -> enforce remote login only
  # 2) else ENABLE_SCREEN_SHARING=true -> enforce screen sharing only
  # 3) else -> disable both
  #
  # Why enforce one mode?
  # Running both modes tends to create ambiguous states (port/daemon ownership and session confusion).
  if is_true "${ENABLE_REMOTE_LOGIN}"; then
    disable_user_screen_sharing
    configure_system_remote_login
    if is_true "${ENABLE_SCREEN_SHARING}"; then
      echo "Both enabled; applying remote login only."
    fi
  elif is_true "${ENABLE_SCREEN_SHARING}"; then
    disable_system_remote_login
    if has_active_user_session; then
      configure_user_screen_sharing
    else
      echo "No active user session; cannot enable screen sharing."
      return 1
    fi
  else
    disable_system_remote_login
    disable_user_screen_sharing
    echo "Both disabled; remote login and screen sharing were stopped."
  fi

  print_remote_desktop_status
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_remote_login
fi

# -----------------------------------------------------------------------------
# Ops notes (commented on purpose)
# -----------------------------------------------------------------------------
# Quick status checks:
#   sudo grdctl --system status
#   grdctl status
#   sudo systemctl status gnome-remote-desktop.service --no-pager
#   systemctl --user status gnome-remote-desktop.service --no-pager
#   sudo ss -lntp | rg ':3389|:9099'    # verify listener/port conflicts
#
# Session diagnostics (useful when idle/ghost sessions conflict):
#   loginctl list-sessions
#   loginctl session-status <SESSION_ID>
#   loginctl show-session <SESSION_ID> -p Name -p State -p IdleHint -p IdleSinceHint
#   for s in $(loginctl list-sessions --no-legend | awk '{print $1}'); do
#     echo "=== Session $s ==="
#     loginctl show-session "$s" -p Type -p Remote -p Service -p State -p IdleHint -p IdleSinceHint
#   done
#
# Optional cleanup loops:
#   # Show only remote sessions (SSH/RDP)
#   for s in $(loginctl list-sessions --no-legend | awk '{print $1}'); do
#     remote=$(loginctl show-session "$s" -p Remote --value)
#     service=$(loginctl show-session "$s" -p Service --value)
#     [ "$remote" = "yes" ] && echo "session=$s service=$service"
#   done
#
#   # Exclude current session when terminating stale ones
#   current="$XDG_SESSION_ID"
#   for s in $(loginctl list-sessions --no-legend | awk '{print $1}'); do
#     [ "$s" = "$current" ] && continue
#     # loginctl terminate-session "$s"
#   done
#
# Journal debugging:
#   sudo journalctl -u gnome-remote-desktop.service -b --no-pager
#   journalctl --user -u gnome-remote-desktop.service -b --no-pager
#
# Linger controls whether user services survive logout:
#   loginctl show-user <USER> -p Linger
#   sudo loginctl disable-linger <USER>   # recommended for system remote login mode
#   sudo loginctl enable-linger <USER>    # only if persistent user services are required
#
# Optional logind hardening for remote hosts/laptops (avoid suspend-on-idle/lid):
#   sudo cp /etc/systemd/logind.conf{,.bak}
#   sudo tee -a /etc/systemd/logind.conf >/dev/null <<'EOF'
#   [Login]
#   IdleAction=ignore
#   HandleLidSwitch=ignore
#   HandleLidSwitchExternalPower=ignore
#   HandleLidSwitchDocked=ignore
#   # Optional: terminate idle sessions after 30 minutes (if supported by your systemd version)
#   StopIdleSessionSec=1800
#   EOF
#   sudo systemctl restart systemd-logind
#
# NOTE: restarting systemd-logind may terminate active user sessions.

