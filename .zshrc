# Remote shells fix
export TERM=xterm-256color
export COLORTERM=truecolor

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
    "arch"|"ubuntu"|"fedora") export MANPAGER="bat -l man -p --theme=Nord" ;;
    *) export MANPAGER="sh -c 'col -bx | bat -l man -p --theme=Nord'" ;;
  esac
fi

# Set $RANDOM_THEME
case $distro in
  "parrot") ZSH_THEME="parrot"; export PATH=$PATH:/sbin ;;
  # "termux") ZSH_THEME="kennethreitz"; echo '\e[3 q' ;;
  *)        ZSH_THEME="random" ;;
esac

# # Favorite themes
# ZSH_THEME_RANDOM_CANDIDATES=(
#   'afowler' 'dpoggi' 'eastwood' 'fletcherm' 'gallois'
#   'macovsky' 'mh' 'muse' 'tonotdo' 'wedisagree'
# )

# Set custom folder for personal aliases, plugins and themes
ZSH_CUSTOM="$HOME/dotfiles/zsh"

# See $ZSH/plugins & $ZSH_CUSTOM/plugins -- https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
plugins=(
  devops
  git tmux ubuntu     # archlinux docker nmap -- ansible aws
  zsh-autosuggestions zsh-syntax-highlighting
)

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

if command -v nvim >/dev/null 2>&1; then
  EDITOR='nvim'
else
  EDITOR='vim'
fi

# Uncomment the following line to disable marking untracked files under VCS as
# dirty. This makes repository status checks for large repositories much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"


source $ZSH/oh-my-zsh.sh


# PAGERZ
export DELTA_PAGER='less -j2 -FR --mouse --wheel-lines 4'
# export BAT_PAGER='less -j2 -FR --mouse --wheel-lines 4'
  # $ delta --help | grep -C3 pager


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

# export LESS="-SRXF" # -- https://www.mycli.net/pager
# export PAGER="less -SRXF" # -- https://www.mycli.net/pager

# source $HOME/dotfiles/zsh/tmux_init.zsh

# Shell wrapper that provides the ability to change the current working directory when exiting Yazi
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Vagrant config for pabloqpacin/tbok
if command -v vagrant &>/dev/null; then
  export VAGRANT_DISABLE_VBOXSYMLINKCREATE=1
  #export ANSIBLE_COW_SELECTION=random
  export ANSIBLE_NOCOWS=1
  case $VAGRANT_HOME in
    '/var/vagrant.d') echo 'OK' > /dev/null ;;
    # EX2511
    # # "media/$USER/devops-101") echo 'OK' > /dev/null ;; # echo "La variable VAGRANT_HOME ya es media/$USER/devops-101"
    # # '' | '~/.vagrant.d' | *) export VAGRANT_HOME="media/$USER/devops-101"
    '' | '~/.vagrant.d' | *) export VAGRANT_HOME='/var/vagrant.d' ;;
  esac
fi
# https://github.com/hashicorp/vagrant/issues/4482
  # vboxmanage list systemproperties | grep machine
  # vboxmanage setproperty machinefolder /path/where/you/want/VirtualboxVMs

# if [[ "${COMPOSE_PROJECT_NAME}" != '' ]]; then
#     COMPOSE_PROJECT_NAME=''
# fi

# # bun completions
# [ -s "/home/pabloqpacin/.bun/_bun" ] && source "/home/pabloqpacin/.bun/_bun"

# # bun
# export BUN_INSTALL="$HOME/.bun"
# export PATH="$BUN_INSTALL/bin:$PATH"

# # >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/home/pabloqpacin/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/home/pabloqpacin/miniconda3/etc/profile.d/conda.sh" ]; then
#         . "/home/pabloqpacin/miniconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/home/pabloqpacin/miniconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# # <<< conda initialize <<<

