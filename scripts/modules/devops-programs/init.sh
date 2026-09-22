#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=install-terraform.sh
source "${SCRIPT_DIR}/install-terraform.sh"
# shellcheck source=install-vagrant.sh
source "${SCRIPT_DIR}/install-vagrant.sh"

setup_devops_programs() {
  setup_terraform
  setup_vagrant
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_devops_programs
fi
