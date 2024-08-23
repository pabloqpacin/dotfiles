
# DEPENDENCIES FOR PIPED FORMATTING: bat jq grc

source "$ZSH_CUSTOM"/plugins/devops/docker.zsh
source "$ZSH_CUSTOM"/plugins/devops/kubernetes.zsh

source "$ZSH_CUSTOM"/plugins/devops/vagrant.zsh
# source "$ZSH_CUSTOM"/plugins/devops/ansible.zsh

source "$ZSH_CUSTOM"/plugins/devops/aws.zsh
source "$ZSH_CUSTOM"/plugins/devops/terraform.zsh


shcurl(){
    # EX: shcurl terraform
    # curl -s cheat.sh/"$@" | bat -p
    curl -s cheat.sh/"$@" | less -SFXR
}
