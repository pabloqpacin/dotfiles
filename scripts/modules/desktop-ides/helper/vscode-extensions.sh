#!/usr/bin/env bash

set -euo pipefail

build_extensions_list() {
  local -a extensions=(
    "zhuangtongfa.material-theme"
    "vscode-icons-team.vscode-icons"
    "eamodio.gitlens"
    "yzhang.markdown-all-in-one"
    "yzane.markdown-pdf"
    "tomoki1207.pdf"
    "bierner.markdown-mermaid"
    "bpruitt-goddard.mermaid-markdown-syntax-highlighting"
    "naumovs.color-highlight"
    "gruntfuggly.todo-tree"
    "redhat.vscode-yaml"
    "tamasfe.even-better-toml"
    "ms-vscode.live-server"
    "jeanp413.open-remote-ssh"
    "ms-azuretools.vscode-docker"
    "trunk.io"
    "hashicorp.hcl"
    "hashicorp.terraform"
    "mechatroner.rainbow-csv"
  )

  if command -v kubectl >/dev/null 2>&1; then
    extensions+=("ms-kubernetes-tools.vscode-kubernetes-tools")
  fi

  printf '%s\n' "${extensions[@]}"
}

install_extensions_for_cli() {
  local ide_cli="${1:?ide cli required}"
  command -v "${ide_cli}" >/dev/null 2>&1 || return 0

  local installed_extensions=""
  if installed_extensions="$("${ide_cli}" --list-extensions 2>/dev/null || true)"; then
    :
  fi

  local extension=""
  while IFS= read -r extension; do
    [[ -z "${extension}" ]] && continue

    if printf '%s\n' "${installed_extensions}" | rg -x --fixed-strings "${extension}" >/dev/null 2>&1; then
      continue
    fi

    "${ide_cli}" --install-extension "${extension}"
  done < <(build_extensions_list)
}

setup_vscode_extensions() {
  local ide="${1:-all}"

  case "${ide}" in
    vscodium)
      install_extensions_for_cli "codium"
      ;;
    cursor)
      install_extensions_for_cli "cursor"
      ;;
    all)
      install_extensions_for_cli "codium"
      install_extensions_for_cli "cursor"
      ;;
    *)
      echo "Unknown IDE target for extensions: ${ide}"
      return 1
      ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_vscode_extensions
fi
