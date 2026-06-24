#!/usr/bin/env bash

set -euo pipefail

clone_dotfiles_repo() {
  local target_dir="${HOME}/dotfiles"
  local repo_url="https://github.com/pabloqpacin/dotfiles"
  local repo_branch="develop"

  if [[ ! -d "${target_dir}" ]]; then
    git clone --depth=1 --branch="${repo_branch}" "${repo_url}" "${target_dir}"
  fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  clone_dotfiles_repo
fi
