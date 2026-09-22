#!/usr/bin/env bash

# Usage:
#   bash MIGRACION/popos-backup.sh                 # full backup to DEST
#   bash MIGRACION/popos-backup.sh repos           # ~/repos + ~/dotfiles → repos-dirty
#   bash MIGRACION/popos-backup.sh reference       # only sysadmin docs → reference/
#   bash MIGRACION/popos-backup.sh repos reference # both of the above
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

# Parse optional phase args (default: full run)
RUN_FULL=1
RUN_REPOS=0
RUN_REFERENCE=0
RUN_BULK=0
RUN_CRITICAL=0
RUN_PACK=0
if [[ $# -gt 0 ]]; then
  RUN_FULL=0
  for arg in "$@"; do
    case "$arg" in
      repos) RUN_REPOS=1 ;;
      reference) RUN_REFERENCE=1 ;;
      bulk) RUN_BULK=1 ;;
      critical) RUN_CRITICAL=1 ;;
      pack) RUN_PACK=1 ;;
      *)
        echo "Unknown arg: $arg (use: repos|reference|bulk|critical|pack|decrypt)" >&2
        exit 1
        ;;
    esac
  done
fi
if (( RUN_FULL )); then
  RUN_REPOS=1 RUN_REFERENCE=1 RUN_BULK=1 RUN_CRITICAL=1 RUN_PACK=1
fi

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

# Sysadmin inventory → reference/ (NOT userspace / bulk-data)
collect_sysadmin_reference() {
  local ref="$DEST/reference"
  mkdir -p "$ref"/{apt,hardware,storage,services,opt,path}

  echo "Collecting sysadmin reference → $ref"

  # --- OS / kernel ---
  {
    date -Is
    echo
    cat /etc/os-release
    echo
    uname -a
    echo
    hostnamectl 2>/dev/null || true
  } > "$ref/os-release.txt"

  # --- apt / packages ---
  dpkg --get-selections > "$ref/apt/installed-packages.txt"
  apt-mark showmanual > "$ref/apt/manually-installed.txt"
  dpkg -l > "$ref/apt/dpkg-l.txt" 2>/dev/null || true
  cp -a /etc/apt/sources.list "$ref/apt/" 2>/dev/null || true
  cp -a /etc/apt/sources.list.d "$ref/apt/" 2>/dev/null || true
  apt-cache policy 2>/dev/null | head -500 > "$ref/apt/apt-cache-policy-sample.txt" || true
  flatpak list --app --columns=application,version,origin > "$ref/apt/flatpak-apps.txt" 2>/dev/null || true
  snap list > "$ref/apt/snap-list.txt" 2>/dev/null || true
  pipx list > "$ref/apt/pipx-list.txt" 2>/dev/null || true
  npm list -g --depth=0 > "$ref/apt/npm-global.txt" 2>/dev/null || true
  cargo install --list > "$ref/apt/cargo-install-list.txt" 2>/dev/null || true

  # --- NVIDIA / GPU / hardware ---
  {
    echo "=== lspci VGA/3D/NVIDIA ==="
    lspci -nn | grep -Ei 'vga|3d|nvidia|display' || true
    echo
    echo "=== nvidia packages (dpkg) ==="
    dpkg -l 'nvidia*' 2>/dev/null | awk '/^ii/' || true
    echo
    echo "=== nvidia-smi ==="
    nvidia-smi 2>/dev/null || echo "(nvidia-smi failed)"
    echo
    echo "=== modinfo nvidia (summary) ==="
    modinfo nvidia 2>/dev/null | head -40 || true
  } > "$ref/hardware/nvidia.txt"
  lscpu > "$ref/hardware/lscpu.txt" 2>/dev/null || true
  free -h > "$ref/hardware/memory.txt" 2>/dev/null || true
  lspci -nnk > "$ref/hardware/lspci-nnk.txt" 2>/dev/null || true
  lsmod > "$ref/hardware/lsmod.txt" 2>/dev/null || true

  # --- storage / partitions / fstab ---
  cp -a /etc/fstab "$ref/storage/fstab"
  lsblk -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT,MODEL > "$ref/storage/lsblk.txt" 2>/dev/null || true
  lsblk -f > "$ref/storage/lsblk-f.txt" 2>/dev/null || true
  blkid > "$ref/storage/blkid.txt" 2>/dev/null || true
  df -hT > "$ref/storage/df-hT.txt" 2>/dev/null || true
  findmnt -D > "$ref/storage/findmnt.txt" 2>/dev/null || true
  cp -a /etc/crypttab "$ref/storage/crypttab" 2>/dev/null || true

  # --- /opt and user-ish system binaries ---
  {
    echo "=== /opt (du) ==="
    du -sh /opt/* 2>/dev/null | sort -hr || true
    echo
    echo "=== /opt listing ==="
    ls -la /opt 2>/dev/null || true
  } > "$ref/opt/opt-inventory.txt"
  {
    echo "=== /usr/local/bin ==="
    ls -la /usr/local/bin 2>/dev/null || true
    echo
    echo "=== ~/.local/bin ==="
    ls -la "$HOME/.local/bin" 2>/dev/null || true
  } > "$ref/path/local-bin.txt"
  which -a kubectl helm aws terraform vault docker podman flatpak 2>/dev/null > "$ref/path/which-devtools.txt" || true

  # --- services / boot ---
  systemctl list-unit-files --state=enabled --no-pager > "$ref/services/enabled-units.txt" 2>/dev/null || true
  systemctl list-units --type=service --state=running --no-pager > "$ref/services/running-services.txt" 2>/dev/null || true
  docker ps -a > "$ref/services/docker-ps-a.txt" 2>/dev/null || true
  groups > "$ref/services/user-groups.txt" 2>/dev/null || true

  # --- desktop crumbs (still "how was the box set up", not bulk data) ---
  dconf dump / > "$ref/dconf-settings.backup" 2>/dev/null || true
  gnome-extensions list > "$ref/gnome-extensions-list.txt" 2>/dev/null || true
  gsettings list-recursively org.gnome.desktop.wm.keybindings > "$ref/wm-keybindings.txt" 2>/dev/null || true
  gsettings list-recursively org.gnome.settings-daemon.plugins.media-keys > "$ref/media-keybindings.txt" 2>/dev/null || true

  # Keep old flat paths for anything that already existed
  cp -f "$ref/apt/installed-packages.txt" "$ref/installed-packages.txt"
  cp -f "$ref/apt/manually-installed.txt" "$ref/manually-installed.txt"
  cp -f "$ref/apt/flatpak-apps.txt" "$ref/flatpak-apps.txt" 2>/dev/null || true

  {
    echo "# Sysadmin reference dump from Pop!_OS (host: $(hostname))"
    echo "# Generated: $(date -Is)"
    echo "# Layout:"
    echo "#   apt/        packages, sources, flatpak/snap/pipx/npm/cargo"
    echo "#   hardware/   nvidia, cpu, lspci, modules"
    echo "#   storage/    fstab, lsblk, blkid, df, crypttab"
    echo "#   opt/        /opt inventory"
    echo "#   path/       /usr/local/bin, ~/.local/bin, which(devtools)"
    echo "#   services/   systemd enabled/running, docker, groups"
    echo "#   + dconf / gnome / keybindings snapshots"
  } > "$ref/README.txt"

  echo "Reference collection done."
}

### ---- 1. CRITICAL: keys, passwords, VPN configs ----
if (( RUN_CRITICAL )); then
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
fi


### ---- 2. BULK DATA: personal/work folders, media ----
if (( RUN_BULK )); then
  rsync_to_ntfs \
    --exclude='.cache' --exclude='node_modules' --exclude='.local/share/Trash' \
    PERSONAL Documents Setesur old-Setesur ASIR PROYECTO ROPROYECTO WORK workspace \
    0-CUADERNO China Pictures Videos Music \
    "$DEST/bulk-data/"

  rsync_to_ntfs .thunderbird .mozilla "$DEST/bulk-data/"
fi


### ---- 3. REPOS + dotfiles: tracked + untracked (exclude build artifacts) ----
if (( RUN_REPOS )); then
  rsync_to_ntfs \
    --exclude='node_modules' --exclude='.cache' \
    --exclude='**/target' --exclude='**/venv' --exclude='**/.venv' \
    --exclude='**/dist' --exclude='**/build' \
    repos dotfiles "$DEST/repos-dirty/"
fi


### ---- 4. NTFS-UNSAFE NAMES: tar what rsync could not create on the drive ----
if (( RUN_PACK )); then
  pack_ntfs_unsafe
fi


### ---- 5. REFERENCE: sysadmin inventory (NOT bulk-data) ----
if (( RUN_REFERENCE )); then
  collect_sysadmin_reference
fi

echo "Done. Verify $DEST before wiping anything."
