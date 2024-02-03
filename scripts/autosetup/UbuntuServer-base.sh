#!/bin/bash

echo -e "\n----################################################################----"
echo -e   "#######~~~~{     UbuntuServer-base v1.0  by @pabloqpacin    }~~~~#######"
echo -e "----################################################################----\n"

# TO DO BEFOREHAND: sudo su && passwd --> to login directly as root :D

########## VARIABLES ##########

sa_update="sudo apt-get update"
sa_install="sudo apt-get install"
current_shell=$(echo $SHELL | awk -F '/' '{print $NF}')

########## FUNCTIONS ##########

set_variables() {
    read -p "Do you want to skip all 'sudo apt-get install <package>' prompts? [y/N] " opt
    case $opt in 'Y' | 'y')
        sa_install="sudo apt-get install -y"
    esac
}

update_system() {
    if [ ! -e "/etc/apt/apt.conf.d/99show-versions" ]; then
        echo 'APT::Get::Show-Versions "true";' | sudo tee /etc/apt/apt.conf.d/99show-versions
    fi
    $sa_update && sudo apt-get upgrade -y &&
        sudo apt-get autoremove -y &&
        sudo apt-get autoclean -y
}


install_base_apt() {

    # if ! sudo apt-get install build-essential -y --simulate 2>&1 | grep -q 'is already the newest version'; then
    #     $sa_install build-essential && should_reboot=1
    # fi
   
    # $sa_install libssl-dev sysbench
    $sa_install curl git openssh-server wget
    $sa_install neofetch --no-install-recommends
    $sa_install btop grc ipcalc nmap ripgrep tldr tmux tree 
    $sa_install bat && sudo mv /usr/bin/batcat /usr/bin/bat
    # $sa_install python3-pip python3-venv --no-install-recommends
    # $sa_install mycli     # default-mysql-client mariadb-client

    if [ ! -d ~/.local/share/tldr ]; then
        mkdir -p ~/.local/share &>/dev/null
        tldr --update
    fi
}

clone_dotfiles() {
    if [ ! -d ~/dotfiles ]; then
        git clone --depth 1 https://github.com/pabloqpacin/dotfiles ~/dotfiles; fi
    
    if [ ! -d ~/.config ]; then
        mkdir ~/.config &>/dev/null; fi

    if [ ! -L ~/.gitconfig ]; then
        ln -s ~/dotfiles/.gitconfig ~/; fi

    if [ ! -L ~/.config/btop ]; then
        ln -s ~/dotfiles/.config/btop ~/.config; fi

    if [ ! -L ~/.config/tmux ]; then
        ln -s ~/dotfiles/.config/tmux ~/.config; fi

}

setup_zsh() {
    $sa_update && $sa_install zsh
    
    if [ ! -d ~/.oh-my-zsh ]; then
        yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        bash $HOME/dotfiles/scripts/setup/omz-msg_random_theme.sh
    fi
    
    # if [[ $current_shell != 'zsh' ]]; then
    #     sudo chsh -s $(which zsh) $USER; fi
    
    if [ ! -L ~/.zshrc ]; then
        mv ~/.zshrc{,.bak} &&
        ln -s ~/dotfiles/.zshrc ~/
    fi
    
    if [ ! -d ~/dotfiles/zsh/plugins ]; then
        mkdir ~/dotfiles/zsh/plugins; fi
    
    if [ ! -d ~/dotfiles/zsh/plugins/zsh-autosuggestions ]; then
        git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions $HOME/dotfiles/zsh/plugins/zsh-autosuggestions; fi
    
    if [ ! -d ~/dotfiles/zsh/plugins/zsh-syntax-highlighting ]; then
        git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting $HOME/dotfiles/zsh/plugins/zsh-syntax-highlighting; fi

}


install_base_go() {
    $sa_update && $sa_install golang

    source ~/dotfiles/zsh/golang.zsh

    if ! command -v fzf &>/dev/null; then
        go install github.com/junegunn/fzf@latest; fi
    
    if ! command -v lf &>/dev/null; then
        go install github.com/gokcehan/lf@latest; fi

    if [ ! -L ~/.config/lf ]; then
        ln -s ~/dotfiles/.config/lf ~/.config; fi

    if ! command -v cheat &>/dev/null; then
        go install github.com/cheat/cheat/cmd/cheat@latest; fi

    if [ ! -L ~/.config/cheat/conf.yml ]; then
        yes | cheat
        bash -x $HOME/dotfiles/scripts/setup/cheat-symlink.sh; fi

}

install_docker() {

    if ! command -v docker &>/dev/null; then
        $sa_update && $sa_install ca-certificates curl gnupg  # gnome-terminal
            sudo install -m 0755 -d /etc/apt/keyrings
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
            sudo chmod a+r /etc/apt/keyrings/docker.gpg
        echo \
            "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
            $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
            sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        $sa_update && $sa_install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            sudo usermod -aG docker $USER
            newgrp docker
    fi

}


# nvim_sed_packer() {
#     sed .config/nvim/lua/pabloqpacin/packer.lua
# }

# nvim_move_colordirs() {
#     mv $PLUGINS/colors-onedark.lua $PLUGINS/colors-onedark.lua.bak
#     mv $PLUGINS/colors-rosepine.lua.bak $PLUGINS/colors-rosepine.lua
# }

use_vim() {

    if [ ! -L ~/.vimrc ]; then
        ln -s ~/dotfiles/.vimrc ~/
    fi

    sed -i 's/nvim/vim/g' ~/.zshrc

}

########### RUNTIME ###########

set_variables

update_system
install_base_apt

clone_dotfiles      # also symlinks: btop tmux
setup_zsh

install_base_go
install_docker

use_vim

# # Neovim: change onedark for rosepine
# NVIM="$HOME/.config/nvim"
# PACKER="$NVIM/lua/pabloqpacin/packer.lua"
# PLUGINS="$NVIM/after/plugin"
# nvim_sed_packer
# nvim_move_colordirs

