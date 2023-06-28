#!/bin/bash

# WIP -- USE WITH CAUTION!
# TODO: meet dependencies, error-handling and adapt to given distro

# Install oh-my-zsh -- ... "" --unattended
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Clone tmux TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install nvm and node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
# source .zshrc
nvm install node
node install tldr
node install live-server

# Clone neovim
git clone --depth 1 https://github.com/neovim/neovim

# Clone packer
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
