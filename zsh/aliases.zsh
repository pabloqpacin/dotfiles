alias fcl="fortune | cowsay -f dragon | lolcat"
alias supdawg="echo 'not much wbu'"
dc() { echo -e "\U0001F198" }

alias ip="ip -c"
alias trea="tree -aI .git"
alias less="less --mouse --wheel-lines=3"

alias exa="exa --git --icons"
alias exad="exa --git --icons -la --no-user --octal-permissions -ShiI .git"
alias exatl="exa --git --icons --no-user -TL"

alias fzfp="fzf --preview 'bat --color=always {}'"
alias fzfv="fzf --preview 'bat --color=always {}' --bind 'enter:become(vim {})'"
fzfhv() { local file
   file=$(rg --files --hidden | fzf --preview 'bat --color=always {}')
   [[ -n "$file" ]] && nvim "$file"
}

alias mdp="mdp -i"
alias bcat="bat -p"
alias mdcat="mdcat -p"
alias rg="rg -.S --no-ignore"
# alias kp="keepassxc-cli"
# alias fd="fdfind"

# Start tmux session with pwd name
tn() { tmux new -s $(pwd | sed 's#.*/##') }
