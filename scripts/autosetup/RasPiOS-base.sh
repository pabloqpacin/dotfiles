#!/bin/bash

echo -e "\n-----#################################################################-----"
echo -e "#########~~~~~{     RasPiOS-base v0.1.4  by @pabloqpacin    }~~~~~#########"
echo -e "-----#################################################################-----\n"

### Good for Raspberry Pi OS Lite (64-bit) on Raspberry Pi 5
# wget https://raw.githubusercontent.com/pabloqpacin/dotfiles/main/scripts/autosetup/RasPiOS-base.sh &&
# chmod +x RaspiOS-base.sh && 
# bash -x $_

### NOTES:
# - record session + monitor
# - log disk space
# - tshark

# - nvim telescope
# - no docker-desktop
# - no github ssh auth
# - no brave because TTY (no DE/WM)

# - overclocking 3GHz: https://www.youtube.com/watch?v=K6dWE2x4viw (@ETAPrime)

########## VARIABLES ##########

should_reboot=0

sa_update="sudo apt-get update"
sa_install="sudo apt-get install"

current_shell=$(echo $SHELL | awk -F '/' '{print $NF}')
device_model=''

########## FUNCTIONS ##########

get_hardware() {

    if [ -e /sys/firmware/devicetree/base/model ]; then
        device_model=$(tr -d '\0' < /sys/firmware/devicetree/base/model)
    elif [ -e /sys/devices/virtual/dmi/id/product_name ]; then
        device_model=$(tr -d '\0' < /sys/devices/virtual/dmi/id/product_name)
    fi

    case $(echo "$device_model" | awk '{print $1, $2, $3}') in
        'Raspberry Pi 5') echo -e "Detected hardware: $device_model\n" ;;
        *) echo "Unsupported hardware ($device_model). Exiting..." && exit 1 ;;
    esac

}

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

    if ! sudo apt-get install build-essential -y --simulate 2>&1 | grep -q 'is already the newest version'; then
        $sa_install build-essential && should_reboot=1
    fi
   
    $sa_install libssl-dev sysbench
    $sa_install curl git openssh-server wget
    $sa_install neofetch --no-install-recommends
    $sa_install btop ccze grc ipcalc nmap ripgrep tldr tmux tree 
    $sa_install python3-pip python3-venv --no-install-recommends
    $sa_install mycli --no-install-recommends   # mariadb-client default-mysql-client

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
    
    if [[ $current_shell != 'zsh' ]]; then
        sudo chsh -s $(which zsh) $USER; fi
    
    if [ ! -L ~/.zshrc ]; then
        mv ~/.zshrc{,.bak} &&
        ln -s ~/dotfiles/.zshrc ~/
    fi
    
    if command -v zoxide &>/dev/null; then
        zoxide add dotfiles; fi

    if [ ! -d ~/dotfiles/zsh/plugins ]; then
        mkdir ~/dotfiles/zsh/plugins; fi
    
    if [ ! -d ~/dotfiles/zsh/plugins/zsh-autosuggestions ]; then
        git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions $HOME/dotfiles/zsh/plugins/zsh-autosuggestions; fi
    
    if [ ! -d ~/dotfiles/zsh/plugins/zsh-syntax-highlighting ]; then
        git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting $HOME/dotfiles/zsh/plugins/zsh-syntax-highlighting; fi

}

install_base_cargo() {

    if ! command -v cargo &>/dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    fi
    
    if ! command -v btm &>/dev/null; then
        curl -LO https://github.com/ClementTsang/bottom/releases/download/0.9.6/bottom_0.9.6_arm64.deb
        sudo dpkg -i bottom_0.9.6_arm64.deb && rm bottom_0.9.6_arm64.deb
    fi

    if ! command -v bat &>/dev/null || ! command -v eza &>/dev/null || ! command -v delta &>/dev/null || ! command -v zoxide &>/dev/null; then

        read -p "Build cargo packages [bat eza git-delta zoxide] if don't exist? [Y/n] (~10 min.) " opt      

        case $opt in 'Y' | 'y' | '')
            if ! command -v bat &>/dev/null; then $HOME/.cargo/bin/cargo install bat; fi
            if ! command -v eza &>/dev/null; then $HOME/.cargo/bin/cargo install eza; fi
            if ! command -v delta &>/dev/null; then $HOME/.cargo/bin/cargo install git-delta; fi
            if ! command -v zoxide &>/dev/null; then $HOME/.cargo/bin/cargo install zoxide; fi
            if ! command -v cargo install-update -a &>/dev/null; then $HOME/.cargo/bin/cargo install cargo-update; fi
        esac

    fi

    if [ ! -L ~/.config/bat ]; then
        ln -s ~/dotfiles/.config/bat ~/.config; fi

    if [ ! -L ~/.config/bottom ]; then
        ln -s ~/dotfiles/.config/bottom ~/.config; fi

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

setup_nvim__npm() {
    if [ ! -s "$HOME/.nvm/nvm.sh" ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash; fi
    
    if ! command -v node &>/dev/null && ! command -v npm &>/dev/null; then
        [ -s "$HOME/.nvm/nvm.sh" ] && \. "$HOME/.nvm/nvm.sh"
        nvm install node
    fi

    if ! command -v nvim &>/dev/null; then
        $sa_update && $sa_install build-essential cmake gettext ninja-build unzip && should_reboot=1
        cd $HOME && git clone --depth 1 https://github.com/neovim/neovim.git &&
            cd neovim && make CMAKE_BUILD_TYPE=Release &&
            sudo make install && cd $HOME && rm -rf neovim
    fi

    if [ ! -d ~/.local/share/nvim/site/pack/packer/start/packer.nvim ]; then
        git clone --depth 1 https://github.com/wbthomason/packer.nvim \
            ~/.local/share/nvim/site/pack/packer/start/packer.nvim; fi
    
    if [ ! -L ~/.config/nvim ]; then
        ln -s ~/dotfiles/.config/nvim ~/.config
        read -p "Skip messages with Enter, then do :so :PackerUpdate :qa ... " null
        nvim ~/.config/nvim/lua/pabloqpacin/packer.lua
    fi
        
}

# Docker as for Debian as per https://docs.docker.com/engine/install/raspberry-pi-os/
install_docker() {
    if ! command -v docker &>/dev/null; then
        # for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
        $sa_update && $sa_install ca-certificates curl gnupg &&
            sudo install -m 0755 -d /etc/apt/keyrings &&
            curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg &&
            sudo chmod a+r /etc/apt/keyrings/docker.gpg
        echo \
            "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
            "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
            sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        $sa_update && $sa_install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        should_reboot=1
    fi

    if ! getent group docker | grep -q "$USER"; then                            # if ! groups | grep "docker"; then
        sudo usermod -aG docker $USER && newgrp docker
        should_reboot=1
    fi

    # systemctl status docker; systemctl disable docker
}

setup_containers() {

    if ! command -v docker &>/dev/null; then
        return 1
    # else
    #     docker ps -a
    fi

    # if ! docker ps -a --format '{{.Names}}' | grep -q "portainer"; then
    #         # docker volume ls
    #     sudo docker run -d -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer-ce
    # fi

    # Update: should do Prometheus+Grafana with Docker Compose (via Portainer stack)

}

# setup_casaOS() { curl -fsSL https://get.casaos.io | sudo bash }
# setup_nixpkgs() {}

case_GUI(){

    sudo apt-get install alacritty grimshot
        # sleep 3 && grimshot save screen

    if [ ! -L ~/.config/alacritty ]; then
        ln -s ~/dotfiles/.config/alacritty ~/.config; fi

    if ! fc-fache -v | grep -q CascadiaCodeNerd; then
        mkdir ~/.fonts
        wget -o /tmp/CascadiaCode.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CascadiaCode.zip
        unzip /tmp/CascadiaCode.zip -d ~/.fonts/CascadiaCodeNerdFont
        fc-cache -fv
    fi

    # brave-browser ?
}


# fockedup(){
#     # obs-studio
#     # retroarch
# }


########### RUNTIME ###########

get_hardware

set_variables
update_system
install_base_apt
clone_dotfiles      # also symlinks: btop tmux

setup_zsh
install_base_cargo
install_base_go
setup_nvim__npm

install_docker
# setup_containers

case_GUI

if command -v neofetch &>/dev/null; then neofetch; fi

case $should_reboot in 1) echo -e "\nkindly reboot" ;; esac

# ==========x==========

# mv foo{,.bak}: This is a shell expansion syntax known as brace expansion.
# It generates a list of items by expanding the comma-separated values within the curly braces.
# In this case, it generates two items: an empty string (before the comma) and .bak (after the comma).

# check_commands() {
#     local commands=("bat" "eza" "delta" "zoxide")
#     for cmd in "${commands[@]}"; do
#         if ! command -v "$cmd" &>/dev/null; then
#             return 1  # Indicate failure if any command is not found
#         fi
#     done
#     return 0  # Indicate success if all commands are found
# }
#
# if check_commands
#     then bar  # All commands are available
#     else foo  # At least one command is not available
# fi

# sudo systemctl disable --now cups


# https://help.realvnc.com/hc/en-us/articles/14110635000221-Raspberry-Pi-5-Bookworm-and-RealVNC-Connect
# https://github.com/any1/wayvnc
