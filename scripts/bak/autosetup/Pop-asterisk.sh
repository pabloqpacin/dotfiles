#!/usr/bin/env bash

echo -e "\n----################################################################----"
echo -e "#########~~~~~{     Pop-base v0.1  by @pabloqpacin    }~~~~~#########"
echo -e "----################################################################----\n"

# bash -c $(curl -fsSL "https://"")

set_variables() {
    read -r -p "Skip all 'apt install <package>' prompts? [y/N] " opt
    case ${opt} in
        'Y'|'y') sa_install="sudo apt-get install -y" ;;
              *) sa_install="sudo apt-get install" ;;
    esac
    sa_update="sudo apt-get update"
}

apt_update_install(){
    if [[ ! -e "/etc/apt/apt.conf.d/99show-versions" ]]; then
        echo 'APT::Get::Show-Versions "true";' | sudo tee /etc/apt/apt.conf.d/99show-versions
    fi

    ${sa_update} && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean

    # $sa_install build-essential
    ${sa_install} neofetch python3-pip python3-venv --no-install-recommends
    ${sa_install} curl git net-tools openssh-server wget wl-clipboard xclip xsel
    ${sa_install} bat eza flameshot fzf git-delta grc jq lf nmap ripgrep tmux tree
    # $sa_install btop devilspie ipcalc mycli

    if ! command -v bat &>/dev/null && command -v batcat &>/dev/null; then
        sudo mv "$(command -v batcat)" /usr/bin/bat || true
    fi

    if ! command -v tldr &>/dev/null; then
        read -r -p "Install tldr [y/N]? " opt_tldr
        if [[ ${opt_tldr} == 'y' ]]; then
            ${sa_install} tldr
            if [[ ! -d ~/.local/share ]]; then
                mkdir ~/.local/share
            fi
            tldr --update
        fi
    fi
}

install_rust_tools() {
    if ! command -v cargo &>/dev/null; then
        echo -e "\n${YELLOW}########## Installing ${RED}${BOLD}Rust Toolchain${RESET}${YELLOW} (accept '${RED}default${RESET}${YELLOW}') ####################${RESET}"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y || true
        echo -e "\n${YELLOW}########## Installing ${RED}${BOLD}Rust pkgs${RESET}${YELLOW} ####################${RESET}"
        "${HOME}/.cargo/bin/cargo" install bat bottom eza git-delta zoxide  # fd-find
    else
        echo -e "\n${YELLOW}########## Installing ${RED}${BOLD}Rust pkgs${RESET}${YELLOW} ####################${RESET}"
        "${HOME}/.cargo/bin/cargo" install bat bottom eza git-delta zoxide  # fd-find
        "${HOME}/.cargo/bin/cargo" install --locked yazi-fm
    fi
}

install_golang_tools() {    # Golang == zsh only atm
    if ! command -v go &>/dev/null; then
        echo -e "\n${YELLOW}########## Installing ${RED}${BOLD}Golang${RESET}${YELLOW} ####################${RESET}"
        cd /tmp \
            && wget -c https://golang.org/dl/go1.21.0.linux-amd64.tar.gz \
            && sudo rm -rf /usr/local/go \
            && sudo tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz  # \ && cd $HOME && source ~/dotfiles/zsh/golang.zsh &>/dev/null
        echo "
export GOPATH=\$HOME/go
export GOBIN=\$GOPATH/bin
if [[ ":\$PATH:" != *":\$GOBIN:"* ]]; then
    export PATH=\$PATH:\$GOBIN
    export PATH=\$PATH:/usr/local/go/bin
fi
" >> "${HOME}/.${current_shell}rc"
        echo -e "\n${YELLOW}########## Installing ${RED}${BOLD}Golang${RESET}${YELLOW} tools ####################${RESET}"
        /usr/local/go/bin/go install github.com/junegunn/fzf@latest
        env CGO_ENABLED=0 /usr/local/go/bin/go install -ldflags="-s -w" github.com/gokcehan/lf@latest
    elif ! command -v fzf &>/dev/null || ! command -v lf &>/dev/null ; then
        echo -e "\n${YELLOW}########## Installing ${RED}${BOLD}Golang${RESET}${YELLOW} tools ####################${RESET}"
        go install github.com/junegunn/fzf@latest
        env CGO_ENABLED=0 go install -ldflags="-s -w" github.com/gokcehan/lf@latest
    else
        echo -e "\n${YELLOW}########## ${GREEN}${BOLD}Golang pkgs${RESET}${YELLOW} already installed ##########${RESET}"
    fi
}

install_vscodium() {
    if ! command -v codium &>/dev/null; then
        echo -e "\n${YELLOW}########## Installing ${RED}${BOLD}VSCodium${RESET}${YELLOW} ####################${RESET}"
        wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
            | gpg --dearmor | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
        echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
            | sudo tee /etc/apt/sources.list.d/vscodium.list
        ${sa_update} && ${sa_install} codium
    else
        echo -e "\n${YELLOW}########## ${GREEN}${BOLD}VSCodium${RESET}${YELLOW} is already installed ##########${RESET}"
    fi
}

install_brave() {
    if ! command -v brave-browser &>/dev/null; then
        echo -e "\n${YELLOW}########## Installing ${RED}${BOLD}Brave${RESET}${YELLOW} ####################${RESET}"
        sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
            https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] \
            https://brave-browser-apt-release.s3.brave.com/ stable main" \
            | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
        ${sa_update} && ${sa_install} brave-browser
    else
        echo -e "\n${YELLOW}########## ${GREEN}${BOLD}Brave${RESET}${YELLOW} is already installed ##########${RESET}"
    fi
}

install_nerdfonts() {
    if [[ ! -d /usr/share/fonts/FiraCodeNerd && ! -d /usr/share/fonts/CascadiaCodeNerd ]]; then
        echo -e "\n${YELLOW}########## Installing ${RED}${BOLD}FiraCode Nerd Font${RESET}${YELLOW} ####################${RESET}"
        wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip
        sudo unzip FiraCode.zip -d /usr/share/fonts/FiraCodeNerd && rm FiraCode.zip
        echo -e "\n${YELLOW}########## Installing ${RED}${BOLD}CaskaydiaCove Nerd Font${RESET}${YELLOW} ####################${RESET}"
        wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/CascadiaCode.zip
        sudo unzip CascadiaCode.zip -d /usr/share/fonts/CascadiaCodeNerd && rm CascadiaCode.zip
        fc-cache -f
    else
        echo -e "\n${YELLOW}########## ${GREEN}${BOLD}FiraCode${RESET}${YELLOW} & ${GREEN}${BOLD}CaskaydiaCove${RESET}${YELLOW} are already installed ##########${RESET}"
        # fc-cache; fc-list | grep "FiraCode" | head -n 1
    fi
}

install_alacritty() {
    if ! command -v alacritty &>/dev/null; then
        echo -e "\n${YELLOW}########## Installing ${RED}${BOLD}Alacritty${RESET}${YELLOW} ####################${RESET}"
        case ${distro} in
            "ubuntu") sudo add-apt-repository ppa:aslatter/ppa -y &&  ${sa_update} && ${sa_install} alacritty ;;
            "debian" | "pop") ${sa_update} && ${sa_install} alacritty ;;
            *) ;;
        esac
    else
        echo -e "\n${YELLOW}########## ${GREEN}${BOLD}Alacritty${RESET}${YELLOW} is already installed ##########${RESET}"
    fi
}

function install_powershell_ubupop() {
    if ! command -v pwsh &>/dev/null; then
        echo -e "\n${YELLOW}########## Installing ${RED}${BOLD}Powershell${RESET}${YELLOW} ####################${RESET}"
        ${sa_update} && ${sa_install} wget apt-transport-https software-properties-common
        wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" || true
        sudo dpkg -i packages-microsoft-prod.deb
        rm packages-microsoft-prod.deb
        ${sa_update} && ${sa_install} powershell
    else
        echo -e "\n${YELLOW}########## ${GREEN}${BOLD}Powershell${RESET}${YELLOW} is already installed ##########${RESET}"
    fi
}

# function install_powershell_deb {
# }

function install_docker() {
    if ! command -v docker &>/dev/null; then
        echo -e "\n${YELLOW}########## Installing ${RED}${BOLD}Docker${RESET}${YELLOW} ####################${RESET}"
        # https://docs.docker.com/desktop/install/ubuntu/
        ${sa_update} && ${sa_install} ca-certificates curl gnupg  # gnome-terminal
        sudo install -m 0755 -d /etc/apt/keyrings
        curl -fsSL "https://download.docker.com/linux/${docker_distro}/gpg" | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg || true
        sudo chmod a+r /etc/apt/keyrings/docker.gpg
        echo \
            "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/${docker_distro} \
            "$(. /etc/os-release && echo "${VERSION_CODENAME}")" stable" | \
            sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        ${sa_update} && ${sa_install} docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            # docker compose version; docker --version; docker version; sudo docker run hello-world     # systemctl status docker
            sudo usermod -aG docker "${USER}"
            # newgrp docker
        # wget https://desktop.docker.com/linux/main/amd64/docker-desktop-4.24.2-amd64.deb
        # $sa_update && $sa_install ./docker-desktop-4.24.2-amd64.deb && rm docker-desktop-4.24.2-amd64.deb
            # systemctl --user start docker-desktop || systemctl --user enable docker-desktop 
    else
        echo -e "\n${YELLOW}########## ${GREEN}${BOLD}Docker${RESET}${YELLOW} is already installed ##########${RESET}"
    fi
}

function build_neovim {
    if ! command -v nvim &>/dev/null; then
        echo -e "\n${YELLOW}########## Building ${RED}${BOLD}Neovim${RESET}${YELLOW} ####################${RESET}\n"
        ${sa_install} build-essential cmake gettext ninja-build unzip
        cd "${HOME}" && git clone --depth 1 https://github.com/neovim/neovim.git
        cd neovim && make CMAKE_BUILD_TYPE=Release      # RelWithDebInfo OK too
        sudo make install
        cd "${HOME}" && sudo rm -rf neovim
    else
        echo -e "\n${YELLOW}########## ${GREEN}${BOLD}Neovim${RESET}${YELLOW} is already installed ##########${RESET}\n"
    fi
}

function dotfiles_shell {
    if [[ ! -d ${HOME}/dotfiles ]]; then
        git clone --depth 1 https://github.com/pabloqpacin/dotfiles "${HOME}/dotfiles"
        # zoxide add dotfiles
    fi
    if [[ ! -L ${HOME}/.zshrc ]]; then
        echo ""; read -r -p "Apply ZSH configuration? [Y/n] " opt
        if [[ ${opt} == "Y" || ${opt} == "y" || ${opt} = "" ]]; then
            yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
            rm ~/.zshrc && ln -s ~/dotfiles/.zshrc ~/
            mkdir "${HOME}/dotfiles/zsh/plugins"
            git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "${HOME}/dotfiles/zsh/plugins/zsh-autosuggestions"
            git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting "${HOME}/dotfiles/zsh/plugins/zsh-syntax-highlighting"
            bash "${HOME}/dotfiles/scripts/setup/omz-msg_random_theme.sh"
            sudo chsh -s "$(command -v zsh)" "${USER}" || true
            zoxide add dotfiles
        dotfiles_config         # TODO: take this function call outta this function asap
        # else
        #     # oh my bash ...
        fi
    fi
}

######## TODO: proper condition statements bout symlinks and such -- ATM called by Question/Prompt above
function dotfiles_config {
    # Fix cheat --  source ~/dotfiles/scripts/setup/cheat_symlink.sh
    bash "${HOME}/dotfiles/scripts/setup/cheat-symlink.sh"

    # Simple configs
    ln -s ~/dotfiles/.gitconfig ~/
    ln -s ~/dotfiles/.config/lf ~/.config
    ln -s ~/dotfiles/.config/bat ~/.config
    ln -s ~/dotfiles/.config/bottom ~/.config   # || ln -s ~/dotfiles/.config/btop ~/.config
    ln -s ~/dotfiles/.config/alacritty ~/.config

    # Tmux
    ln -s ~/dotfiles/.config/tmux ~/.config
    if [[ ! -d ${HOME}/.tmux/plugins ]]; then
        git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        # tmux    # $ C-b + I --> Install plugins
    fi

    # Powershell
    if command -v pwsh &>/dev/null && [[ ! -e ${HOME}/.local/bin/oh-my-posh ]]; then
        mkdir -p "${HOME}/.local/bin" &>/dev/null
        curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "${HOME}/.local/bin" || true
        ln -s ~/dotfiles/.config/powershell ~/.config
    fi

    # Codium + devilspie (autostart)
    if command -v codium &>/dev/null && command -v devilspie &>/dev/null; then
        ln -s ~/dotfiles/.devilspie ~/
        ln -s ~/dotfiles/.config/autostart ~/.config
        bash "${HOME}/dotfiles/scripts/setup/codium-extensions.sh"
        codium &
        sleep 2 && pkill codium
        # rm $HOME/.config/VSCodium/User/settings.json && \
        ln -s ~/dotfiles/.config/code/User/settings.json ~/.config/VSCodium/User
    dotfiles_neovim     # TODO: fix too eww
    fi
}

function dotfiles_neovim {
    if ! command -v npm &>/dev/null; then
        echo -e "\n${YELLOW}########## Installing ${RED}${BOLD}npm${RESET}${YELLOW} ####################${RESET}"
        ${sa_install} npm

            ### ISSUE: Ubuntu version is too old for nvim.bashls
            ### main PopOS box --> node --version && npm --version == 20.5.0  - 9.8.0
            ### debianVM --------> "                             " == 18.13.0 - 9.2.0
            ### ubuntuVM --------> "                             " == 12.22.9 - 8.5.1

        # curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
        # source $HOME/.${current_shell}rc && nvm install node
    else
        echo -e "\n${YELLOW}########## ${GREEN}${BOLD}npm${RESET}${YELLOW} is already installed ##########${RESET}"
    fi
    if ! command -v deno &>/dev/null; then
        echo -e "\n${YELLOW}########## Installing ${RED}${BOLD}deno${RESET}${YELLOW} ####################${RESET}"
        curl -fsSL https://deno.land/x/install/install.sh | sh || true
    else
        echo -e "\n${YELLOW}########## ${GREEN}${BOLD}deno${RESET}${YELLOW} is already installed ##########${RESET}"
    fi
    if [[ ! -d ${HOME}/.local/share/nvim/site/pack/packer ]]; then
        git clone --depth 1 https://github.com/wbthomason/packer.nvim \
         ~/.local/share/nvim/site/pack/packer/start/packer.nvim
    fi
    ln -s "${HOME}/dotfiles/.config/nvim" "${HOME}/.config"
    read -r -p "Skip error messages with <Enter>, then do :so :PackerSync :qa " null
    case ${null} in
        '') cd ~/.config/nvim && nvim lua/pabloqpacin/packer.lua; cd "${HOME}" || true ;;
        # # $ :so && :PackerSync && :PackerCompile && :MasonUpdate
        *) ;;
    esac
}

