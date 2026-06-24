#!/usr/bin/env bash

# MSC GlobalProtect VPN (PR-Computer_Vision)
# Prerequisite: Duo Mobile on Android for MFA

set -euo pipefail

install_openconnect() {
  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update
  sudo apt-get install -y openconnect network-manager-openconnect
}

# connect_openconnect() {
#   sudo openconnect --protocol=gp vpn.msccm.co.uk
#   # confirmar conexión con MFA
# }

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_openconnect
fi
