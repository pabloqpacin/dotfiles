
if command -v grc &>/dev/null; then
    alias docker="grc docker"
fi

alias dps='docker ps'
alias dlf='docker logs -f'
alias dils='docker image ls'
alias dvls='docker volume ls'
alias dvlsj='docker volume ls --format json | jq -C'
alias dnls='docker network ls'
alias drmv='docker rm -v'
alias dvrm='docker volume rm $(docker volume ls -qf dangling=true)'
alias ddf='docker system df -v'

# alias dc='docker compose'
alias dcb='docker compose build'
alias dcu='docker compose up'
alias dcps='docker compose ps'
alias dcls='docker compose ls'
alias dcl='docker compose logs'
alias dclf='docker compose logs -f'
alias dcd='docker compose down'
alias dcdv='docker compose down -v'
alias dcdd='docker compose down --rmi all -v --remove-orphans'

alias dbls='docker buildx ls'

docker-inspect() {
    docker inspect "$1" | jq -C
    # docker inspect "$1" | ccze -m ansi -o nolookups
}

docker-inspect-p() {
    if command -v bat &>/dev/null; then
        docker inspect "$1" | jq -C | bat
    else
        docker inspect "$1" | jq -C | less
    fi
}

docker-prune(){
    # yes | docker container prune && \
    yes | docker network prune && \
    yes | docker volume prune && \
    yes | docker image prune && \
    yes | docker builder prune
}

 
# foo() {
#     for i in $(docker image ls -q); do
#         docker image rm $i
#     done
# }

