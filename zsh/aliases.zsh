# aguu='sudo apt update && sudo apt upgrade'
# agi='sudo apt install'

alias updeez='sudo apt update -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y'
showpath() { echo $PATH | tr ':' '\n' }

alias fcl="fortune | cowsay -f dragon | lolcat"
alias supdawg="echo 'not much wbu'"
dc() { echo -e "\U0001F198" }
alias cbon='cbonsai -lt 1'
alias clera="echo 'wtf'"
alias claer="echo 'wtf'"
alias exot="echo 'wtf'"

alias trea="tree -aI .git"
alias less="less --mouse --wheel-lines=3"

alias eza="eza --icons"
alias ezad="eza --icons -la -ShiI .git --no-user --octal-permissions --group-directories-first --git"
alias ezatl="eza --icons -TL"
alias ezatal="eza --icons -laI .git --no-user --no-permissions --no-filesize --group-directories-first --git -TL"

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

# if [[ $(cat /etc/os-release | awk -F= '/^NAME=/{ print $2 }' | tr -d '"') == "openSUSE Tumbleweed" ]]; then
#     alias tldr="tldr -t base16"     # installed via npm (WSL)
# fi

alias htopp="echo q | htop -C | aha --line-fix | html2text -width 999 | grep -v 'F1Help\|xml version ='"
alias sslisten='ss -tul'            # -tuln

alias HH="Hyprland"
# alias dpt="dunstctl set-paused true"
# alias dpf="dunstctl set-paused false"

# alias gundo="git restore --staged $1 && git restore $1"
# # The $1 is a placeholder for the first argument you pass to the alias, the filename to unstage with 'gundo filename'
# # git restore --staged $1: unstage changes made to a file specified by $1.
# # git restore $1: discard changes made to a file specified by $1.

if command -v grc &>/dev/null; then
    alias ip="grc ip -c"
    alias ping="grc ping"
    alias nmap="grc nmap"
    alias stat="grc stat"
    alias docker="grc docker"
fi

alias nmapkenobi="nmap -p- -sS -sC -sV --open --min-rate 5000 -n -vvv -Pn"  # add IP
alias cargo-update="cargo install-update -a"
alias fup='flatpak update -y'
alias kpc='keepassxc-cli'
alias dneo="neo -D"

# Toggle autosuggestions & syntax highlighting with Ctrl+Alt+E
bindkey -s '\e^E' "source ~/dotfiles/scripts/setup/zsh-toggle_plugs.sh\n"

# Change alacritty theme
bindkey -s '\e^A' "source ~/dotfiles/scripts/setup/alacritty-random_theme.sh\n"

# Fix pipewire --  https://support.system76.com/articles/audio
bindkey -s '\e^P' "systemctl --user restart wireplumber pipewire pipewire-pulse\n"


# Python stuff
pipup() { for package in $(pip freeze); do pip install --upgrade $package; done }
pip_freeze () {
    DATE=$(date)
    echo -e "\n================================\n$DATE\n" >> $HOME/dotfiles/py/pip-pop.log
    pip freeze >> $HOME/dotfiles/py/pip-pop.log
}

alias acli="arduino-cli"
alias pinsa="picopins --all"

show_wifi() { nmcli device wifi list }
showhist() { awk -F ';' '{print $2}' ~/.zsh_history | bat -l bash -p }
count_lines() { find . -type f -exec cat {} \; | wc -l }

# rm_except() {
#     local extensions=("$@")  # Get the list of extensions passed as arguments
#     local find_cmd="find . -maxdepth 1 -type f ! -name 'this_one'"
#     # Add the exclusion for each extension
#     for ext in "${extensions[@]}"; do
#         find_cmd+=" ! -name '*.$ext'"
#     done
#     # Execute the find command with the constructed options
#     eval "$find_cmd -exec rm -f {} \;"
# }

alias sy="screenkey &; disown"
alias sys="screenkey --show-settings"
alias syk="pkill screenkey"

alias chx="chmod +x"
showports() { bat /etc/services }

show_pc_model() {
    if [ -e /sys/devices/virtual/dmi/id/product_name ]; then
        cat /sys/devices/virtual/dmi/id/product_name
    elif [ -e /sys/firmware/devicetree/base/model ]; then
          cat /sys/firmware/devicetree/base/model;
    fi
}

alias py='python3'

alias xpaste='xclip -o -sel clip'

alias grv='git remote -v'
