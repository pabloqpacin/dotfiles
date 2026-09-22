#!/usr/bin/env bash

set -euo pipefail

TEST_USERNAME="${TEST_USERNAME:-testuser}"
TEST_USER_SHELL="${TEST_USER_SHELL:-/bin/bash}"
TEST_USER_COMMENT="${TEST_USER_COMMENT:-Debug test user}"
TEST_USER_GROUPS="${TEST_USER_GROUPS:-audio,video,plugdev,netdev}"
TEST_USER_ENABLE_SUDO="${TEST_USER_ENABLE_SUDO:-false}"
TEST_USER_PASSWORD="${TEST_USER_PASSWORD:-}"

require_root() {
  if [[ "${EUID}" -ne 0 ]]; then
    echo "Run as root: sudo $0"
    exit 1
  fi
}

user_exists() {
  id -u "${TEST_USERNAME}" >/dev/null 2>&1
}

ensure_shell_exists() {
  if [[ ! -x "${TEST_USER_SHELL}" ]]; then
    echo "Shell not found or not executable: ${TEST_USER_SHELL}"
    return 1
  fi
}

create_or_update_user() {
  if user_exists; then
    echo "User already exists: ${TEST_USERNAME}"
    usermod -s "${TEST_USER_SHELL}" "${TEST_USERNAME}"
    return 0
  fi

  useradd \
    --create-home \
    --user-group \
    --comment "${TEST_USER_COMMENT}" \
    --shell "${TEST_USER_SHELL}" \
    "${TEST_USERNAME}"

  echo "User created: ${TEST_USERNAME}"
}

add_user_to_existing_groups() {
  local groups_csv="${1}"
  local group_name=""

  IFS=',' read -r -a groups_array <<< "${groups_csv}"
  for group_name in "${groups_array[@]}"; do
    [[ -z "${group_name}" ]] && continue
    if getent group "${group_name}" >/dev/null 2>&1; then
      usermod -aG "${group_name}" "${TEST_USERNAME}"
    fi
  done
}

configure_sudo_access() {
  if [[ "${TEST_USER_ENABLE_SUDO}" != "true" ]]; then
    return 0
  fi

  if getent group sudo >/dev/null 2>&1; then
    usermod -aG sudo "${TEST_USERNAME}"
  elif getent group wheel >/dev/null 2>&1; then
    usermod -aG wheel "${TEST_USERNAME}"
  else
    echo "No sudo/wheel group found; skipping sudo group assignment"
  fi
}

set_user_password_if_provided() {
  if [[ -z "${TEST_USER_PASSWORD}" ]]; then
    # passwd -l "${TEST_USERNAME}" >/dev/null 2>&1 || true
    echo "No TEST_USER_PASSWORD provided. Please set password interactively for ${TEST_USERNAME}:"
    passwd "${TEST_USERNAME}"
    return 0
  fi

  echo "${TEST_USERNAME}:${TEST_USER_PASSWORD}" | chpasswd
}

setup_user_home_basics() {
  local home_dir
  home_dir="$(getent passwd "${TEST_USERNAME}" | cut -d: -f6)"

  if [[ -z "${home_dir}" || ! -d "${home_dir}" ]]; then
    echo "Home directory missing for ${TEST_USERNAME}"
    return 1
  fi

  install -d -m 700 -o "${TEST_USERNAME}" -g "${TEST_USERNAME}" "${home_dir}/.ssh"
  install -d -m 755 -o "${TEST_USERNAME}" -g "${TEST_USERNAME}" "${home_dir}/.config"
  install -d -m 755 -o "${TEST_USERNAME}" -g "${TEST_USERNAME}" "${home_dir}/.local/bin"
  chown -R "${TEST_USERNAME}:${TEST_USERNAME}" "${home_dir}"
}

print_summary() {
  local home_dir
  home_dir="$(getent passwd "${TEST_USERNAME}" | cut -d: -f6)"
  echo "=== test user summary ==="
  echo "username: ${TEST_USERNAME}"
  echo "home: ${home_dir}"
  echo "shell: $(getent passwd "${TEST_USERNAME}" | cut -d: -f7)"
  echo "groups: $(id -nG "${TEST_USERNAME}")"
}

setup_test_user() {
  require_root
  ensure_shell_exists
  create_or_update_user
  add_user_to_existing_groups "${TEST_USER_GROUPS}"
  configure_sudo_access
  set_user_password_if_provided
  setup_user_home_basics
  print_summary
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_test_user
fi
