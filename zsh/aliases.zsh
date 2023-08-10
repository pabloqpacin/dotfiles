# aguu='sudo apt update && sudo apt upgrade'
# agi='sudo apt install'

alias fcl="fortune | cowsay -f dragon | lolcat"
alias supdawg="echo 'not much wbu'"
dc() { echo -e "\U0001F198" }
alias clera="echo 'wtf'"
alias claer="echo 'wtf'"
alias exot="echo 'wtf'"

alias ip="ip -c"
alias trea="tree -aI .git"
alias less="less --mouse --wheel-lines=3"

alias exa="exa --icons"
alias exad="exa --icons -la -ShiI .git --no-user --octal-permissions --git"
alias exatl="exa --icons -TL"
alias exatal="exa --icons -laI .git --no-user --no-permissions --no-filesize --git -TL"

alias fzfp="fzf --preview 'bat --color=always {}'"
alias fzfv="fzf --preview 'bat --color=always {}' --bind 'enter:execute(nvim {})'"
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

tn() { tmux new -s $(pwd | sed 's#.*/##') }
tw() { cd $HOME/Workspace && tmux -new -s $(pwd | sed 's#.*/##') }

alias du1="du -sh *"
alias du2="du -sh */*"
alias dus1="du -sh * | sort -rn"
alias dus2="du -sh */* | sort -rn"

# alias rpg="battlestar"
alias dfr="df -h | rg -C 10 -e '/($)'"
alias wfe='explorer.exe .'   # windows-file-explorer
alias wopen="sensible-browser"
# alias wopen="wslview"

if [[ $(cat /etc/os-release | awk -F= '/^NAME=/{ print $2 }' | tr -d '"') == "openSUSE Tumbleweed" ]]; then
    alias tldr="tldr -t base16"     # installed via npm (WSL)
fi

alias htopp="echo q | htop -C | aha --line-fix | html2text -width 999 | grep -v 'F1Help\|xml version ='"
alias sslisten='ss -tul'    # -tuln

alias HH="Hyprland"
# alias dpt="dunstctl set-paused true"
# alias dpf="dunstctl set-paused false"

# alias gundo="git restore --staged $1 && git restore $1"
# # The $1 is a placeholder for the first argument you pass to the alias, the filename to unstage with 'gundo filename'
# # git restore --staged $1: unstage changes made to a file specified by $1.
# # git restore $1: discard changes made to a file specified by $1.

