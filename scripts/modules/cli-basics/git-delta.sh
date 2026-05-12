#!/usr/bin/env bash

set -euo pipefail

write_gitdelta_file() {
  cat > "${HOME}/.gitdelta" <<'EOF'
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

link_gitconfig_for_personal_users() {
  local script_dir dotfiles_dir source target
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  dotfiles_dir="$(cd "${script_dir}/../../.." && pwd)"
  source="${dotfiles_dir}/.gitconfig.d/.gitconfig"
  target="${HOME}/.gitdelta"

  if [[ ! -f "${source}" ]]; then
    echo "Source gitconfig not found: ${source}" >&2
    return 1
  fi

  if [[ -L "${target}" ]] && [[ "$(readlink -f "${target}")" == "${source}" ]]; then
    return 0
  fi

  rm -f "${target}"
  ln -s "${source}" "${target}"
}

setup_gitdelta() {
  case "${USER:-}" in
    pquevedo|pabloqpacin)
      link_gitconfig_for_personal_users
      ;;
    *)
      write_gitdelta_file
      ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_gitdelta
fi
