#!/usr/bin/env bash

# ----
# sudo: command not found -- EVERYTHING AS ROOT
# ----

# in="apt-get install"

# define_variables(){
#     if true; then
#         in="apt-get install -y"
#     fi
# }

define_repositories(){
    # Solucionar problemas con los repositorios para las actualizaciones (enterprise VS free)
    sed -i '/enterprise/s/^/# /' /etc/apt/sources.list.d/ceph.list
    sed -i '/enterprise/s/^/# /' /etc/apt/sources.list.d/pve-enterprise.list

    # https://pve.proxmox.com/wiki/Package_Repositories#sysadmin_no_subscription_repo
    {
        echo "deb http://ftp.debian.org/debian bookworm main contrib"
        echo "deb http://ftp.debian.org/debian bookworm-updates main contrib"
        echo ""
        echo "# Proxmox VE pve-no-subscription repository provided by proxmox.com,"
        echo "# NOT recommended for production use"
        echo "deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription"
        echo ""
        echo "# security updates"
        echo "deb http://security.debian.org/debian-security bookworm-security main contrib"
    } | tee /etc/apt/sources.list
}

apt_base(){
    apt-get update && apt-get install \
        git nmap \
        bat btop exa lf
}

clone_dotfiles(){
    # https://stackoverflow.com/questions/20370294/git-could-not-resolve-host-github-com-error-while-cloning-remote-repository-in
    git config --global --unset http.proxy
    git clone https://github.com/pabloqpacin/dotfiles "${HOME}/dotfiles"

    # # zsh     # NOPE
    # sed -i 's/eza/exa/g' ~/dotfiles/zsh/aliases.zsh

    ln -s ~/dotfiles/.config/btop ~/config
}

# bat 0.22.1    -- no MAN
install_bat(){
    ${in} bat
    mv "$(command -v batcat)" /usr/bin/bat
    ln -s ~/dotfiles/.config/bat ~/config
}

setup_lf(){
    ${in} lf
    ln -s ~/dotfiles/.config/lf ~/.config
    sed -i '/set icons/^/# /' ~/.config/lf/lfrc
    sed -i '/cursorpreviewfmt/^/# /' ~/.config/lf/lfrc
}

# some_bs(){
#     git clone ...
# }

clone_dotfiles_symlinks(){
    ln -s ~/dotfiles/.config/bat ~/.config
    ln -s ~/dotfiles/.config/tmux ~/.config
}

# setup_zsh(){ }        # NOPE

# ===

install_btop
install_bat
install_lf


# ===

# # ln -s ~/dotfiles/.config/nvim ~/.config       # NOPE

    # if ! command -v bat &>/dev/null && command -v batcat &>/dev/null; then
    #
# ---
#
# https://github.com/tteck/Proxmox/blob/main/misc/post-pve-install.sh
# https://tteck.github.io/Proxmox/
# https://www.youtube.com/watch?v=_xcsuPmrFWA
# https://www.youtube.com/watch?v=d8eAimdNAV0
