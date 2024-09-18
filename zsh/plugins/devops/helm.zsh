
alias hrl='helm repo list'
alias hru='helm repo update'

# alias hein='helm install'
# alias hecr='helm create'

hls(){
    helm ls -A | awk '{print $1, $2}' | column -t
}

