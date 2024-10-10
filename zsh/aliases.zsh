# # omz plugins' aliases: agu aguu agi, gst ga gd gds, ...

# alias rm='mv $1 /tmp/$1'

alias copy='xsel --clipboard --input'

#alias xx='exit'
alias tls='tmux list-sessions'

if command -v delta &>/dev/null; then
    # Enable delta autocomplete -- https://github.com/dandavison/delta/issues/1167#issuecomment-1678568122
    compdef _gnu_generic delta
fi

alias td='tcpdump'
alias ff='fastfetch'
alias cgst='clear && gst'

alias MP='sudo mount -t nfs 192.168.1.5:/var/pi-nfs /mnt/pi-nfs || echo "Failed to mount NFS share"'
alias UP='sudo umount /mnt/pi-nfs || echo "Failed to unmount NFS share"'


alias spy='sudo pacman -Syu'
alias sps='sudo pacman -S'
alias ysy='yay -Syu --cleanmenu=false --diffmenu=false'

alias snr='sudo snap refresh'
alias updeez='sudo apt update -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y'
showpath() { echo $PATH | tr ':' '\n' | sort }

# updeez(){
#     sudo apt update &&
#     sudo apt full-upgrade -y &&
#     sudo apt autoremove -y &&
#     sudo apt autoclean
# }

# cleanup(){
#     sudo apt purge "$1" &&
#     sudo apt autoremove -y
# }

alias fcl="fortune | cowsay -f dragon | lolcat"
alias supdawg="echo 'not much wbu'"
dc() { echo -e "\U0001F198" }
alias cbon='cbonsai -lt 1'
alias clera="echo 'wtf'"
alias claer="echo 'wtf'"
alias exot="echo 'wtf'"

#alias tree="tree -C -L"
#alias trea="tree -C -aI .git -L"
alias less="less --mouse --wheel-lines=3"

if command -v eza &>/dev/null; then
    alias ls="eza --icons"
    alias eza="eza --icons --group --group-directories-first --git"
    alias laz="eza -la -ShiI .git --no-user --octal-permissions --group-directories-first --git"
    alias tree="eza -T --git"
    alias trez="eza -laI .git --no-user --no-permissions --no-filesize --group-directories-first --git -T"
fi

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

tn() { tmux new -s $(pwd | sed 's#.*/##') }
tnj() {
  session_name=$(pwd | sed 's#.*/##')
  tmux new-session -s "$session_name" \; split-window -v -p 50 \; select-pane -t 0
}
tnl() {
  session_name=$(pwd | sed 's#.*/##')
  tmux new-session -s "$session_name" \; split-window -h -p 50 \; select-pane -t 0
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
    alias ping="grc ping -c4 -w4"
    alias nmap="grc nmap"
    alias stat="grc stat"
    alias iptables="grc iptables"
fi

alias nst='netstat -lnpt'       # Active server connections ish
alias nmapkenobi="nmap -p- -sS -sC -sV --open --min-rate 5000 -n -vvv -Pn"  # add IP
alias cargo-update="cargo install-update -a"
alias fup='flatpak update'
alias fupy='flatpak update -y'
alias kcli='keepassxc-cli'
alias dneo="neo -D"

# Toggle autosuggestions & syntax highlighting with Ctrl+Alt+E
bindkey -s '\e^E' "source ~/dotfiles/scripts/setup/zsh-toggle_plugs.sh\n"

# Change alacritty theme
bindkey -s '\e^A' "source ~/dotfiles/scripts/setup/alacritty-random_theme.sh\n"

# Fix pipewire --  https://support.system76.com/articles/audio
bindkey -s '\e^P' "systemctl --user restart wireplumber pipewire pipewire-pulse\n"


# Python stuff
alias pipu='pip install -U'
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

alias grmc='git rm --cached'    # $1
alias grv='git remote -v'
alias gsl='git stash list'
alias gss='git stash show -p'
alias gla='git log --all --graph --oneline --decorate'
alias glf="glods --follow"  #$1
# alias gsp='git stash pop'
# alias gs='git stash'
alias gstun='git status --untracked-files=no'

alias vrv='virt-host-validate'      # KVM

alias ftail='tail -f'


# count_lines_dir(){

#     file_counter=1
#     total=0
#     for file in $(find foo); do
#         number=$(wc -l $file)
#         echo "File $file_counter: $number lines -- $file" | \
#             tee -a output.txt
#         # total=+$((number))
#         # file_counter=++
#         ((total=+number))
#         ((file_counter=++))
#     done
#     echo -e "\tTOTAL: $total lines"
# }

alias tolower="tr '[:upper:]' '[:lower:]'"

whatismyip(){
    dig +short myip.opendns.com @resolver1.opendns.com
}

bat-f() {
    # USAGE: bat-f /tmp/foo.txt -- https://github.com/sharkdp/bat/issues/457
    tail -f "$1" | bat -l=log --paging=never
}

bat-ff() {
    tail -f "$1" -n +1 | bat -l=log --paging=never
}

# manbat(){
#     # USAGE: manbat ettercap
#     "$1" --help | bat -l man --theme=Nord
# }


thanks(){
    if type shuf > /dev/null; then
      cowfile="$(cowsay -l | sed "1 d" | tr ' ' '\n' | shuf -n 1)"
    else
      cowfiles=( $(cowsay -l | sed "1 d") );
      cowfile=${cowfiles[$(($RANDOM % ${#cowfiles[*]}))]}
    fi

    fortune | cowsay -f "$cowfile" | lolcat --animate --speed=50
    ### Debian 12: { echo "export PATH=$PATH:/usr/games" >> ~/.bashrc }
}
