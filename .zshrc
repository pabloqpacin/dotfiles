# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Display man pages with Bat highlighting
export MANPAGER="sh -c 'col -bx | bat -l man -p --theme=Nord'"

# Set $RANDOM_THEME -- pts output << trapd00r linuxonly humza? skaro?
ZSH_THEME="random"
ZSH_THEME_RANDOM_CANDIDATES=( "af-magic" "afowler" "alanpeabody" "arrow" "avit" "bureau" "clean"
  "cloud" "crunch" "cypher" "daveverwer" "dieter" "dpoggi" "eastwood" "fishy" "flazz" "fletcherm"
  "frisk" "frontcube" "gallifrey" "gallois"  "geoffgarside" "itchy" "jispwoso" "josh" "jreese"
  "kennethreitz" "kphoen" "macovsky" "maran" "mh" "miloshadzic" "minimal" "mlh" "muse"
  "nanotech" "nicoulaj" "norm" "obraun" "peepcode" "re5et" "refined" "rgm" "risto"
  "simple" "Soliah" "sunaku" "sunrise" "strug" "terminalparty" "theunraveler"
  "tonotdo" "wedisagree" "wuffers" "ys" "zhann"
)
# FORMER: 3den adben(fortune) apple amuse awesomepanda candy-kingdom dallas dogenpunk dst
# edvardm essembeh fwalch garyblessington gozilla half-life jbergantine jnrowe juanghurtado
# junkfood kafeitu kolo mgutz michelebologna mortalscumbag mrtazz murilasso nebirhos
# pygmalion-virtualenv robbyrussel smt sonicradish steeef superjarin suvash wezm+

# Set custom folder for personal aliases, plugins and themes
ZSH_CUSTOM="$HOME/dotfiles/zsh"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git)

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

# Python programs (ie. picopins)
export PATH=$PATH:~/.local/bin

# ...btw
# neofetch

# after curl Deno within WSL Ubuntu
export PATH=$PATH:~/.deno/bin


# WSL Ubuntu: grant access to host default browser via wslu -- for Rust book 
if [[ -n "WSL_DISTRO_NAME" ]]; then
    # sudo apt install ubuntu-wsl wslu
    export BROWSER=wslview
fi

# Termux tweaks -- change cursor and set zsh theme
if [[ $(uname -o) == "Android" ]]; then
    ZSH_THEME="kennethreitz"
    echo '\e[3 q'
fi


# Enable zoxide if exists
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi
