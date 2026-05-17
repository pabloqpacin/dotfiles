#!/usr/bin/env bash

set -euo pipefail

# Optional feature flags (override with env vars before running).
ENABLE_FLATPAK_PLUGIN="${ENABLE_FLATPAK_PLUGIN:-yes}"
HIDE_TOP_BAR_UUID="hidetopbar@mathieu.bidon.ca"
TRANSPARENT_WINDOW_UUID="transparent-window@pbxqdown.github.com"
TRANSPARENT_WINDOW_OPACITY="${TRANSPARENT_WINDOW_OPACITY:-95}"

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

install_gnome_packages() {
  case "$(detect_pkg_manager)" in
    apt)
      export DEBIAN_FRONTEND=noninteractive
      sudo apt-get update
      sudo apt-get install -y --no-install-recommends \
        gnome-tweaks gnome-shell-extensions gnome-shell-extension-manager dconf-cli \
        gnome-shell-extension-autohidetopbar
      if [[ "${ENABLE_FLATPAK_PLUGIN}" == "yes" ]]; then
        sudo apt-get install -y --no-install-recommends gnome-software-plugin-flatpak
      fi
      ;;
    dnf)
      sudo dnf install -y gnome-tweaks gnome-extensions-app dconf
      ;;
    pacman)
      sudo pacman -S --noconfirm gnome-tweaks gnome-shell-extensions dconf
      ;;
    *)
      echo "Unsupported package manager for GNOME tweaks bootstrap"
      return 1
      ;;
  esac
}

is_gnome_session() {
  [[ "${XDG_CURRENT_DESKTOP:-}" == *GNOME* ]] || [[ "${DESKTOP_SESSION:-}" == *gnome* ]]
}

enable_hide_top_bar_extension() {
  if ! is_gnome_session; then
    return 0
  fi
  if ! command -v gnome-extensions >/dev/null 2>&1; then
    return 0
  fi

  if ! gnome-extensions enable "${HIDE_TOP_BAR_UUID}" >/dev/null 2>&1; then
    local desktop_dir="${HOME}/Desktop"
    local reminder_file="${desktop_dir}/hidetopbar-reminder.txt"
    if [[ -d "${desktop_dir}" ]]; then
      cat > "${reminder_file}" <<EOF
Could not enable ${HIDE_TOP_BAR_UUID} in current session.

After logging out/in, run:
  gnome-extensions enable ${HIDE_TOP_BAR_UUID}
EOF
    fi
    echo "Could not enable ${HIDE_TOP_BAR_UUID} in current session."
    echo "After logging out/in, run:"
    echo "  gnome-extensions enable ${HIDE_TOP_BAR_UUID}"
  fi
}

install_transparent_window_extension() {
  if ! is_gnome_session; then
    return 0
  fi
  if ! command -v gnome-extensions >/dev/null 2>&1; then
    return 0
  fi
  if gnome-extensions info "${TRANSPARENT_WINDOW_UUID}" >/dev/null 2>&1; then
    return 0
  fi
  if ! command -v gdbus >/dev/null 2>&1; then
    echo "gdbus is required to install ${TRANSPARENT_WINDOW_UUID}" >&2
    return 1
  fi

  # This path is non-interactive in the script itself. If GNOME policy prompts
  # the user for trust/consent, that decision is enforced by the shell.
  if ! gdbus call --session \
    --dest org.gnome.Shell.Extensions \
    --object-path /org/gnome/Shell/Extensions \
    --method org.gnome.Shell.Extensions.InstallRemoteExtension \
    "${TRANSPARENT_WINDOW_UUID}" >/dev/null 2>&1; then
    echo "Could not install ${TRANSPARENT_WINDOW_UUID} via GNOME Shell D-Bus." >&2
    return 1
  fi
}

enable_transparent_window_extension() {
  if ! is_gnome_session; then
    return 0
  fi
  if ! command -v gnome-extensions >/dev/null 2>&1; then
    return 0
  fi

  if ! gnome-extensions enable "${TRANSPARENT_WINDOW_UUID}" >/dev/null 2>&1; then
    echo "Could not enable ${TRANSPARENT_WINDOW_UUID} in current session."
    echo "After logging out/in, run:"
    echo "  gnome-extensions enable ${TRANSPARENT_WINDOW_UUID}"
  fi
}

configure_transparent_window_opacity() {
  if ! is_gnome_session; then
    return 0
  fi
  if ! command -v gsettings >/dev/null 2>&1; then
    return 0
  fi

  # Extension settings schema/key can differ by version, so apply best-effort.
  gsettings set org.gnome.shell.extensions.transparent-window opacity "${TRANSPARENT_WINDOW_OPACITY}" >/dev/null 2>&1 || true
  if command -v dconf >/dev/null 2>&1; then
    dconf write /org/gnome/shell/extensions/transparent-window/opacity "${TRANSPARENT_WINDOW_OPACITY}" >/dev/null 2>&1 || true
  fi
}

print_transparent_window_notes() {
  if ! is_gnome_session; then
    return 0
  fi

  echo "Transparent Window extension target opacity: ${TRANSPARENT_WINDOW_OPACITY}%."
  echo "Note: applying transparency only to Cursor by default is not reliably supported in GNOME Wayland."
}

setup_gnome_extensions() {
  install_gnome_packages
  install_transparent_window_extension
  enable_hide_top_bar_extension
  enable_transparent_window_extension
  configure_transparent_window_opacity
  print_transparent_window_notes
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_gnome_extensions
fi
