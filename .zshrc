# Path to oh-my-zsh installation -- except for NixOS
if [[ $(cat /etc/os-release | awk -F= '/^NAME=/{ print $2 }' | tr -d '"') != "NixOS" ]]; then
  export ZSH="$HOME/.oh-my-zsh"
fi

# Display man pages with Bat highlighting
export MANPAGER="sh -c 'col -bx | bat -l man -p --theme=Nord'"
# export MANPAGER="bat -l man -p --theme=Nord"

# Set $RANDOM_THEME -- pts output << trapd00r linuxonly humza? skaro?
ZSH_THEME="random"
ZSH_THEME_RANDOM_CANDIDATES=( "af-magic" "afowler" "alanpeabody" "avit" "bureau"
  "clean" "daveverwer" "dpoggi" "eastwood" "fletcherm" "frontcube" "gallifrey"
  "gallois" "geoffgarside" "itchy" "josh" "kennethreitz" "kphoen" "macovsky"
  "mh" "minimal" "muse" "nanotech" "nicoulaj" "peepcode" "refined" "risto"
  "simple" "theunraveler" "tonotdo" "wedisagree" "wuffers" "zhann"
)
# FORMER: 3den adben(fortune) apple arrow amuse awesomepanda candy-kingdom cloud
# crunch cypher dallas dieter dogenpunk dst edvardm essembeh fishy flazz frisk fwalch
# garyblessington gozilla half-life jbergantine jispwoso jnrowe jreese juanghurtado junkfood
# kafeitu kolo maran mgutz michelebologna miloshadzic mlh mortalscumbag mrtazz murilasso nebirhos
# norm obraun pygmalion-virtualenv re5et rgm robbyrussel smt Soliah sonicradish steeef strug sunaku
# sunrise superjarin suvash terminalparty wezm+ ys
# BEST: alanpeabody daveverwer geoffgarside muse nicoulaj

# Set custom folder for personal aliases, plugins and themes
ZSH_CUSTOM="$HOME/dotfiles/zsh"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git nmap ubuntu)

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


# Enable zoxide if exists
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi


# NVM installation requirements -- auto-written after curl
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Python programs (ie. picopins)
export PATH=$PATH:~/.local/bin

# after curl Deno within WSL Ubuntu
export PATH=$PATH:~/.deno/bin


# Browser for Debian WSL
if [[ $WSL_DISTRO_NAME == "Debian" ]]; then
    export BROWSER='/mnt/c/Users/pquev/AppData/Local/BraveSoftware/Brave-Browser/Application/brave.exe'
fi

# # WSL Ubuntu: grant access to host default browser via wslu -- for Rust book 
# if [[ -n "WSL_DISTRO_NAME" ]]; then
#     # sudo apt install ubuntu-wsl wslu
#     export BROWSER=wslview
# fi

# # WSL Ubuntu: enable snap binaries -- neovim
# export PATH="$PATH:/snap/bin"


# Termux tweaks -- change cursor and set zsh theme
if [[ $(uname -o) == "Android" ]]; then
    ZSH_THEME="kennethreitz"
    echo '\e[3 q'
fi


# Return pretty $PATH with: echo $PATH | tr ':' '\n'
