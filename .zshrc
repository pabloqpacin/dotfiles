# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Display man pages with Bat highlighting
export MANPAGER="sh -c 'col -bx | bat -l man -p --theme=default'"

# Set $RANDOM_THEME
ZSH_THEME="random"
ZSH_THEME_RANDOM_CANDIDATES=( "3den2" "adben" "af-magic" "afowler" "agnoster"
  "alanpeabody" "amuse" "apple" "arrow" "avit" "awesomepanda" "bureau"
  "candy-kingdom" "clean" "cloud" "crunch" "cypher" "dallas" "daveverwer"
  "dieter" "dogenpunk" "dpoggi" "dst" "edvardm" "eastwood" "essembeh" "example"
  "fino" "fishy" "flazz" "fletcherm" "frisk" "frontcube" "fwalch" "gallifrey"
  "gallois" "garyblessington" "geoffgarside" "gozilla" "half-life" "humza"
  "itchy" "jbergantine" "jispwoso" "jnrowe" "josh" "jreese" "juanghurtado"
  "junkfood" "kafeitu" "kennethreitz" "kolo" "kphoen" "linuxonly" "macovsky"
  "macovsky-ruby" "maran" "mgutz" "mh" "michelebologna" "miloshadzic" "minimal"
  "mlh" "mortalscumbag" "mrtazz" "murilasso" "muse" "nanotech" "nebirhos"
  "nicoulaj" "norm" "obraun" "peepcode" "pygmalion-virtualenv" "re5et"
  "refined" "rgm" "robbyrussell" "risto" "simple" "skaro" "smt" "Soliah"
  "sonicradish" "sporty_256" "steeef" "sunaku" "sunrise" "superjarin" "strug"
  "suvash" "terminalparty" "theunraveler" "tjkirch_mod" "tonotdo" "trapd00r"
  "wedisagree" "wezm" "wezm+" "wuffers" "ys" "zhann"
)

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

