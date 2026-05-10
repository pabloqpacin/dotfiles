#!/usr/bin/env bash

set -euo pipefail

detect_linux_id() {
  if [[ -r "/etc/os-release" ]]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    printf '%s\n' "${ID:-unknown}"
    return 0
  fi
  echo "unknown"
}

install_spotify_debian() {
  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends curl ca-certificates gnupg

  curl -sS "https://download.spotify.com/debian/pubkey_5384CE82BA52C83A.asc" \
    | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg

  echo "deb https://repository.spotify.com stable non-free" \
    | sudo tee /etc/apt/sources.list.d/spotify.list >/dev/null

  sudo apt-get update
  sudo apt-get install -y --no-install-recommends spotify-client
}

install_spotify() {
  if command -v spotify >/dev/null 2>&1; then
    echo "Spotify is already installed"
    return 0
  fi

  case "$(detect_linux_id)" in
    debian)
      install_spotify_debian
      ;;
    *)
      echo "Spotify module currently supports Debian apt flow only."
      return 1
      ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_spotify
fi
