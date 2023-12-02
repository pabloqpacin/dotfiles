# Account for: Arch Debian Kali Nix Parrot Pop Termux Ubuntu
distro=$(grep -s "^ID=" /etc/os-release | awk -F '=' '{print $2}')
case $distro in '') distro='termux' ;; esac           # termux-info

# Path to oh-my-zsh installation
if [[ $distro != "NixOS" ]]; then
  export ZSH="$HOME/.oh-my-zsh"
fi

# Display man pages with Bat highlighting
if command -v bat &>/dev/null; then
  case $distro in
    "arch") export MANPAGER="bat -l man -p --theme=Nord" ;;
    *) export MANPAGER="sh -c 'col -bx | bat -l man -p --theme=Nord'" ;;
  esac
fi

# Set $RANDOM_THEME
case $distro in
  "parrot") ZSH_THEME="parrot"; export PATH=$PATH:/sbin ;;
  # "termux") ZSH_THEME="kennethreitz"; echo '\e[3 q' ;;
  *)        ZSH_THEME="random" ;;
esac

# Them Baddest themes
ZSH_THEME_RANDOM_CANDIDATES=( "afowler" "alanpeabody" "avit" "daveverwer" "dpoggi"
  "eastwood" "fletcherm" "gallois" "geoffgarside" "macovsky" "mh" "minimal" "muse"
  "nanotech" "refined" "simple" "theunraveler" "tonotdo"
  "wedisagree" "wuffers" "zhann"
)

# Set custom folder for personal aliases, plugins and themes
ZSH_CUSTOM="$HOME/dotfiles/zsh"

# See $ZSH/plugins & $ZSH_CUSTOM/plugins
plugins=(
  archlinux git nmap tmux ubuntu    # docker
  zsh-autosuggestions zsh-syntax-highlighting
)

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

# Uncomment the following line to disable marking untracked files under VCS as
# dirty. This makes repository status checks for large repositories much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"


source $ZSH/oh-my-zsh.sh


# NVM installation requirements -- auto-written after curl
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Enable zoxide if exists
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# Python programs (ie. picopins), oh-my-posh
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  export PATH=$PATH:$HOME/.local/bin
fi

# Deno stuff -- peek.nvim
if [[ ":$PATH:" != *":$HOME/.deno/bin:"* ]]; then
  export PATH=$PATH:$HOME/.deno/bin
fi

# Browser for Debian WSL
if [[ $WSL_DISTRO_NAME == "Debian" ]]; then
    export BROWSER='/mnt/c/Users/pquev/AppData/Local/BraveSoftware/Brave-Browser/Application/brave.exe'
fi

# # WSL Ubuntu: grant access to host default browser via wslu -- for Rust book 
# if [[ -n "WSL_DISTRO_NAME" ]]; then
#     # sudo apt install ubuntu-wsl wslu
#     export BROWSER=wslview
# fi

# Return pretty $PATH with: echo $PATH | tr ':' '\n'
