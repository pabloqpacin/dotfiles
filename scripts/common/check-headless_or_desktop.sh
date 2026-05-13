#!/usr/bin/env bash

set -euo pipefail

# Returns:
# - "desktop" if a graphical session/display is detected
# - "headless" otherwise
detect_head_mode() {
  # Fast path: current shell already has a graphical display in environment.
  if [[ -n "${DISPLAY:-}" || -n "${WAYLAND_DISPLAY:-}" ]]; then
    echo "desktop"
    return 0
  fi

  # Check if system default target is graphical.
  if command -v systemctl >/dev/null 2>&1; then
    local default_target=""
    default_target="$(systemctl get-default 2>/dev/null || true)"
    if [[ "${default_target}" == "graphical.target" ]]; then
      echo "desktop"
      return 0
    fi
  fi

  # Check if there is any active graphical user session.
  if command -v loginctl >/dev/null 2>&1; then
    local session_id
    while read -r session_id _; do
      [[ -z "${session_id:-}" ]] && continue
      if [[ "$(loginctl show-session "${session_id}" -p Type --value 2>/dev/null || true)" =~ ^(x11|wayland)$ ]]; then
        echo "desktop"
        return 0
      fi
    done < <(loginctl list-sessions --no-legend 2>/dev/null || true)
  fi

  # Fallback: no graphics evidence found.
  echo "headless"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  detect_head_mode
fi
