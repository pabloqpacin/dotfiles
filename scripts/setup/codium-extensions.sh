#!/usr/bin/env bash

# if ! ...

extensions=(
'zhuangtongfa.material-theme' 'vscode-icons-team.vscode-icons'
'yzhang.markdown-all-in-one' 'yzane.markdown-pdf' 'tomoki1207.pdf'
'bierner.markdown-mermaid' 'bpruitt-goddard.mermaid-markdown-syntax-highlighting'
'naumovs.color-highlight' 'gruntfuggly.todo-tree' 'redhat.vscode-yaml' 'tamasfe.even-better-toml'
# 'bbenoist.nix' 'rust-lang.rust-analyzer' 'devsense.phptools-vscode'
'ms-vscode.live-server' 'jeanp413.open-remote-ssh'
'ms-azuretools.vscode-docker'
)

if command -v kubectl &>/dev/null; then
    extensions+=('ms-kubernetes-tools.vscode-kubernetes-tools')
fi

for i in "${!extensions[@]}"; do
    codium --install-extension "${extensions[i]}"
done

# [GUIDE] How to run Copilot in VSCodium (without VSCode) -- https://github.com/VSCodium/vscodium/discussions/1487
