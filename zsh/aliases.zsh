alias fcl="fortune | cowsay -f dragon | lolcat"
alias supdawg="echo 'not much wbu'"
dc() { echo -e "\U0001F198"
}

alias ip="ip -c"
# alias fd="fdfind"
# alias mdcat="mdcat -p"
alias mdp="mdp -i"

alias exa="exa --git --icons"
alias exad="exa --git --icons -la --no-user --octal-permissions -ShiI .git"
alias exatl="exa --git --icons --no-user -TL"

alias fzfp="fzf --preview 'bat --color=always {}'"
alias fzfv="fzf --preview 'bat --color=always {}' --bind 'enter:become(vim {})'"
fzfhv() { local file
   file=$(rg --files --hidden | fzf --preview 'bat --color=always {}')
   [[ -n "$file" ]] && nvim "$file"
}

# alias kp="keepassxc-cli"