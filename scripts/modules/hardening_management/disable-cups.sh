#!/usr/bin/env bash

set -euo pipefail

disable_unit_if_present() {
  local unit_name="$1"

  if ! systemctl list-unit-files --type=service --type=socket 2>/dev/null | rg -q "^${unit_name}[[:space:]]"; then
    echo "Skipping ${unit_name}: unit not present"
    return 0
  fi

  sudo systemctl stop "${unit_name}" 2>/dev/null || true
  sudo systemctl disable "${unit_name}" 2>/dev/null || true
  sudo systemctl mask "${unit_name}" 2>/dev/null || true
  echo "Disabled and masked ${unit_name}"
}

disable_cups() {
  disable_unit_if_present "cups.service"
  disable_unit_if_present "cups.socket"
  disable_unit_if_present "cups.path"
  disable_unit_if_present "cups-browsed.service"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  disable_cups
fi
