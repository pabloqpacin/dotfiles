#!/usr/bin/env bash

set -euo pipefail

USER_CREATION_ENABLE="${USER_CREATION_ENABLE:-false}"
DEFAULT_NEW_USER_SHELL="${DEFAULT_NEW_USER_SHELL:-/usr/bin/zsh}"
SUDO_GROUP_NAME="${SUDO_GROUP_NAME:-sudo}"
EXTRA_GROUP_FOR_STANDARD_USERS="${EXTRA_GROUP_FOR_STANDARD_USERS:-}"
SUDO_USERS_CSV="${SUDO_USERS_CSV:-}"
STANDARD_USERS_CSV="${STANDARD_USERS_CSV:-}"
FORCE_PASSWORD_CHANGE_ON_FIRST_LOGIN="${FORCE_PASSWORD_CHANGE_ON_FIRST_LOGIN:-true}"

normalize_bool() {
  local value="${1:-false}"
  case "${value,,}" in
    true|1|yes|y|on) echo "true" ;;
    *) echo "false" ;;
  esac
}

csv_to_array() {
  local raw_csv="${1:-}"
  local -n out_ref="${2:?array name required}"
  local item=""

  out_ref=()
  IFS=',' read -r -a out_ref <<< "${raw_csv}"
  for item in "${!out_ref[@]}"; do
    out_ref["${item}"]="$(echo "${out_ref[$item]}" | xargs)"
  done
}

create_user_if_missing() {
  local username="${1:?username required}"
  local shell_path="${2:?shell path required}"
  local groups_csv="${3:-}"

  if [[ -z "${username}" ]]; then
    return 0
  fi

  if id -u "${username}" >/dev/null 2>&1; then
    echo "User '${username}' already exists, skipping."
    return 0
  fi

  local -a useradd_args
  useradd_args=(-m -s "${shell_path}" -U)

  if [[ -n "${groups_csv}" ]]; then
    useradd_args+=(-G "${groups_csv}")
  fi

  sudo useradd "${useradd_args[@]}" "${username}"
  echo "Set initial password for '${username}':"
  sudo passwd "${username}"

  if [[ "$(normalize_bool "${FORCE_PASSWORD_CHANGE_ON_FIRST_LOGIN}")" == "true" ]]; then
    sudo chage -d 0 "${username}"
  fi

  sudo chage -l "${username}" || true
}

setup_user_creation() {
  if [[ "$(normalize_bool "${USER_CREATION_ENABLE}")" != "true" ]]; then
    return 0
  fi

  local -a sudo_users=()
  local -a standard_users=()
  csv_to_array "${SUDO_USERS_CSV}" sudo_users
  csv_to_array "${STANDARD_USERS_CSV}" standard_users

  local username=""
  for username in "${sudo_users[@]}"; do
    create_user_if_missing "${username}" "${DEFAULT_NEW_USER_SHELL}" "${SUDO_GROUP_NAME}"
  done

  for username in "${standard_users[@]}"; do
    create_user_if_missing "${username}" "${DEFAULT_NEW_USER_SHELL}" "${EXTRA_GROUP_FOR_STANDARD_USERS}"
  done
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_user_creation
fi
