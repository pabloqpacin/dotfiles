#!/usr/bin/env bash

# NOTE: wget -qO- "https://raw.githubusercontent.com/pabloqpacin/dotfiles/refs/heads/feat/refactor-scripts/scripts/bootstrap.sh" | bash

set -euo pipefail

REPO_URL="${REPO_URL:-https://github.com/pabloqpacin/dotfiles.git}"
REPO_BRANCH="${REPO_BRANCH:-feat/refactor-scripts}"
TARGET_DIR="${TARGET_DIR:-${HOME}/dotfiles}"

if [[ ! -d "${TARGET_DIR}/.git" ]]; then
  git clone --depth=1 --branch "${REPO_BRANCH}" "${REPO_URL}" "${TARGET_DIR}"
else
  git -C "${TARGET_DIR}" fetch --depth=1 origin "${REPO_BRANCH}"
  git -C "${TARGET_DIR}" checkout "${REPO_BRANCH}"
  git -C "${TARGET_DIR}" reset --hard "origin/${REPO_BRANCH}"
fi

bash "${TARGET_DIR}/scripts/main.sh"
