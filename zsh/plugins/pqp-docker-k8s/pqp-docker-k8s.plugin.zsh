#!/bin/bash

if command -v grc &>/dev/null; then
    alias docker="grc docker"
    alias kubectl="grc kubectl"
fi


########## DOCKER

alias dps='docker ps'
alias dlf='docker logs -f'
alias dils='docker image ls'
alias dvls='docker volume ls'
alias dvlsj='docker volume ls --format json | jq -C'
alias dnls='docker network ls'
alias drmv='docker rm -v'

# alias dc='docker compose'
alias dcu='docker compose up'
alias dcps='docker compose ps'
alias dcls='docker compose ls'
alias dclf='docker compose logs -f'

alias dcd='docker compose down'
alias dcdv='docker compose down -v'
alias dcdd='docker compose down --rmi all -v'


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


##### Buildx

alias dbls='docker buildx ls'



########## KUBERNETES


##### minikube

alias mk='minikube'
alias mkst='minikube status'
alias mkpl='minikube profile list'


##### kubectl

alias kc='kubectl'

alias kcaf='kubectl apply -f'

alias kcda='kubectl delete all --all'       # maybe don't delete "kubernetes" svc...

alias kcga='kubectl get all -o wide'
alias kcgd='kubectl get deployments -o wide'
alias kcgc='kubectl get cm'
alias kcgp='kubectl get pods -o wide'
alias kcgs='kubectl get secrets -o yaml'

alias kcd='kubectl describe'


# alias kcd='kubectl describe'

# kcd-p(){
#     kubectl describe "$1" | bat
#     # eg. kcgp-p pod/nginx
# }

# kcgoj(){
#     kubectl get "$1" -o json | ...
# }
# kcgoy() {
#     kubectl get "$1" -o yaml | ...
# }


alias kc-proxy="kubectl proxy --address='0.0.0.0' --disable-filter=true"

# kcc(){
#     curl -s "$1" | jq -C
#     # curl "$1" | ccze -m ansi -o nolookups
# }

# kcc-p(){
#     curl -s "$1" | jq -C | bat
#     # EG kcc-p 192.168.1.40:8001/api/v1/namespace/default
# }

