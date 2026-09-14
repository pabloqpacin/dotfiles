#!/usr/bin/env bash

# Usage:
#   bash MIGRACION/popos-backup.sh              # full backup to DEST
#   CRITICAL_BUNDLE_GPG=/path/to/critical-bundle.tar.gz.gpg \
#     [CRITICAL_RESTORE_DIR=/tmp/critical-restore] bash MIGRACION/popos-backup.sh decrypt

set -euo pipefail

decrypt_critical_bundle() {
  local gpg_file="${CRITICAL_BUNDLE_GPG:?Set CRITICAL_BUNDLE_GPG to the .gpg path}"
  local restore_dir="${CRITICAL_RESTORE_DIR:-/tmp/critical-restore}"
  local bundle="/tmp/critical-bundle.tar.gz"

  [[ -s "$gpg_file" ]] || { echo "ERROR: missing or empty: $gpg_file" >&2; return 1; }

  echo "Decrypting: $gpg_file"
  gpg -o "$bundle" -d "$gpg_file"
  [[ -s "$bundle" ]] || { echo "ERROR: decrypt produced empty archive" >&2; return 1; }

  echo "Contents:"
  tar tzf "$bundle"

  mkdir -p "$restore_dir"
  tar xzf "$bundle" -C "$restore_dir"
  echo "Extracted to: $restore_dir"
  ls -la "$restore_dir"

  shred -u "$bundle"
  echo "Wiped plaintext archive. Remove restore dir when done: rm -rf $restore_dir"
}

if [[ "${1:-}" == decrypt ]]; then
  decrypt_critical_bundle
  exit 0
fi

DEST="/media/pabloqpacin/Seagate Portable Drive/PopOS-GL76/migration"
mkdir -p "$DEST"/{critical,bulk-data,repos-dirty,reference,packed-ntfs-unsafe}

cd ~

# NTFS (Seagate): -a tries perms/owner and blows up; 23/24 = partial/vanished, OK to continue
rsync_to_ntfs() {
  local rc=0
  # -rltD: recurse, links, times — no -pgo (ntfs3 + windows_names rejects many attrs)
  rsync -rltDh --info=progress2 "$@" || rc=$?
  case "$rc" in
    0) return 0 ;;
    23|24)
      echo "WARN: rsync exited $rc (some files/attrs skipped; continuing)" >&2
      return 0
      ;;
    *)
      echo "ERROR: rsync failed with exit $rc" >&2
      return "$rc"
      ;;
  esac
}

# Pack paths whose names NTFS windows_names rejects (*, ?, :, trailing ., etc.)
pack_ntfs_unsafe() {
  local pack_dir="$DEST/packed-ntfs-unsafe"
  local list
  list="$(mktemp)"
  mkdir -p "$pack_dir"

  # Scan the same trees we rsync (relative to ~)
  find \
    PERSONAL Documents Setesur old-Setesur ASIR PROYECTO ROPROYECTO WORK workspace \
    0-CUADERNO China Pictures Videos Music dotfiles \
    .thunderbird .mozilla repos \
    \( \
      -name '*[\<\>:\"\\|?*]*' -o \
      -name '*.' -o \
      -name '* ' \
    \) -print 2>/dev/null \
    | sed 's|^\./||' \
    | sort -u > "$list" || true

  if [[ ! -s "$list" ]]; then
    echo "No NTFS-unsafe names found to pack."
    rm -f "$list"
    return 0
  fi

  echo "Packing $(wc -l < "$list") NTFS-unsafe path(s) into $pack_dir/odd-names.tar.gz"
  # --ignore-failed-read: skip root-owned unreadable files without aborting
  tar czf "$pack_dir/odd-names.tar.gz" --ignore-failed-read -T "$list" 2>/dev/null || true
  [[ -s "$pack_dir/odd-names.tar.gz" ]] || echo "WARN: odd-names.tar.gz empty" >&2

  # Dedicated archive for Setesur/CORP. (large + trailing-dot dirname)
  if [[ -d Setesur/CORP. ]]; then
    echo "Packing Setesur/CORP. → Setesur-CORP.tar.gz"
    tar czf "$pack_dir/Setesur-CORP.tar.gz" -C Setesur "CORP."
  fi

  {
    echo "# Paths rejected by NTFS windows_names — extract on ext4/btrfs/xfs:"
    echo "#   tar xzf Setesur-CORP.tar.gz -C ~/Setesur"
    echo "#   tar xzf odd-names.tar.gz -C ~"
    echo
    echo "## Contents of odd-names.tar.gz"
    tar tzf "$pack_dir/odd-names.tar.gz" 2>/dev/null || true
  } > "$pack_dir/README.txt"

  rm -f "$list"
}

### ---- 1. CRITICAL: keys, passwords, VPN configs ----
CRITICAL_OUT="$DEST/critical/critical-bundle.tar.gz.gpg"
if [[ -s "$CRITICAL_OUT" ]]; then
  echo "Skipping critical bundle (already exists): $CRITICAL_OUT"
else
  CRITICAL_REQUIRED=(.ssh .gnupg .KPXC)
  CRITICAL_OPTIONAL=(
    wg0.conf academy-regular.ovpn
    .kube/config
    .docker/config.json .docker/config.json.bak .docker/config.json.backup
    .aws
    dotfiles/.aws dotfiles/.aws.bak
    aws.todo TODO.todo retro.sh teleport.sh listado.csv
    ual_importacion.txt definitiva.txt acronis.txt
  )

  critical_paths=()
  for path in "${CRITICAL_REQUIRED[@]}"; do
    if [[ ! -e "$path" ]]; then
      echo "ERROR: required critical path missing: ~/$path" >&2
      exit 1
    fi
    critical_paths+=("$path")
  done

  for path in "${CRITICAL_OPTIONAL[@]}"; do
    if [[ -e "$path" ]]; then
      critical_paths+=("$path")
    else
      echo "WARN: skipping missing optional path: ~/$path" >&2
    fi
  done

  BUNDLE="/tmp/critical-bundle.tar.gz"
  tar czf "$BUNDLE" "${critical_paths[@]}"
  [[ -s "$BUNDLE" ]] || { echo "ERROR: critical bundle empty or missing" >&2; exit 1; }

  # Encrypt with a passphrase (you'll be asked to set one)
  gpg -c --cipher-algo AES256 -o "$CRITICAL_OUT" "$BUNDLE"
  shred -u "$BUNDLE"
  chmod 600 "$CRITICAL_OUT"
fi


### ---- 2. BULK DATA: personal/work folders, media, dotfiles ----
rsync_to_ntfs \
  --exclude='.cache' --exclude='node_modules' --exclude='.local/share/Trash' \
  PERSONAL Documents Setesur old-Setesur ASIR PROYECTO ROPROYECTO WORK workspace \
  0-CUADERNO China Pictures Videos Music \
  dotfiles \
  "$DEST/bulk-data/"

rsync_to_ntfs .thunderbird .mozilla "$DEST/bulk-data/"


### ---- 3. REPOS: tracked + untracked (exclude build artifacts) ----
rsync_to_ntfs \
  --exclude='node_modules' --exclude='.cache' \
  --exclude='**/target' --exclude='**/venv' --exclude='**/.venv' \
  --exclude='**/dist' --exclude='**/build' \
  repos "$DEST/repos-dirty/"


### ---- 4. NTFS-UNSAFE NAMES: tar what rsync could not create on the drive ----
pack_ntfs_unsafe


### ---- 5. REFERENCE ONLY: package lists, dconf, keybindings ----
dpkg --get-selections > "$DEST/reference/installed-packages.txt"
apt-mark showmanual > "$DEST/reference/manually-installed.txt"
flatpak list --app --columns=application > "$DEST/reference/flatpak-apps.txt" 2>/dev/null || true
dconf dump / > "$DEST/reference/dconf-settings.backup"
gnome-extensions list > "$DEST/reference/gnome-extensions-list.txt" 2>/dev/null || true
gsettings list-recursively org.gnome.desktop.wm.keybindings > "$DEST/reference/wm-keybindings.txt" 2>/dev/null || true
gsettings list-recursively org.gnome.settings-daemon.plugins.media-keys > "$DEST/reference/media-keybindings.txt" 2>/dev/null || true

echo "Done. Verify $DEST before wiping anything."
echo "Note: root-owned skips (old Firefox cert DBs, milvus etcd volumes) need:"
echo "  sudo tar czf \"$DEST/packed-ntfs-unsafe/root-owned.tar.gz\" \\"
echo "    .mozilla/firefox/suof2sv3.default/{cert9.db,key4.db,pkcs11.txt} \\"
echo "    repos/Setenova/INT-Infra_DBs/int-milvus/volumes/etcd/member"
