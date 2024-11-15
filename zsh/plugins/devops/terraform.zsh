# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/terraform

alias tf='terraform'

alias tfsh='terraform show -no-color | bat -pl tf'

tfp(){
    # ex tfp plan1
    terraform plan -out $1
    terraform show -no-color $1 > $1.log
}
