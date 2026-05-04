#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=detect-distro.sh
source "${SCRIPT_DIR}/detect-distro.sh"
# shellcheck source=detect-head.sh
source "${SCRIPT_DIR}/detect-head.sh"

DISTRO="$(detect_distro)"
HEAD_MODE="$(detect_head_mode)"

echo "Detected distro: ${DISTRO}"
echo "System mode: ${HEAD_MODE}"
