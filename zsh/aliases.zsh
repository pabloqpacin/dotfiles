# aguu='sudo apt update && sudo apt upgrade'
# agi='sudo apt install'
alias updeez='sudo apt update -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y'
showpath() { echo $PATH | tr ':' '\n' }

alias fcl="fortune | cowsay -f dragon | lolcat"
alias supdawg="echo 'not much wbu'"
dc() { echo -e "\U0001F198" }
alias cbonsie='cbonsai -lt 1'
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

# tn() { tmux new -s $(pwd | sed 's#.*/##') }
tn() {
  session_name=$(pwd | sed 's#.*/##')
  tmux new-session -s "$session_name" \; split-window -v -p 50 \; select-pane -t 0
}

alias du1="du -sh *"
alias du2="du -sh */*"
alias dus1="du -sh * | sort -rn"
alias dus2="du -sh */* | sort -rn"

# alias rpg="battlestar"
alias dfr="df -h | rg -C 10 -e '/($)'"
alias wfe='explorer.exe .'          # windows-file-explorer
alias wopen="sensible-browser"
# alias wopen="wslview"

if [[ $(cat /etc/os-release | awk -F= '/^NAME=/{ print $2 }' | tr -d '"') == "openSUSE Tumbleweed" ]]; then
    alias tldr="tldr -t base16"     # installed via npm (WSL)
fi

alias htopp="echo q | htop -C | aha --line-fix | html2text -width 999 | grep -v 'F1Help\|xml version ='"
alias sslisten='ss -tul'            # -tuln

alias HH="Hyprland"
# alias dpt="dunstctl set-paused true"
# alias dpf="dunstctl set-paused false"

# alias gundo="git restore --staged $1 && git restore $1"
# # The $1 is a placeholder for the first argument you pass to the alias, the filename to unstage with 'gundo filename'
# # git restore --staged $1: unstage changes made to a file specified by $1.
# # git restore $1: discard changes made to a file specified by $1.

alias nmapkenobi="nmap -p- -sS -sC -sV --open --min-rate 5000 -n -vvv -Pn"  # add IP
alias cargo-update="cargo install-update -a"
alias kpc='keepassxc-cli'
alias dneo="neo -D"

bindkey -s '\e^E' "source ~/dotfiles/scripts/zsh-toggle_plugs.sh\n"
  # Toggle autosuggestions & syntax highlighting with Ctrl+Alt+E
