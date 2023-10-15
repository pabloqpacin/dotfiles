#!/bin/bash

###
  # Script 'Ubuntu_BASE.sh' v.1.0 by @pabloqpacin
  #
  # Run this on any fresh Ubuntu or Pop!_OS machine (VM or else)
  # curl https://raw.githubusercontent.com/pabloqpacin/dotfiles/main/scripts/setup/Ubuntu-BASE.sh -o setup.sh && \
  #   chmod +x setup.sh && ./setup.sh
  #
  # TODO: sudo apt install virtualbox-dkms --no-install-recommends
###

################################################################################
#                                  FUNCTIONS                                   # 
################################################################################

function log_df {
    date >> $df_log
    # dpkg -l .. apt list --installed .. snap list .. flatpak list .. cargo install --list .. python? .. npm?
    df -h >> $df_log
    echo -e "\n" >> $df_log
}

function secs_to_mins {
    local total_seconds="$1"
    local minutes=$((total_seconds / 60))
    local seconds=$((total_seconds % 60))
    end_time_minutes="$minutes:$seconds"
}

function system_update {
    if [ ! -e "/etc/apt/apt.conf.d/99show-versions" ]; then
        echo 'APT::Get::Show-Versions "true";' | sudo tee /etc/apt/apt.conf.d/99show-versions
    fi
    sudo apt-get update && \
      sudo apt-get full-upgrade -y && \
      sudo apt-get autoremove -y && \
      sudo apt-get autoclean -y
}

function base_apt_packages {
    $sa_install neofetch --no-install-recommends
    $sa_install build-essential
    $sa_install curl git openssh-server wget    # net-tools
    $sa_install devilspie grc ipcalc nmap ripgrep tldr tmux zsh
    if [[ ! -d $HOME/.local/share/tldr ]]; then
        tldr --update
    fi
}

function install_cheat {
    if ! command -v cheat &>/dev/null; then
        echo -e "\n${YELLOW}########## Installing ${RED}${BOLD}Cheat${RESET}${YELLOW} (confirm '${RED}Y${RESET}${YELLOW}' prompts) ####################${RESET}"
        cd /tmp \
            && wget https://github.com/cheat/cheat/releases/download/4.4.0/cheat-linux-amd64.gz \
            && gunzip cheat-linux-amd64.gz \
            && chmod +x cheat-linux-amd64 \
            && sudo mv cheat-linux-amd64 /usr/local/bin/cheat \
            && cd $HOME
        cheat
    else
        echo -e "\n${YELLOW}########## ${GREEN}${BOLD}Cheat${RESET}${YELLOW} is already installed ##########${RESET}"
    fi
}

function install_rust_tools {
    if ! command -v cargo &>/dev/null; then
        echo -e "\n${YELLOW}########## Installing ${RED}${BOLD}Rust Toolchain${RESET}${YELLOW} (accept '${RED}default${RESET}${YELLOW}') ####################${RESET}"
        # read -p "Select 'default' if prompted. The script will terminate soon after, please run it again. " null
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        $HOME/.cargo/bin/cargo install bat bottom eza git-delta zoxide
    else
        echo -e "\n${YELLOW}########## Installing ${RED}${BOLD}Rust pkgs${RESET}${YELLOW} ####################${RESET}"
        $HOME/.cargo/bin/cargo install bat bottom eza git-delta zoxide
    fi
}

function install_vscodium {
    if ! command -v codium &>/dev/null; then
        echo -e "\n${YELLOW}########## Installing ${RED}${BOLD}VSCodium${RESET}${YELLOW} ####################${RESET}"
        wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
            | gpg --dearmor \
            | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
        echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
            | sudo tee /etc/apt/sources.list.d/vscodium.list
        $sa_update && $sa_install codium
    else
        echo -e "\n${YELLOW}########## ${GREEN}${BOLD}VSCodium${RESET}${YELLOW} is already installed ##########${RESET}"
    fi
}

function install_brave {
    if ! command -v brave-browser &>/dev/null; then
        echo -e "\n${YELLOW}########## Installing ${RED}${BOLD}Brave${RESET}${YELLOW} ####################${RESET}"
        sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
            https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] \
            https://brave-browser-apt-release.s3.brave.com/ stable main" \
            | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
        $sa_update && $sa_install brave-browser
    else
        echo -e "\n${YELLOW}########## ${GREEN}${BOLD}Brave${RESET}${YELLOW} is already installed ##########${RESET}"
    fi
}

function install_alacritty {
    if ! command -v alacritty &>/dev/null; then
        echo -e "\n${YELLOW}########## Installing ${RED}${BOLD}Alacritty${RESET}${YELLOW} ####################${RESET}"
        sudo add-apt-repository ppa:aslatter/ppa -y
        $sa_update && $sa_install alacritty
    else
        echo -e "\n${YELLOW}########## ${GREEN}${BOLD}Alacritty${RESET}${YELLOW} is already installed ##########${RESET}"
    fi
}

function install_firacode_nerdfont {
    if [[ ! -d /usr/share/fonts/FiraCodeNerd ]]; then
        echo -e "\n${YELLOW}########## Installing ${RED}${BOLD}FiraCode Nerd Font${RESET}${YELLOW} ####################${RESET}"
        wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip \
            || curl -O -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip
        sudo unzip ~/FiraCode.zip -d /usr/share/fonts/FiraCodeNerd
        rm ~/FiraCode.zip
        fc-cache -fv
    else
        echo -e "\n${YELLOW}########## ${GREEN}${BOLD}FiraCode${RESET}${YELLOW} is already installed ##########${RESET}"
        # fc-cache; fc-list | grep "FiraCode" | head -n 1
    fi
}

function install_powershell {
    if ! command -v pwsh &>/dev/null; then
        echo -e "\n${YELLOW}########## Installing ${RED}${BOLD}Powershell${RESET}${YELLOW} ####################${RESET}"
        $sa_update && $sa_install wget apt-transport-https software-properties-common
        wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
        sudo dpkg -i packages-microsoft-prod.deb
        rm packages-microsoft-prod.deb
        $sa_update && $sa_install powershell
    else
        echo -e "\n${YELLOW}########## ${GREEN}${BOLD}Powershell${RESET}${YELLOW} is already installed ##########${RESET}"
    fi
}

# function python_and_go {
#     # foo    
# }

function build_neovim {
    if ! command -v nvim &>/dev/null; then
        echo -e "\n${YELLOW}########## Building ${RED}${BOLD}Neovim${RESET}${YELLOW} ####################${RESET}"
        $sa_install build-essential cmake gettext ninja-build unzip
        git clone --depth 1 https://github.com/neovim/neovim.git
        cd neovim && make CMAKE_BUILD_TYPE=Release      # RelWithDebInfo OK too
        sudo make install
        cd $HOME && rm -rf neovim
    else
        echo -e "\n${YELLOW}########## ${GREEN}${BOLD}Neovim${RESET}${YELLOW} is already installed ##########${RESET}"
    fi
}

# function setup_neovim {
#     # foo
# }

function symlink_dotfiles {
    git clone --depth 1 https://github.com/pabloqpacin/dotfiles
    zoxide add dotfiles
    ln -s ~/dotfiles/.gitconfig ~/
    # array + for pkg + if command
    # ln -s ~/dotfiles/.config/lf ~/.config
    ln -s ~/dotfiles/.config/bat ~/.config
    ln -s ~/dotfiles/.config/btop ~/.config
    ln -s ~/dotfiles/.config/tmux ~/.config
    ln -s ~/dotfiles/.config/bottom ~/.config
    ln -s ~/dotfiles/.config/alacritty ~/.config
    ln -s ~/dotfiles/.config/powershell ~/.config
    rm ~/.config/VSCodium/User/settings.json && \
      ln -s ~/dotfiles/.config/code/User/settings.json ~/.config/VSCodium/User
    # source ~/dotfiles/scripts/setup/cheat_symlink.sh
    # SHELL: bash or zsh config
        # profile ...
    # devilspie bs
}

function install_docker {
    if ! command -v docker &>/dev/null; then
        echo -e "\n${YELLOW}########## Installing ${RED}${BOLD}Docker${RESET}${YELLOW} ####################${RESET}"
        # https://docs.docker.com/desktop/install/ubuntu/
        $sa_update
        $sa_install ca-certificates curl gnupg
        sudo install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        sudo chmod a+r /etc/apt/keyrings/docker.gpg
        echo \
        "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        $sa_update
        $sa_install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        # systemctl --user start docker-desktop || systemctl --user enable docker-desktop
        # docker compose version; docker --version; docker version
        # sudo docker run hello-world
        # sudo usermod -aG docker $USER
        wget https://desktop.docker.com/linux/main/amd64/docker-desktop-4.24.2-amd64.deb
        $sa_update
        $sa_install ./docker-desktop-*.deb
        rm docker-desktop-*
    else
        echo -e "\n${YELLOW}########## ${GREEN}${BOLD}Docker${RESET}${YELLOW} is already installed ##########${RESET}"
    fi
}


################################################################################
#                                   RUNTIME                                    # 
################################################################################

# xset s off        # Turn off screen saver
# xset -dpms        # Turn off power management

start_time=$SECONDS
df_log='/tmp/base_df.log'

RESET='\e[0m'
BOLD='\e[1m'
RED='\e[31m'
CYAN='\e[36m'
GREEN='\e[32m'
YELLOW='\e[33m'

sa_install=""
sa_update="sudo apt-get update"
# super_up='sudo apt-get update && \
#       sudo apt-get full-upgrade -y && \
#       sudo apt-get autoremove -y && \
#       sudo apt-get autoclean -y'

echo -e "\n${CYAN}### Logging ${RED}${BOLD}STARTING${RESET}${CYAN} disk usage to '${RED}${BOLD}$df_log${RESET}${CYAN}' ###${RESET}"
log_df

echo -e "
This script will install these packages and their dependencies in order:
- neofetch
- curl git openssh-server wget
- build-essential (binutils g++ gcc make manpages-dev)
- devilspie grc ipcalc nmap ripgrep tldr tmux zsh
- cheat
- rust toolchain (cargo rust-std rustc)
- bat bottom eza git-delta zoxide
- vscodium
- brave
- alacritty (...)
- firacode nerd font
- neovim
- # python3 python3-venv
- # nvm node npm
- # go lf # cheat
- powershell
- Docker
"

# echo -e "\nYou can have all 'apt-get install' prompts accepted by default
# or instead enter Y or N interactively for each prompt.\n"

# read -p "Do you want to skip all 'sudo apt-get install <pkg>' prompts? [Y/n] " opt
read -p "Do you want to skip all 'sudo apt-get install <package>' prompts?
(You'll need to press ENTER for the Rust Toolchain regardless). [Y/n] " opt
if [[ $opt == "Y" || $opt == "y" || $opt = "" ]]
    then sa_install="sudo apt-get install -y"
    else sa_install="sudo apt-get install"
fi

echo ""
system_update
base_apt_packages
install_cheat
install_rust_tools
install_vscodium
install_brave
install_alacritty
install_firacode_nerdfont
install_powershell
build_neovim
# setup_neovim
# install_docker
    # # IF VM!!!
    #     VBoxManage modifyvm UbuntuClient --nested-hw-virt on
# # python
# # go
# symlink_dotfiles

echo -e "\n${CYAN}### Logging ${RED}${BOLD}FINAL${RESET}${CYAN} disk usage to '${RED}${BOLD}$df_log${RESET}${CYAN}' ###${RESET}"
log_df

end_time=$((SECONDS - start_time))
secs_to_mins $end_time
# echo "Script execution time: $end_time seconds, ($end_time_minutes minutes)."
echo -e "\n${GREEN}# Script execution time: ${RED}${BOLD}$end_time${RESET}${GREEN} seconds, (${RED}${BOLD}$end_time_minutes${RESET}${GREEN} minutes). #${RESET}\n"

# xset s on         # Turn on screen saver
# xset +dpms        # Turn on power management
