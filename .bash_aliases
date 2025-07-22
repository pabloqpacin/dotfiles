#/usr/bin/env bash

if [ ! -d ~/dotfiles/zsh/plugins/devops ]; then
  git clone https://github.com/pabloqpacin/dotfiles ~/dotfiles
fi

if [ -d ~/dotfiles/zsh/plugins/devops ]; then
  for file in ~/dotfiles/zsh/plugins/devops/*.zsh; do
    if [ -f "$file" ]; then
      source "$file" &>/dev/null
    fi
  done
fi

