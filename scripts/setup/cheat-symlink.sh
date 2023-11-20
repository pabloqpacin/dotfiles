#!/bin/bash

cheatpath="$HOME/.config/cheat"
dotpath="$HOME/dotfiles/.config/cheat"

if command -v eza &>/dev/null; then
    print="eza --icons -laI .git --no-user --no-permissions --no-filesize --git -TL 2"
elif command -v exa &>/dev/null; then
    print="exa --icons -laI .git --no-user --no-permissions --no-filesize --git -TL 2"
elif command -v tree &>/dev/null; then
    print="tree -L 2"
else
    print="ls -l"
fi


if [ -L $cheatpath/conf.yml ]; then
    echo "It seems there's already some symlinks at '~/.config/cheat'. Exiting..."
    exit 1
else
    echo -e "This is '~/.config/cheat' BEFORE the script:"
    $print $cheatpath

    rm $cheatpath/conf.yml &&
        ln -s $dotpath/conf.yml $cheatpath/

    rmdir $cheatpath/cheatsheets/personal &&
        ln -s $dotpath/cheatsheets/wip $cheatpath/cheatsheets/ &&
        ln -s $dotpath/cheatsheets/personal $cheatpath/cheatsheets/

    echo -e "\nThis is '~/.config/cheat' AFTER the script:"
    $print $cheatpath
fi
