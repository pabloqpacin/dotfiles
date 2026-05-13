#!/usr/bin/env bash

set -euo pipefail

MARKTEXT_INSTALL_DIR="${HOME}/.local/bin"
MARKTEXT_APPIMAGE_TARGET="${MARKTEXT_INSTALL_DIR}/marktext.appimage"
MARKTEXT_LAUNCHER="${MARKTEXT_INSTALL_DIR}/marktext"
MARKTEXT_DESKTOP_ENTRY="${HOME}/.local/share/applications/marktext.desktop"

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

detect_marktext_arch() {
  local arch
  arch="$(uname -m)"

  case "${arch}" in
    x86_64|amd64)
      echo "x86_64"
      ;;
    aarch64|arm64)
      echo "arm64"
      ;;
    *)
      echo "unsupported"
      ;;
  esac
}

ensure_download_dependencies() {
  case "$(detect_pkg_manager)" in
    apt)
      export DEBIAN_FRONTEND=noninteractive
      sudo apt-get update
      sudo apt-get install -y --no-install-recommends curl ca-certificates
      ;;
    dnf)
      sudo dnf install -y curl ca-certificates
      ;;
    pacman)
      sudo pacman -S --noconfirm curl ca-certificates
      ;;
    *)
      if ! command -v curl >/dev/null 2>&1; then
        echo "curl is required to install MarkText"
        return 1
      fi
      ;;
  esac
}

download_file() {
  local url="${1:?url required}"
  local output="${2:?output path required}"
  curl -fL "${url}" -o "${output}"
}

build_marktext_download_url() {
  local arch="${1:?arch required}"

  if [[ -n "${MARKTEXT_APPIMAGE_URL:-}" ]]; then
    printf '%s\n' "${MARKTEXT_APPIMAGE_URL}"
    return 0
  fi

  case "${arch}" in
    x86_64)
      echo "https://github.com/marktext/marktext/releases/latest/download/marktext-x86_64.AppImage"
      ;;
    arm64)
      echo "https://github.com/marktext/marktext/releases/latest/download/marktext-arm64.AppImage"
      ;;
    *)
      echo "Unsupported CPU architecture for MarkText: ${arch}" >&2
      return 1
      ;;
  esac
}

create_marktext_desktop_entry() {
  mkdir -p "${HOME}/.local/share/applications"

  cat >"${MARKTEXT_DESKTOP_ENTRY}" <<EOF
[Desktop Entry]
Name=MarkText
Comment=Simple and elegant markdown editor
Exec=${MARKTEXT_LAUNCHER} %F
Icon=marktext
Terminal=false
Type=Application
Categories=Office;Utility;TextEditor;
MimeType=text/markdown;text/plain;
StartupNotify=true
EOF
}

install_marktext() {
  if command -v marktext >/dev/null 2>&1; then
    echo "MarkText is already installed"
    return 0
  fi

  local arch
  arch="$(detect_marktext_arch)"
  if [[ "${arch}" == "unsupported" ]]; then
    echo "Unsupported CPU architecture: $(uname -m)"
    return 1
  fi

  ensure_download_dependencies

  local appimage_url
  local tmp_appimage
  appimage_url="$(build_marktext_download_url "${arch}")"
  tmp_appimage="/tmp/marktext-${arch}.AppImage"

  mkdir -p "${MARKTEXT_INSTALL_DIR}"
  download_file "${appimage_url}" "${tmp_appimage}"
  mv "${tmp_appimage}" "${MARKTEXT_APPIMAGE_TARGET}"
  chmod +x "${MARKTEXT_APPIMAGE_TARGET}"

  ln -sf "${MARKTEXT_APPIMAGE_TARGET}" "${MARKTEXT_LAUNCHER}"
  create_marktext_desktop_entry

  echo "MarkText AppImage installed at ${MARKTEXT_APPIMAGE_TARGET}"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_marktext
fi
