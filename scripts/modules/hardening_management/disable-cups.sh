#!/usr/bin/env bash

set -euo pipefail

disable_unit_if_present() {
  local unit_name="$1"
  sudo systemctl stop "${unit_name}" 2>/dev/null || true
  sudo systemctl disable "${unit_name}" 2>/dev/null || true
  sudo systemctl mask "${unit_name}" 2>/dev/null || true
  echo "Disabled and masked ${unit_name}"
}

check_unit_status() {
  local unit_name="$1"
  local enabled_state
  local active_state

  if ! systemctl list-unit-files --type=service --type=socket 2>/dev/null | rg -q "^${unit_name}[[:space:]]"; then
    echo "absent"
    return 0
  fi

  enabled_state="$(systemctl is-enabled "${unit_name}" 2>/dev/null || true)"
  active_state="$(systemctl is-active "${unit_name}" 2>/dev/null || true)"

  if [[ "${enabled_state}" == "masked" && "${active_state}" == "inactive" ]]; then
    echo "already_disabled"
    return 0
  fi

  echo "needs_disable"
}

disable_cups() {
  local unit_name
  local status

  for unit_name in \
    "cups.service" \
    "cups.socket" \
    "cups.path" \
    "cups-browsed.service"; do
    status="$(check_unit_status "${unit_name}")"

    case "${status}" in
      absent)
        echo "Skipping ${unit_name}: unit not present"
        ;;
      already_disabled)
        echo "Skipping ${unit_name}: already disabled and masked"
        ;;
      needs_disable)
        disable_unit_if_present "${unit_name}"
        ;;
    esac
  done
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  disable_cups
fi
