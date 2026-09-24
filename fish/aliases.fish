
# Tmux
alias tn="tmux new -s $(pwd | sed 's#.*/##')"

# Git
alias gst='git status'
alias cgst='clear && git status'
alias ga='git add'
alias gd='git diff'
alias gds='git diff --staged'
# alias glol='git log --graph --pretty="%Cred%h%Creest vb'
alias glol="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'"

# Docker
alias dps='docker ps'
alias dcu='docker compose up'


