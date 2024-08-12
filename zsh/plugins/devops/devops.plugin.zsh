
### Docker
### Kubernetes
### Vagrant
### Ansible

# ---

##### Docker

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
alias dcu='docker compose up'
alias dcps='docker compose ps'
alias dcls='docker compose ls'
alias dcl='docker compose logs'
alias dclf='docker compose logs -f'
alias dcd='docker compose down'
alias dcdv='docker compose down -v'
alias dcdd='docker compose down --rmi all -v'

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

##### Kubernetes

if command -v grc &>/dev/null; then
    alias kubectl="grc kubectl"
fi

alias mk='minikube'
alias mkst='minikube status'
alias mkpl='minikube profile list'

alias ka='kubeadm'
alias katl='kubeadm token list'

alias kc='kubectl'
alias kccv='kubectl config view'
alias kcaf='kubectl apply -f'
alias kcga='kubectl get all -o wide'
alias kcgd='kubectl get deployments -o wide'
alias kcgn='kubectl get nodes -o wide'
alias kcgp='kubectl get pods -o wide'
alias kcgs='kubectl get secrets -o yaml'
alias kcgc='kubectl get cm'
alias kcdf='kubectl delete -f'
alias kcda='kubectl delete all --all'       # maybe don't delete "kubernetes" svc...
alias kcd='kubectl describe'

kcgpy(){
    kubectl get pod "$1" -o yaml
}

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

##### Vagrant

alias vup='vagrant up'
alias vssh='vagrant ssh'
alias vst='vagrant status'
alias vpro='vagrant provision'
alias vdestroy='vagrant destroy'
alias vhalt='vagrant halt'

alias vpl='vagrant plugin list'
alias vbl='vagrant box list'

alias vss='vagrant snapshot'
    # list, push, pop


##### Ansible

# alias foo='bar'
