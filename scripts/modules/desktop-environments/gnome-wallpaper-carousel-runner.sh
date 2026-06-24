#!/usr/bin/env bash

set -euo pipefail

WALLPAPER_DIR="${WALLPAPER_DIR:-${HOME}/dotfiles/img/wallpapers}"
STATE_DIR="${XDG_STATE_HOME:-${HOME}/.local/state}"
STATE_FILE="${STATE_DIR}/gnome-wallpaper-carousel-index"

mkdir -p "${STATE_DIR}"

collect_wallpapers() {
  local ext
  local files=()

  shopt -s nullglob
  for ext in jpg jpeg png; do
    files+=("${WALLPAPER_DIR}"/*.${ext} "${WALLPAPER_DIR}"/*.${ext^^})
  done
  shopt -u nullglob

  if [[ ${#files[@]} -eq 0 ]]; then
    return 1
  fi

  IFS=$'\n' files=($(printf '%s\n' "${files[@]}" | sort))
  unset IFS
  printf '%s\n' "${files[@]}"
}

mapfile -t images < <(collect_wallpapers) || exit 0

idx=0
if [[ -f "${STATE_FILE}" ]]; then
  state="$(<"${STATE_FILE}")"
  if [[ "${state}" =~ ^[0-9]+$ ]]; then
    idx="${state}"
  fi
fi

pos=$((idx % ${#images[@]}))
selected="${images[${pos}]}"
next=$(((pos + 1) % ${#images[@]}))

if command -v python3 >/dev/null 2>&1; then
  uri="$(python3 -c 'import pathlib,sys; print(pathlib.Path(sys.argv[1]).resolve().as_uri())' "${selected}")"
else
  uri="file://${selected}"
fi

gsettings set org.gnome.desktop.background picture-uri "${uri}"
gsettings set org.gnome.desktop.background picture-uri-dark "${uri}" >/dev/null 2>&1 || true
printf '%s\n' "${next}" > "${STATE_FILE}"
