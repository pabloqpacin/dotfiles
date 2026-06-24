#!/usr/bin/env bash

set -euo pipefail

TIMESHIFT_CONFIG_FILE="/etc/timeshift/timeshift.json"
TIMESHIFT_BACKUP_LABEL="${TIMESHIFT_BACKUP_LABEL:-snapshots}"
TIMESHIFT_SNAPSHOT_MOUNTPOINT="${TIMESHIFT_SNAPSHOT_MOUNTPOINT:-/mnt/snapshots}"
TIMESHIFT_CREATE_INITIAL_SNAPSHOT="${TIMESHIFT_CREATE_INITIAL_SNAPSHOT:-true}"
TIMESHIFT_INITIAL_COMMENT="${TIMESHIFT_INITIAL_COMMENT:-Initial snapshot (post-bootstrap)}"

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

install_timeshift_package() {
  if command -v timeshift >/dev/null 2>&1; then
    echo "Timeshift is already installed"
    return 0
  fi

  case "$(detect_pkg_manager)" in
    apt)
      export DEBIAN_FRONTEND=noninteractive
      sudo apt-get update
      sudo apt-get install -y --no-install-recommends timeshift
      ;;
    dnf)
      sudo dnf install -y timeshift
      ;;
    pacman)
      sudo pacman -S --noconfirm timeshift
      ;;
    *)
      echo "Unsupported package manager for Timeshift installation"
      return 1
      ;;
  esac
}

detect_backup_device_uuid() {
  local detected_uuid=""

  if [[ -n "${TIMESHIFT_BACKUP_DEVICE_UUID:-}" ]]; then
    if sudo blkid -U "${TIMESHIFT_BACKUP_DEVICE_UUID}" >/dev/null 2>&1; then
      printf '%s\n' "${TIMESHIFT_BACKUP_DEVICE_UUID}"
      return 0
    fi
    echo "Configured TIMESHIFT_BACKUP_DEVICE_UUID does not exist: ${TIMESHIFT_BACKUP_DEVICE_UUID}"
  fi

  if sudo blkid -L "${TIMESHIFT_BACKUP_LABEL}" >/dev/null 2>&1; then
    detected_uuid="$(sudo blkid -s UUID -o value "$(sudo blkid -L "${TIMESHIFT_BACKUP_LABEL}")")"
    if [[ -n "${detected_uuid}" ]]; then
      printf '%s\n' "${detected_uuid}"
      return 0
    fi
  fi

  local device_path=""
  if command -v findmnt >/dev/null 2>&1; then
    device_path="$(findmnt -n -o SOURCE "${TIMESHIFT_SNAPSHOT_MOUNTPOINT}" 2>/dev/null || true)"
  fi
  if [[ -n "${device_path}" ]]; then
    detected_uuid="$(sudo blkid -s UUID -o value "${device_path}" 2>/dev/null || true)"
    if [[ -n "${detected_uuid}" ]]; then
      printf '%s\n' "${detected_uuid}"
      return 0
    fi
  fi

  # Last-resort fallback: keep working if current config UUID is still valid.
  local config_uuid=""
  if [[ -r "${TIMESHIFT_CONFIG_FILE}" ]]; then
    config_uuid="$(sudo grep -oE '"backup_device_uuid"[[:space:]]*:[[:space:]]*"[^"]+"' "${TIMESHIFT_CONFIG_FILE}" \
      | grep -oE '[0-9a-fA-F-]{8}-[0-9a-fA-F-]{4}-[0-9a-fA-F-]{4}-[0-9a-fA-F-]{4}-[0-9a-fA-F-]{12}' \
      | head -n 1 || true)"
  fi
  if [[ -n "${config_uuid}" ]] && sudo blkid -U "${config_uuid}" >/dev/null 2>&1; then
    printf '%s\n' "${config_uuid}"
    return 0
  fi

  echo "Could not detect Timeshift backup device UUID."
  echo "Set TIMESHIFT_BACKUP_DEVICE_UUID or create a partition label '${TIMESHIFT_BACKUP_LABEL}'."
  return 1
}

normalize_bool() {
  local value="${1:-false}"
  case "${value,,}" in
    true|1|yes|y|on) echo "true" ;;
    *) echo "false" ;;
  esac
}

write_timeshift_config() {
  local backup_uuid="${1:?backup uuid required}"
  local snapshot_daily="${TIMESHIFT_DAILY_ENABLED:-true}"
  local snapshot_weekly="${TIMESHIFT_WEEKLY_ENABLED:-true}"
  local snapshot_monthly="${TIMESHIFT_MONTHLY_ENABLED:-true}"
  local snapshot_hourly="${TIMESHIFT_HOURLY_ENABLED:-false}"
  local snapshot_boot="${TIMESHIFT_BOOT_ENABLED:-false}"
  local exclude_user_home="${TIMESHIFT_EXCLUDE_USER_HOME:-true}"
  local exclude_root_home="${TIMESHIFT_EXCLUDE_ROOT_HOME:-true}"
  local target_user="${SUDO_USER:-${USER:-}}"
  local -a exclude_entries
  exclude_entries=(
    "    \"/run/timeshift/**\""
    "    \"${TIMESHIFT_SNAPSHOT_MOUNTPOINT}/**\""
  )

  if [[ "$(normalize_bool "${exclude_user_home}")" == "true" && -n "${target_user}" ]]; then
    exclude_entries+=("    \"/home/${target_user}/**\"")
  fi
  if [[ "$(normalize_bool "${exclude_root_home}")" == "true" ]]; then
    exclude_entries+=("    \"/root/**\"")
  fi

  local exclude_block=""
  local i
  for i in "${!exclude_entries[@]}"; do
    if [[ "${i}" -gt 0 ]]; then
      exclude_block+=$',\n'
    fi
    exclude_block+="${exclude_entries[$i]}"
  done

  sudo mkdir -p "$(dirname "${TIMESHIFT_CONFIG_FILE}")"
  sudo tee "${TIMESHIFT_CONFIG_FILE}" >/dev/null <<EOF
{
  "backup_device_uuid" : "${backup_uuid}",
  "parent_device_uuid" : "",
  "do_first_run" : "false",
  "btrfs_mode" : "false",
  "include_btrfs_home_for_backup" : "false",
  "include_btrfs_home_for_restore" : "false",
  "stop_cron_emails" : "true",
  "schedule_monthly" : "$(normalize_bool "${snapshot_monthly}")",
  "schedule_weekly" : "$(normalize_bool "${snapshot_weekly}")",
  "schedule_daily" : "$(normalize_bool "${snapshot_daily}")",
  "schedule_hourly" : "$(normalize_bool "${snapshot_hourly}")",
  "schedule_boot" : "$(normalize_bool "${snapshot_boot}")",
  "count_monthly" : "${TIMESHIFT_COUNT_MONTHLY:-2}",
  "count_weekly" : "${TIMESHIFT_COUNT_WEEKLY:-3}",
  "count_daily" : "${TIMESHIFT_COUNT_DAILY:-5}",
  "count_hourly" : "${TIMESHIFT_COUNT_HOURLY:-6}",
  "count_boot" : "${TIMESHIFT_COUNT_BOOT:-5}",
  "snapshot_size" : "0",
  "snapshot_count" : "0",
  "date_format" : "%Y-%m-%d %H:%M:%S",
  "exclude" : [
${exclude_block}
  ],
  "exclude-apps" : []
}
EOF
}

ensure_snapshot_mountpoint_not_active() {
  if ! command -v findmnt >/dev/null 2>&1; then
    return 0
  fi

  if findmnt -n "${TIMESHIFT_SNAPSHOT_MOUNTPOINT}" >/dev/null 2>&1; then
    echo "Unmounting ${TIMESHIFT_SNAPSHOT_MOUNTPOINT} to avoid recursive rsync copies"
    sudo umount "${TIMESHIFT_SNAPSHOT_MOUNTPOINT}"
  fi
}

has_any_snapshot() {
  sudo timeshift --list 2>/dev/null | grep -qE '[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{2}-[0-9]{2}-[0-9]{2}'
}

create_initial_snapshot_if_needed() {
  if [[ "$(normalize_bool "${TIMESHIFT_CREATE_INITIAL_SNAPSHOT}")" != "true" ]]; then
    echo "Skipping initial Timeshift snapshot (TIMESHIFT_CREATE_INITIAL_SNAPSHOT=false)"
    return 0
  fi

  if has_any_snapshot; then
    echo "Timeshift already has at least one snapshot"
    return 0
  fi

  sudo timeshift --create --comments "${TIMESHIFT_INITIAL_COMMENT}" --tags O --scripted
}

setup_timeshift() {
  install_timeshift_package
  ensure_snapshot_mountpoint_not_active

  local backup_uuid
  backup_uuid="$(detect_backup_device_uuid)"
  write_timeshift_config "${backup_uuid}"

  # Schedules snapshot jobs based on /etc/timeshift/timeshift.json values.
  sudo timeshift --check --scripted
  create_initial_snapshot_if_needed
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_timeshift
fi

# -----------------------------------------------------------------------------
# Ops notes (commented on purpose)
# -----------------------------------------------------------------------------
# Existing snapshots:
#   sudo timeshift --list
#   sudo timeshift --list-devices
#
# Scheduled policy (what Timeshift is configured to create/retain):
#   sudo grep -nE '"schedule_(hourly|daily|weekly|monthly|boot)"|"count_(hourly|daily|weekly|monthly|boot)"' /etc/timeshift/timeshift.json
#
# Trigger mechanism (cron/systemd):
#   sudo grep -n "timeshift" /etc/cron.d /etc/cron.daily /etc/anacrontab
#   systemctl list-timers --all | grep -i timeshift
#
# Manual check cycle (safe way to validate daily creation):
#   sudo timeshift --check --scripted
#   sudo timeshift --list
#
# Useful troubleshooting:
#   # Timeshift does not usually expose an exact "next run at" timestamp.
#   # Daily snapshots become eligible roughly 24h after the previous daily point.
#   sudo journalctl -u cron --since "today" | grep -i timeshift
#   sudo journalctl --since "today" | grep -i timeshift
#   df -h
