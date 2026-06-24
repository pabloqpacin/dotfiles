#!/usr/bin/env bash

set -euo pipefail

# Verifies apt-get exists on the system.
ensure_apt_available() {
  if ! command -v apt-get >/dev/null 2>&1; then
    echo "apt-get not available on this system" >&2
    return 1
  fi
}

# Writes a small idempotent APT defaults file.
configure_apt_defaults() {
  ensure_apt_available

  sudo tee /etc/apt/apt.conf.d/99custom >/dev/null <<'EOF'
APT::Get::Show-Versions "true";
Acquire::Retries "3";
Dpkg::Use-Pty "0";
EOF
}

# Common non-interactive update and cleanup flow.
apt_update_upgrade_cleanup() {
  ensure_apt_available

  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update
  sudo apt-get upgrade -y
  sudo apt-get autoremove --purge -y
  sudo apt-get autoclean -y
}

# Installs packages with sane defaults.
apt_install() {
  ensure_apt_available

  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get install -y --no-install-recommends "$@"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  configure_apt_defaults
fi
