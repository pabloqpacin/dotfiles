#!/usr/bin/env bash

if [[ ! -d ~/dotfiles/.config/yazi/flavors/onedark.yazi ]]; then
    git clone --depth=1 https://github.com/BennyOe/onedark.yazi.git \
        ~/dotfiles/.config/yazi/flavors/onedark.yazi
fi

# if [ ! -d ~/dotfiles/.config/yazi/plugins/git-status.yazi ]; then
#     git clone --depth=1 https://github.com/DreamMaoMao/git-status.yazi.git \
#         ~/dotfiles/.config/yazi/plugins/git-status.yazi
# fi
