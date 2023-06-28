#!/bin/bash


# WIP -- USE WITH CAUTION!
# TODO: meet dependencies, error-handling and adapt to given distro

# -----------------------

# https://tldp.org/LDP/abs/html/index.html
# https://www.cyberciti.biz/tips/bash-shell-parameter-substitution-2.html

# This script should be run via curl --TRYNA REPLICATE OMZ-- :
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# -----------------------

# cd $HOME
# read -p "Let's clone the dotfiles repo. You want them wallpapers too? (y/n) " img
# if [[ $img == "n" ]]; then
#     git clone --depth 1 --filter=blob:none --sparse https://github.com/pabloqpacin/dotfiles.git
#     cd <repository>
#     git sparse-checkout init --cone
#     git sparse-checkout add <excluded_directory_1>
#     git sparse-checkout add <excluded_directory_2>
#     git checkout
# elif [[ $REPLY == "y" ]]; then
#     git clone https://github.com/pabloqpacin/dotfiles

# git clone --filter=blob:none --no-checkout https://github.com/pabloqpacin/dotfiles

# -----------------------


# Check if location already exists
DOTFDIR="${DOTFDIR:-$HOME/dotfiles}"

# Repo info
REPO=${REPO:-pabloqpacin/dotfiles}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}
BRANCH=${BRANCH:-main}

# Clone the thing -- avoiding username+passwd prompt
git init --quiet "$DOTFDIR" && cd "$DOTFDIR" \
  && git config core.eol lf \
  && git config core.autocrlf false \
  && git config fsck.zeroPaddedFilemode ignore \
  && git config fetch.fsck.zeroPaddedFilemode ignore \
  && git config receive.fsck.zeroPaddedFilemode ignore \
  && git config dotfiles.remote origin \
  && git config dotfiles.branch "$BRANCH" \
  && git remote add origin "$REMOTE" \
  && git fetch origin \
  && git checkout -b "$BRANCH" "origin/$BRANCH" || {
    [ ! -d "$DOTFDIR" ] || {
      cd -
      rm -rf "$DOTFDIR" 2>/dev/null
    }
    fmt_error "git clone of dotfiles repo failed"
    exit 1
  }
  cd -
  echo "dotfiles clone successful"