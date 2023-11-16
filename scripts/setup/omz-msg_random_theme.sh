#!/bin/sh

file=$HOME/.oh-my-zsh/themes/random.zsh-theme

grep -e "loaded" $file
sed -i '/loaded/s/^/# /' $file
grep -e "loaded" $file

# Won't work on NixOS...
