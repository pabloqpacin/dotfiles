#!/usr/bin/env bash

set -euo pipefail

# Returns a normalized distro name (e.g. debian, ubuntu, popos, fedora).
detect_distro() {
  local distro_id=""
  local distro_like=""

  if [[ -r "/etc/os-release" ]]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    distro_id="${ID:-}"
    distro_like="${ID_LIKE:-}"
  elif command -v lsb_release >/dev/null 2>&1; then
    distro_id="$(lsb_release -si 2>/dev/null | tr '[:upper:]' '[:lower:]')"
  else
    echo "unknown"
    return 0
  fi

  distro_id="$(printf '%s' "${distro_id}" | tr '[:upper:]' '[:lower:]')"
  distro_like="$(printf '%s' "${distro_like}" | tr '[:upper:]' '[:lower:]')"

  case "${distro_id}" in
    pop|pop_os|popos)
      echo "popos"
      ;;
    ubuntu|debian|fedora|arch|manjaro|kali|raspbian|linuxmint)
      echo "${distro_id}"
      ;;
    *)
      if [[ "${distro_like}" == *debian* ]]; then
        echo "debian"
      elif [[ "${distro_like}" == *ubuntu* ]]; then
        echo "ubuntu"
      elif [[ "${distro_like}" == *fedora* || "${distro_like}" == *rhel* ]]; then
        echo "fedora"
      elif [[ "${distro_like}" == *arch* ]]; then
        echo "arch"
      else
        echo "${distro_id:-unknown}"
      fi
      ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  detect_distro
fi
