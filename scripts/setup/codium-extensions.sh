#!/bin/bash

extensions=(
'zhuangtongfa.material-theme' 'vscode-icons-team.vscode-icons'
'yzhang.markdown-all-in-one' 'yzane.markdown-pdf' 'tomoki1207.pdf'
'bierner.markdown-mermaid' 'bpruitt-goddard.mermaid-markdown-syntax-highlighting'
'naumovs.color-highlight' 'ms-vscode.live-server'
'msazuretools.vscode-docker'
'bbenoist.nix'
)

for i in "${!extensions[@]}"; do
    codium --install-extension "${extensions[i]}"
done
