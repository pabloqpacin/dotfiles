#!/usr/bin/env bash

set -euo pipefail

COCKPIT_PORT="${COCKPIT_PORT:-9099}"

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

install_cockpit_apt() {
  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends cockpit
}

install_cockpit_dnf() {
  sudo dnf install -y cockpit
}

install_cockpit_pacman() {
  sudo pacman -S --noconfirm cockpit
}

install_cockpit_package() {
  if command -v cockpit-bridge >/dev/null 2>&1; then
    echo "Cockpit is already installed"
    return 0
  fi

  case "$(detect_pkg_manager)" in
    apt)
      install_cockpit_apt
      ;;
    dnf)
      install_cockpit_dnf
      ;;
    pacman)
      install_cockpit_pacman
      ;;
    *)
      echo "Unsupported package manager for Cockpit installation"
      return 1
      ;;
  esac
}

enable_cockpit_socket() {
  sudo systemctl enable --now cockpit.socket
}

configure_cockpit_socket_port() {
  local drop_in_dir="/etc/systemd/system/cockpit.socket.d"
  local drop_in_file="${drop_in_dir}/override.conf"

  sudo mkdir -p "${drop_in_dir}"
  sudo tee "${drop_in_file}" >/dev/null <<EOF
[Socket]
ListenStream=
ListenStream=${COCKPIT_PORT}
EOF

  sudo systemctl daemon-reload
  sudo systemctl restart cockpit.socket
}

start_cockpit_service_now() {
  # cockpit.service is static on Debian (socket-activated), so we start it
  # for immediate availability while keeping cockpit.socket enabled for boot.
  sudo systemctl start cockpit.service
}

print_cockpit_hint() {
  local host_ip
  host_ip="$(hostname -I 2>/dev/null | awk '{print $1}')"
  host_ip="${host_ip:-localhost}"
  echo "Cockpit available at: https://${host_ip}:${COCKPIT_PORT}"
}

setup_cockpit() {
  install_cockpit_package
  configure_cockpit_socket_port
  enable_cockpit_socket
  start_cockpit_service_now
  # Firewall rules are intentionally managed in modules/hardening_management/setup-firewall.sh.
  print_cockpit_hint
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_cockpit
fi
