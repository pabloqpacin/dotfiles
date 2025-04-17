# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/terraform

alias tf='terraform'

alias tfshow='terraform show -no-color | bat -pl tf'

alias tfplan='tf plan -no-color | tee plan.log'
# tfplan(){
#     tf plan -out plan.tfplan
#     tf show -no-color plan.tfplan > plan.log
# }
