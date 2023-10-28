#!/bin/sh

file=$HOME/.oh-my-bash/oh-my-bash.sh

cat $file | grep -e "Random theme"
sed -i '/Random theme/s/^/# /' $file
cat $file | grep -e "Random theme"
