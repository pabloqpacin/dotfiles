#!/bin/bash


# Install some terminal utilities
sudo apt install -y aha ascii cowsay clang curl git fortune html2text htop neofetch tree vim zsh


# Set vim as default editor
export EDITOR=vim

# Install Oh My Zsh
read -p "Install OhMyZsh? [Y/n]"
if [[ $REPLY == 'n' ]]; then
    continue
else cd ~ && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Save htop output
read -p "Touch HTOP file? [Y/n]"
if [[ $REPLY == 'n' ]]; then
    continue
else echo q | htop -C | aha --line-fix | html2text -width 999 |
grep -v "F1Help\|xml version=" > ~/htop-output01.txt
fi



neofetch
echo -e "\nENABLE:\n- gitconfig\n- zshrc\n- vimrc\n\n"
cat ~/htop-output01.txt