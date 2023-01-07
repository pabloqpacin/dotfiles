#!/bin/bash

# DOCUMENTATION
# - https://www.adminschoice.com/bash-positional-parameters
# - https://www.youtube.com/watch?v=7qd5sqazD7k&list=PLIhvC56v63IKioClkSNDjW7iz-6TFvLwS&index=2&t=496s)


# Gatekeepr
read -p "Have you '$USER' run the script like './autodotfile.sh <file>'? [Y/n] "
if [[ $REPLY == 'n' ]];
then exit
fi

# Handle the dotfile
mv ~/$1 ~/.dotfiles/
ln -s ~/.dotfiles/$1 ~/