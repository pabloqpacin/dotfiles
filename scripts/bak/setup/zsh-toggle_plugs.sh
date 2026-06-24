#!/bin/sh

red="\e[31m"
reset="\e[0m"
green="\e[32m"
file=${HOME}/.zshrc

if grep -qE "^\s*#.*zsh-auto" "${file}"; then
  sed -i -e "/^\s*#.*zsh-auto/s/^#//" "${file}"
  echo "\nZsh autoggestions & syntax-highlighting ${green}enabled${reset}."
else
  sed -i -e "/zsh-auto/s/^/# /" "${file}"
  echo "\nZsh autoggestions & syntax-highlighting ${red}disabled${reset}."
fi

exec zsh
