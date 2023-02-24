#!/bin/bash


<<.
sudo apt update
sudo apt upgrade -y
.


# Fun
sudo apt install bsdgames cmatrix cowsay figlet fortune lolcat neofetch oneko pacvim

# Useful
sudo apt install ascii bat htop ipcalc speedtest-cli taskwarrior tldr tree

# Important
sudo apt install curl git man nmap vim wget zsh
    # Need to config all Git, Vim and ZSH (.gitconfig, .vimrc, curl <OhMyZsh>)

# Software
sudo apt install keepassxc virtualbox wireshark


# ------------------------------------------------------------

# C programming
sudo apt install build-essential clang gcc gdb make

# Python programming
sudo apt install python3-pip python3-venv
    # pip install <tal> <cual>


# -----------------------------------------------------------

# Perhaps?
sudo apt install gnome-tweaks monero mysql-server youtube-dl

# Niche
sudo apt install aha ghostscript html2text poke p7zip w3m
    # [htop output to human readable file](https://stackoverflow.com/questions/17534591/htop-output-to-human-readable-file/30224271#30224271)
    # 'echo q | htop -C | aha --line-fix | html2text -width 999 | grep -v "F1Help\|xml version=" > ~/htop-output01.txt'

# Other GUI software
    # brave-browser gns3-gui IDA imhex obsidian
