#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HELPER_EXTENSIONS_MODULE="${SCRIPT_DIR}/helper/vscode-extensions.sh"
HELPER_SETTINGS_MODULE="${SCRIPT_DIR}/helper/ide-settings.sh"
CURSOR_API_BASE="https://api2.cursor.sh/updates/download"
CURSOR_CHANNEL="${CURSOR_CHANNEL:-golden}"
CURSOR_VERSION="${CURSOR_VERSION:-3.3}"
INSTALL_DIR_APPIMAGE="${HOME}/.local/bin"
APPIMAGE_TARGET="${INSTALL_DIR_APPIMAGE}/cursor.appimage"

if [[ -r "${HELPER_EXTENSIONS_MODULE}" ]]; then
  # shellcheck disable=SC1090
  source "${HELPER_EXTENSIONS_MODULE}"
fi
if [[ -r "${HELPER_SETTINGS_MODULE}" ]]; then
  # shellcheck disable=SC1090
  source "${HELPER_SETTINGS_MODULE}"
fi

detect_pkg_manager() {
  if command -v apt-get >/dev/null 2>&1; then
    echo "apt"
  elif command -v dnf >/dev/null 2>&1; then
    echo "dnf"
  elif command -v zypper >/dev/null 2>&1; then
    echo "zypper"
  else
    echo "unknown"
  fi
}

detect_cursor_arch() {
  local arch
  arch="$(uname -m)"

  case "${arch}" in
    x86_64|amd64)
      echo "x64"
      ;;
    aarch64|arm64)
      echo "arm64"
      ;;
    *)
      echo "unsupported"
      ;;
  esac
}

download_file() {
  local url="${1:?url required}"
  local output="${2:?output path required}"
  curl -fL "${url}" -o "${output}"
}

build_cursor_url() {
  local package_kind="${1:?package kind required}" # deb|rpm|appimage
  local arch="${2:?arch required}"                # x64|arm64
  local artifact=""

  case "${package_kind}" in
    deb) artifact="linux-${arch}-deb" ;;
    rpm) artifact="linux-${arch}-rpm" ;;
    appimage) artifact="linux-${arch}" ;;
    *)
      echo "Unsupported Cursor package kind: ${package_kind}" >&2
      return 1
      ;;
  esac

  printf '%s/%s/%s/cursor/%s\n' "${CURSOR_API_BASE}" "${CURSOR_CHANNEL}" "${artifact}" "${CURSOR_VERSION}"
}

install_cursor_deb() {
  local arch="${1:?arch required}"
  local tmp_pkg="/tmp/cursor-latest-${arch}.deb"
  local pkg_url
  pkg_url="$(build_cursor_url deb "${arch}")"

  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends curl ca-certificates
  download_file "${pkg_url}" "${tmp_pkg}"
  sudo apt-get install -y "${tmp_pkg}"
  rm -f "${tmp_pkg}"
}

install_cursor_rpm_dnf() {
  local arch="${1:?arch required}"
  local tmp_pkg="/tmp/cursor-latest-${arch}.rpm"
  local pkg_url
  pkg_url="$(build_cursor_url rpm "${arch}")"

  sudo dnf install -y curl ca-certificates
  download_file "${pkg_url}" "${tmp_pkg}"
  sudo dnf install -y "${tmp_pkg}"
  rm -f "${tmp_pkg}"
}

install_cursor_rpm_zypper() {
  local arch="${1:?arch required}"
  local tmp_pkg="/tmp/cursor-latest-${arch}.rpm"
  local pkg_url
  pkg_url="$(build_cursor_url rpm "${arch}")"

  sudo zypper -n install curl ca-certificates
  download_file "${pkg_url}" "${tmp_pkg}"
  sudo zypper -n install "${tmp_pkg}"
  rm -f "${tmp_pkg}"
}

install_cursor_appimage() {
  local arch="${1:?arch required}"
  local appimage_url
  appimage_url="$(build_cursor_url appimage "${arch}")"

  mkdir -p "${INSTALL_DIR_APPIMAGE}"
  download_file "${appimage_url}" "${APPIMAGE_TARGET}"
  chmod +x "${APPIMAGE_TARGET}"

  echo "Cursor AppImage installed at ${APPIMAGE_TARGET}"
  echo "Optional: create a desktop entry for launcher integration."
}

setup_cursor() {
  if command -v cursor >/dev/null 2>&1; then
    echo "Cursor is already installed"
  else
    local arch
    arch="$(detect_cursor_arch)"
    if [[ "${arch}" == "unsupported" ]]; then
      echo "Unsupported CPU architecture: $(uname -m)"
      return 1
    fi

    case "$(detect_pkg_manager)" in
      apt)
        install_cursor_deb "${arch}"
        ;;
      dnf)
        install_cursor_rpm_dnf "${arch}"
        ;;
      zypper)
        install_cursor_rpm_zypper "${arch}"
        ;;
      *)
        echo "No supported package manager detected. Falling back to AppImage."
        install_cursor_appimage "${arch}"
        ;;
    esac
  fi

  if declare -F setup_vscode_extensions >/dev/null 2>&1; then
    setup_vscode_extensions "cursor"
  fi
  if declare -F setup_ide_settings >/dev/null 2>&1; then
    setup_ide_settings "cursor"
  fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_cursor
fi
