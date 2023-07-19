#!/bin/bash

# WIP -- USE WITH CAUTION!
# TODO: meet dependencies, error-handling and adapt to given distro

mkdir -p $HOME/.config

rm $HOME/.zshrc
ln -s $HOME/dotfiles/.zshrc $HOME
ln -s $HOME/dotfiles/.gitconfig $HOME
ln -s $HOME/dotfiles/.config/bat $HOME/.config
ln -s $HOME/dotfiles/.config/nvim $HOME/.config
ln -s $HOME/dotfiles/.config/tmux $HOME/.config
# ln -s $HOME/dotfiles/.config/btop $HOME/.config

# ln -s $HOME/dotfiles/.config/alacritty $HOME/.config
# ln -s $HOME/dotfiles/.config/i3 $HOME/.config
