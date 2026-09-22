#!/usr/bin/env bash

foo(){
    # pkg up -y
    pkg update -y
    pkg install -y grc nmap tmux
}

# zsh(){
# }

# ---

if true; then
    foo
fi
