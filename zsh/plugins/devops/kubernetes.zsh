
if kubectl &>/dev/null; then
    source <(kubectl completion zsh)
fi

if command -v grc &>/dev/null; then
    alias kubectl="grc kubectl"
fi

# alias fnode='--field-selector spec.nodeName='     # INOP
    # kcga fnode=foo
    # kcga $(fnode)poc-w1-q45cnhhdlyvi-node-0

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


alias k8s_force_delete_ns_gitops="kubectl get namespace gitops -o json | jq 'del(.spec.finalizers)' | kubectl replace --raw /api/v1/namespaces/gitops/finalize -f -)"
# kubectl delete pod nexus-deployment-5df98fb5ff-zj2sk --namespace gitops --grace-period=0 --force
# kubectl delete pod nexus-deployment-76969c67f8-tmlfd --namespace gitops --grace-period=0 --force
