#!/bin/bash

git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting \
    $HOME/dotfiles/zsh/plugins/zsh-syntax-highlighting
