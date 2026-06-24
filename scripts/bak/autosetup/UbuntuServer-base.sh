#!/usr/bin/env bash

echo -e "\n----################################################################----"
echo -e   "#######~~~~{     UbuntuServer-base v1.3  by @pabloqpacin    }~~~~#######"
echo -e "----################################################################----\n"

### Tested successfully on Ubuntu 22.04 (fresh VM):
# bash -c "$(curl -fsSL https://raw.githubusercontent.com/pabloqpacin/dotfiles/main/scripts/autosetup/UbuntuServer-base.sh)"

### NOTE: run as normal user, not tested as root


set_variables() {
    read -r -p "Skip all 'sudo apt-get install <pkg>' prompts? [y/N] " opt
    case ${opt} in
        'Y'|'y') sa_install="sudo apt-get install -y" ;;
              *) sa_install="sudo apt-get install" ;;
    esac
    current_shell=$(echo "${SHELL}" | awk -F '/' '{print $NF}')
    sa_update="sudo apt-get update"
}

update_system() {
    if [[ ! -e "/etc/apt/apt.conf.d/99show-versions" ]]; then
        echo 'APT::Get::Show-Versions "true";' | sudo tee /etc/apt/apt.conf.d/99show-versions
    fi
    ${sa_update} && sudo apt-get upgrade -y &&
        sudo apt-get autoremove -y &&
        sudo apt-get autoclean -y
}

install_base_apt() {

    ${sa_install} neofetch --no-install-recommends
    ${sa_install} curl git openssh-server wget net-tools
    ${sa_install} btop fzf grc ipcalc jq mycli ncat nmap ripgrep tldr tmux tree
    ${sa_install} bat && sudo mv /usr/bin/batcat /usr/bin/bat
    # $sa_install python3-pip python3-venv --no-install-recommends

    if [[ ! -d ~/.local/share/tldr ]]; then
        mkdir -p ~/.local/share &>/dev/null
        tldr --update
    fi
}

install_base_dpkg(){

    lf_pkg='lf-linux-amd64.tar.gz'
    wget -q "https://github.com/gokcehan/lf/releases/download/r31/${lf_pkg}" && \
        tar -zxvf "${lf_pkg}" && \
        sudo mv lf /usr/bin/lf && \
        rm "${lf_pkg}"

    delta_pkg='git-delta_0.16.5_amd64.deb'
    wget -q "https://github.com/dandavison/delta/releases/download/0.16.5/${delta_pkg}" && \
        sudo dpkg -i "${delta_pkg}" && \
        rm "${delta_pkg}"
}

clone_symlink_dotfiles() {
    if [[ ! -d ~/dotfiles ]]; then
        git clone --depth 1 https://github.com/pabloqpacin/dotfiles ~/dotfiles; fi

    if [[ ! -d ~/.config ]]; then
        mkdir ~/.config &>/dev/null; fi

    if true; then
        sudo mkdir /root/.config &>/dev/null; fi

    if [[ ! -L ~/.myclirc ]]; then
        ln -s ~/dotfiles/.myclirc ~/; fi

    if [[ ! -L ~/.config/bat ]]; then
        sed -i 's/OneHalfDark/Coldark-Dark/' ~/dotfiles/.config/bat/config
        ln -s ~/dotfiles/.config/bat ~/.config
        sudo ln -s ~/dotfiles/.config/bat /root/.config
    fi

    # if [ ! -L ~/.config/btop ]; then
    #     ln -s ~/dotfiles/.config/btop ~/.config; fi

    if [[ ! -L ~/.config/lf ]]; then
        ln -s ~/dotfiles/.config/lf ~/.config
        sudo ln -s ~/dotfiles/.config/lf /root/.config
    fi
    if [[ ! -L ~/.config/tmux ]]; then
        ln -s ~/dotfiles/.config/tmux ~/.config
    fi
    if [[ ! -L ~/.vimrc ]]; then
        if [[ -e ~/.vimrc ]]; then mv ~/.vimrc{,.bak}; fi
        sed -i "s/'nvim'/'vim'/g" ~/dotfiles/.zshrc
        ln -s ~/dotfiles/.vimrc ~/
        sudo ln -s ~/dotfiles/.vimrc /root/
    fi
    if [[ ! -L ~/.gitconfig ]]; then
        sed -i '/github/d' ~/dotfiles/.gitconfig && 
        sed -i "s/pabloqpacin/${USER}/" ~/dotfiles/.gitconfig
        ln -s ~/dotfiles/.gitconfig ~/
    fi
    if command -v nvim &>/dev/null; then
        sed -i "s/'vim'/'nvim'/g" ~/dotfiles/.zshrc
        ln -s ~/dotfiles/.config/nvim ~/.config
        sudo mkdir -p /root/.config/nvim &&
        sudo ln -s ~/dotfiles/.vimrc /root/.config/nvim/init.vim
        # still funky, no colors in UbuntuBox... kinda crap
    fi
}

setup_zsh() {
    ${sa_update} && ${sa_install} zsh
    
    if [[ ! -d ~/.oh-my-zsh ]]; then
        yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
        bash "${HOME}/dotfiles/scripts/setup/omz-msg_random_theme.sh"
    fi
    
    if [[ ${current_shell} != 'zsh' ]]; then
        sudo chsh -s "$(command -v zsh)" "${USER}" || true
    fi
    
    if [[ ! -L ~/.zshrc ]]; then
        mv ~/.zshrc{,.bak} &&
        ln -s ~/dotfiles/.zshrc ~/
    fi
    
    if [[ ! -d ~/dotfiles/zsh/plugins/zsh-autosuggestions || ! -d ~/dotfiles/zsh/plugins/zsh-syntax-highlighting ]]; then
        bash "${HOME}/dotfiles/zsh/plugins/clone-em.sh"
    fi
}

# install_base_go() {
#     $sa_update && $sa_install golang
#
#     source ~/dotfiles/zsh/golang.zsh
#
#     # if ! command -v fzf &>/dev/null; then
#     #     go install github.com/junegunn/fzf@latest; fi
#
#     # if ! command -v lf &>/dev/null; then
#     #     go install github.com/gokcehan/lf@latest; fi
#
#     if ! command -v cheat &>/dev/null; then
#         go install github.com/cheat/cheat/cmd/cheat@latest; fi
#
#     if [ ! -L ~/.config/cheat/conf.yml ]; then
#         yes | cheat
#         bash -x $HOME/dotfiles/scripts/setup/cheat-symlink.sh
#     fi
# }

install_docker() {

    if ! command -v docker &>/dev/null; then
        ${sa_update} && ${sa_install} ca-certificates curl gnupg  # gnome-terminal
            sudo install -m 0755 -d /etc/apt/keyrings
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg || true
            sudo chmod a+r /etc/apt/keyrings/docker.gpg
        echo \
            "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
            $(. /etc/os-release && echo "${VERSION_CODENAME}") stable" | \
            sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        ${sa_update} && ${sa_install} docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            sudo systemctl enable --now docker
            sudo usermod -aG docker "${USER}"
            # newgrp docker
    fi
}

# Commit nvim-dap OUT
setup_nvim(){

    if ! command -v nvim &>/dev/null; then
        ${sa_update} && ${sa_install} build-essential cmake gettext ninja-build unzip
        cd "${HOME}" && git clone --depth 1 https://github.com/neovim/neovim.git &&
            cd neovim && make CMAKE_BUILD_TYPE=Release &&
            sudo make install && cd "${HOME}" && rm -rf neovim
    fi

    if ! command -v npm &>/dev/null; then
        if [[ ! -s "${HOME}/.nvm/nvm.sh" ]]; then
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash || true
        fi
        if ! command -v node &>/dev/null && ! command -v npm &>/dev/null; then
            [[ -s "${HOME}/.nvm/nvm.sh" ]] && \. "${HOME}/.nvm/nvm.sh"
            nvm install node
        fi
    fi

    if [[ ! -d ~/.local/share/nvim/site/pack/packer/start/packer.nvim ]]; then
        git clone --depth 1 https://github.com/wbthomason/packer.nvim \
            ~/.local/share/nvim/site/pack/packer/start/packer.nvim
    fi

    if [[ ! -L ~/.config/nvim ]]; then
        sudo mkdir -p /root/.config/nvim &&
        sudo ln -s ~/dotfiles/.vimrc /root/.config/nvim/init.vim

        ln -s ~/dotfiles/.config/nvim ~/.config
        cd ~/.config/nvim && {
            read -r -p "Pasa los mensajes de error con <INTRO>, luego escribe :so <INTRO>, :PackerSync <INTRO> y :qa <INTRO> " null
            nvim lua/pabloqpacin/packer.lua
            read -r -p "Pasa los mensajes de error con <INTRO>, luego escribe :Mason <INTRO> y :qa <INTRO> " null
            nvim after/plugin/lsp.lua
            cd "${HOME}" || true
            unset "${null}"
        }
    fi

}

# ---

# echo "$(dpkg -l | wc -l) paquetes intalados" >> /tmp/install.log && \
# df -h | grep '/$' >> /tmp/install.log

set_variables

update_system
install_base_apt
install_base_dpkg       # git-delta lf

clone_symlink_dotfiles
setup_zsh

# install_base_go         # cheat fzf   # lf
install_docker

opt_nvim=''
while [[ ${opt_nvim} != 'y' && ${opt_nvim} != 'n' ]]; do
    read -r -p "Setup neovim [y/n]? " opt_nvim
done
if [[ ${opt_nvim} == 'y' ]]; then
    setup_nvim
fi


echo "" && neofetch && sudo grc docker ps -a && echo "" && df -h | grep -e '/$' -e 'Mo'
[[ -f /var/run/reboot-required ]] && echo -e "\nKindly reboot.\n"


# ---

# # Neovim: change onedark for rosepine
# NVIM="$HOME/.config/nvim"
# PACKER="$NVIM/lua/pabloqpacin/packer.lua"
# PLUGINS="$NVIM/after/plugin"
# nvim_sed_packer
# nvim_move_colordirs

# nvim_sed_packer() {
#     sed .config/nvim/lua/pabloqpacin/packer.lua
# }

# nvim_move_colordirs() {
#     mv $PLUGINS/colors-onedark.lua $PLUGINS/colors-onedark.lua.bak
#     mv $PLUGINS/colors-rosepine.lua.bak $PLUGINS/colors-rosepine.lua
# }


# # TO DO BEFOREHAND: sudo su && passwd --> to login directly as root :D

    # # No exa (no nerdfont) in server... but what if ssh? Mm just not that important imho
    # if command -v exa &>/dev/null; then
    #     sed -i 's/eza/exa/g' ~/dotfiles/zsh/aliases.zsh; fi
