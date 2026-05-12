#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=setup-firewall.sh
source "${SCRIPT_DIR}/setup-firewall.sh"
# shellcheck source=setup-cockpit.sh
source "${SCRIPT_DIR}/setup-cockpit.sh"
# shellcheck source=disable-cups.sh
source "${SCRIPT_DIR}/disable-cups.sh"

setup_hardening_management() {
  setup_firewall
  setup_cockpit

  # Optional hardening: avoid disabling print services unless explicitly requested.
  if [[ "${HARDENING_DISABLE_CUPS:-true}" == "true" ]]; then
    disable_cups
  fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_hardening_management
fi
