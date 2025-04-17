#!/bin/sh

file=${HOME}/.oh-my-bash/oh-my-bash.sh

grep -e "Random theme" "${file}"
sed -i '/Random theme/s/^/# /' "${file}"
grep -e "Random theme" "${file}"
