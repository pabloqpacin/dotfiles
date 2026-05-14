#!/usr/bin/env bash

set -euo pipefail

render_gitconfig_template() {
  cat <<'EOF'
[init]
	defaultBranch = main
[http]
	version = HTTP/2

[core]
    pager = delta
[interactive]
    diffFilter = delta --color-only
[include]
    path = ~/dotfiles/.config/delta/themes.gitconfig
[delta]
    # features = calochortus-lyallii    # https://github.com/dandavison/delta/blob/main/themes.gitconfig
    # side-by-side = true
    line-numbers = true
    navigate = true
[merge]
    conflictstyle = diff3
[diff]
    colorMoved = default
EOF
}

write_gitconfig_file() {
  local target="${1:-${HOME}/.gitconfig}"
  echo "[git-delta] Writing ${target} from embedded template"

  if [[ "${target}" == "/root/.gitconfig" && "${USER:-}" != "root" ]]; then
    render_gitconfig_template | sudo tee "${target}" >/dev/null
    return 0
  fi

  render_gitconfig_template > "${target}"
}

link_gitconfig_for_personal_users() {
  local script_dir dotfiles_dir source target
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  dotfiles_dir="$(cd "${script_dir}/../../.." && pwd)"
  source="${dotfiles_dir}/.gitconfig.d/.gitconfig"
  target="${HOME}/.gitconfig"
  echo "[git-delta] Personal user detected, linking ${target} -> ${source}"

  if [[ ! -f "${source}" ]]; then
    echo "Source gitconfig not found: ${source}" >&2
    return 1
  fi

  if [[ -L "${target}" ]] && [[ "$(readlink -f "${target}")" == "${source}" ]]; then
    echo "[git-delta] Symlink already configured"
    return 0
  fi

  rm -f "${target}"
  ln -s "${source}" "${target}"
  echo "[git-delta] Symlink created successfully"
}

setup_gitconfig() {
  echo "[git-delta] Starting setup for user: ${USER:-unknown}"
  case "${USER:-}" in
    pquevedo|pabloqpacin)
      link_gitconfig_for_personal_users
      ;;
    *)
      write_gitconfig_file
      ;;
  esac
  write_gitconfig_file "/root/.gitconfig"
  echo "[git-delta] Setup complete"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_gitconfig
fi
