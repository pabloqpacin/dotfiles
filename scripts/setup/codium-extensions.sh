#!/bin/bash

# if ! ...

extensions=(
'zhuangtongfa.material-theme' 'vscode-icons-team.vscode-icons'
'yzhang.markdown-all-in-one' 'yzane.markdown-pdf' 'tomoki1207.pdf'
'bierner.markdown-mermaid' 'bpruitt-goddard.mermaid-markdown-syntax-highlighting'
'naumovs.color-highlight' 'ms-vscode.live-server'
'gruntfuggly.todo-tree'
'bbenoist.nix' 'rust-lang.rust-analyzer'
'redhat.vscode-yaml'
'jeanp413.open-remote-ssh'
'ms-azuretools.vscode-docker'
'ms-kubernetes-tools.vscode-kubernetes-tools'
)

for i in "${!extensions[@]}"; do
    codium --install-extension "${extensions[i]}"
done
