#!/usr/bin/env bash

set -euo pipefail

FIREWALL_ENABLE="${FIREWALL_ENABLE:-true}"
OPEN_TCP_PORTS=(22 3389 8080 9099)

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

install_ufw() {
  if command -v ufw >/dev/null 2>&1; then
    echo "ufw is already installed"
    return 0
  fi

  case "$(detect_pkg_manager)" in
    apt)
      export DEBIAN_FRONTEND=noninteractive
      sudo apt-get update
      sudo apt-get install -y --no-install-recommends ufw
      ;;
    dnf)
      # TODO: firewalld
      sudo dnf install -y ufw
      ;;
    pacman)
      sudo pacman -S --noconfirm ufw
      ;;
    *)
      echo "Unsupported package manager for ufw installation"
      return 1
      ;;
  esac
}

configure_ufw_baseline() {
  # Simple and safe baseline.
  sudo ufw default deny incoming
  sudo ufw default allow outgoing

  local port
  for port in "${OPEN_TCP_PORTS[@]}"; do
    sudo ufw allow "${port}/tcp" || true
  done

  if [[ "${FIREWALL_ENABLE}" == "true" ]]; then
    sudo ufw --force enable
  fi
}

print_firewall_summary() {
  echo "Firewall configured with UFW."
  echo "- Incoming default: deny"
  echo "- Outgoing default: allow"
  echo "- Allowed inbound TCP ports: ${OPEN_TCP_PORTS[*]}"
  # Future improvements:
  # - Restrict these ports by VPN/LAN CIDR.
  # - Add optional Docker DOCKER-USER rules if you expose services publicly.
}

setup_firewall() {
  install_ufw
  configure_ufw_baseline
  print_firewall_summary
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_firewall
fi
