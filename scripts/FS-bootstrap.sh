#!/usr/bin/env bash

# src: https://github.com/pabloqpacin/dotfiles/docs/FS-bootstrap_sh.png
# vid: https://youtu.be/r_MpUP6aKiQ&ab_channel=Fireship

# ...
cd "$(dirname "${BASH_SOURCE}")";

# is there a Git repo already?
git pull origin main;

# wtf all function components
function doIt() {
    rsync --exclude ".git/" \
        --exclude ".DS_Store" \
        --exclude ".osx" \
        --exclude "bootstrap.sh" \
        --exclude "README.md" \
        --exclude "LICENSE-MIT.txt" \
        -avh --no-perms . ~;
    source ~/bash_profile;
}

# what was supposed to be the Argument for $1?
# what is the '-o'??
# what is the '-n 1'?
if [ "$1" == "--force" -o "$1" == "-f" ];
    then doIt;
else
    read -p "This may overwrite existing files in your home
directory. Are you sure? (y/n) " -n 1;
    echo "";
# notice '^[Yy]$' regarding READ
    if [[ $REPLY =~ ^[Yy]$ ]];
        then doIt;
    fi;
fi;

# wtf unset
unset doIt;