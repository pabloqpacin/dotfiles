#!/bin/sh

file=$HOME/.oh-my-zsh/themes/random.zsh-theme

cat $file | grep -e "loaded"
sed -i '/loaded/s/^/# /' $file
cat $file | grep -e "loaded"

# Won't work on NixOS...
