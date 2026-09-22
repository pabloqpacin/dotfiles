#!/bin/bash

### USE WITH CAUTION -- Tested on PopOS to tweak the root user
home_user='/home/pabloqpacin'

## Become root
if [[ ${HOME} != "/root" ]]
    then echo "ye aint root -- run with 'sudo' or do 'sudo su' before execution" && exit 1
    else echo "yer root aye"
fi

## Symlink .vimrc for a decent Neovim experiences
#mkdir -p $HOME/.config/nvim
#ln -s $home_user/dotfiles/.vimrc $HOME/.config/nvim/init.vim
ln -s "${home_user}/dotfiles/.vimrc" "${HOME}/"

## Add cargo & go binaries to Root's $PATH
echo '
paths_to_add=(
    "$home_user/go/bin"
    "$home_user/.cargo/bin"
)

for path in "${paths_to_add[@]}"; do
    if [[ ":$PATH:" != *":$path:"* ]]; then
        export PATH="$PATH:$path"
    fi
done
' >> "${HOME}/rootweaks.sh"
echo -e "\nsource ${HOME}/rootweaks.sh" >> "${HOME}/.bashrc"

# Symlink some BS
ln -s "${home_user}/dotfiles/.config/lf" "${HOME}/.config"
ln -s "${home_user}/dotfiles/.config/bat" "${HOME}/.config"
ln -s "${home_user}/dotfiles/.config/tmux" "${HOME}/.config"


#### TODO: conditional error checking
#### TODO: prompt for $home_user...
