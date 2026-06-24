#!/usr/bin/env bash

set -euo pipefail

PASSWORD_POLICY_ENABLE="${PASSWORD_POLICY_ENABLE:-true}"
PWQ_MINLEN="${PWQ_MINLEN:-16}"
PWQ_DCREDIT="${PWQ_DCREDIT:--1}"
PWQ_UCREDIT="${PWQ_UCREDIT:--1}"
PWQ_LCREDIT="${PWQ_LCREDIT:--1}"
PWQ_OCREDIT="${PWQ_OCREDIT:--1}"
PWQ_RETRY="${PWQ_RETRY:-3}"
PASS_MAX_DAYS="${PASS_MAX_DAYS:-365}"
PASS_MIN_DAYS="${PASS_MIN_DAYS:-1}"
PASS_WARN_AGE="${PASS_WARN_AGE:-14}"

SKEL_SETUP_ENABLE="${SKEL_SETUP_ENABLE:-false}"
SKEL_SOURCE_DIR="${SKEL_SOURCE_DIR:-}"

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

normalize_bool() {
  local value="${1:-false}"
  case "${value,,}" in
    true|1|yes|y|on) echo "true" ;;
    *) echo "false" ;;
  esac
}

install_pwquality_package() {
  if command -v pwscore >/dev/null 2>&1; then
    return 0
  fi

  case "$(detect_pkg_manager)" in
    apt)
      export DEBIAN_FRONTEND=noninteractive
      sudo apt-get update
      sudo apt-get install -y --no-install-recommends libpam-pwquality
      ;;
    dnf)
      sudo dnf install -y libpwquality
      ;;
    pacman)
      sudo pacman -S --noconfirm libpwquality
      ;;
    *)
      echo "Unsupported package manager for pwquality installation"
      return 1
      ;;
  esac
}

set_or_append_kv() {
  local file_path="${1:?file path required}"
  local key="${2:?key required}"
  local value="${3:?value required}"

  if sudo rg -q "^[[:space:]]*${key}[[:space:]]*=" "${file_path}"; then
    sudo sed -i "s|^[[:space:]]*${key}[[:space:]]*=.*|${key} = ${value}|" "${file_path}"
  else
    echo "${key} = ${value}" | sudo tee -a "${file_path}" >/dev/null
  fi
}

set_or_append_login_defs_value() {
  local key="${1:?key required}"
  local value="${2:?value required}"
  local file_path="/etc/login.defs"

  if sudo rg -q "^[[:space:]]*${key}[[:space:]]+" "${file_path}"; then
    sudo sed -i "s|^[[:space:]]*${key}[[:space:]].*|${key}   ${value}|" "${file_path}"
  else
    echo "${key}   ${value}" | sudo tee -a "${file_path}" >/dev/null
  fi
}

ensure_pam_pwquality_retry() {
  local file_path=""
  if [[ -f "/etc/pam.d/common-password" ]]; then
    file_path="/etc/pam.d/common-password"
  elif [[ -f "/etc/pam.d/system-auth" ]]; then
    file_path="/etc/pam.d/system-auth"
  else
    echo "No known PAM password policy file found. Skipping retry tuning."
    return 0
  fi

  if sudo rg -q "pam_pwquality.so" "${file_path}"; then
    sudo sed -E -i \
      "s|(pam_pwquality\\.so[^#\\n]*)(\\sretry=[0-9]+)?|\\1 retry=${PWQ_RETRY}|" \
      "${file_path}" || true
  fi
}

configure_password_policy() {
  if [[ "$(normalize_bool "${PASSWORD_POLICY_ENABLE}")" != "true" ]]; then
    echo "Password policy disabled (PASSWORD_POLICY_ENABLE=false)"
    return 0
  fi

  install_pwquality_package

  local pwquality_file="/etc/security/pwquality.conf"
  if [[ ! -f "${pwquality_file}" ]]; then
    sudo touch "${pwquality_file}"
  fi

  set_or_append_kv "${pwquality_file}" "minlen" "${PWQ_MINLEN}"
  set_or_append_kv "${pwquality_file}" "dcredit" "${PWQ_DCREDIT}"
  set_or_append_kv "${pwquality_file}" "ucredit" "${PWQ_UCREDIT}"
  set_or_append_kv "${pwquality_file}" "lcredit" "${PWQ_LCREDIT}"
  set_or_append_kv "${pwquality_file}" "ocredit" "${PWQ_OCREDIT}"

  ensure_pam_pwquality_retry
  set_or_append_login_defs_value "PASS_MAX_DAYS" "${PASS_MAX_DAYS}"
  set_or_append_login_defs_value "PASS_MIN_DAYS" "${PASS_MIN_DAYS}"
  set_or_append_login_defs_value "PASS_WARN_AGE" "${PASS_WARN_AGE}"
}

setup_skel_if_requested() {
  if [[ "$(normalize_bool "${SKEL_SETUP_ENABLE}")" != "true" ]]; then
    return 0
  fi

  sudo mkdir -p /etc/skel/.config

  if [[ -n "${SKEL_SOURCE_DIR}" && -d "${SKEL_SOURCE_DIR}" ]]; then
    sudo cp -a "${SKEL_SOURCE_DIR}/." /etc/skel/
    echo "Copied custom skeleton from ${SKEL_SOURCE_DIR}"
  else
    echo "SKEL_SETUP_ENABLE=true but SKEL_SOURCE_DIR is missing/invalid. Keeping baseline /etc/skel."
  fi
}

setup_user_policies() {
  configure_password_policy
  setup_skel_if_requested
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_user_policies
fi
