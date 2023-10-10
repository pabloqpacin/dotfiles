#!/bin/bash

dotpath="$HOME/dotfiles/.config/cheat"
cheatpath="$HOME/.config/cheat"

if command -v eza &>/dev/null
    then print="eza --icons -laI .git --no-user --no-permissions --no-filesize --git -TL 2"
  elif command -v tree &>/dev/null
    then print="tree -L 2"
  else print="ls -l"
fi

echo -e "This is '~/.config/cheat' BEFORE the script:"
$print $cheatpath

rm $cheatpath/conf.yml
ln -s $dotpath/conf.yml $cheatpath/

rmdir $cheatpath/cheatsheets/personal
ln -s $dotpath/cheatsheets/personal $cheatpath/cheatsheets/
ln -s $dotpath/cheatsheets/wip $cheatpath/cheatsheets/

echo -e "\nThis is '~/.config/cheat' AFTER the script:"
$print $cheatpath
