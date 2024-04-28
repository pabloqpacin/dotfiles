#!/usr/bin/env bash

echo -e "\n-----############################################################-----"
echo -e   "#########~~~~~{     Kali-base v0.2  by @pabloqpacin    }~~~~~#########"
echo -e   "-----############################################################-----\n"

# bash -c "$(curl -fsSL https://github.com/pabloqpacin/dotfiles/raw/main/scripts/autosetup/Kali-base.sh)"

# NOTE 1: TODO: should work on the Pi5 (ARM 64-bit)
# NOTE 2: rev0.1 Febr.; rev0.2 Apr. -- Kali Rolling!!
# NOTE 3: in terminal, Ctrl+P changes prompt from 2 to 1 lines
# NOTE 4: ojo... https://gitlab.com/Arszilla/kali-i3

set_variables() {
    should_reboot=0
    sa_update="sudo apt-get update"

    read -p "Skip all 'apt install <package>' prompts? [y/N] " opt
    case $opt in
        'Y'|'y') sa_install="sudo apt-get install -y" ;;
              *) sa_install="sudo apt-get install" ;;
    esac
}

apt_update_install(){
    if [ ! -e "/etc/apt/apt.conf.d/99show-versions" ]; then
        echo 'APT::Get::Show-Versions "true";' | sudo tee /etc/apt/apt.conf.d/99show-versions
    fi

    $sa_update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean

    $sa_install xclip wl-clipboard xsel                                         # OJO
    $sa_install --no-install-recommends neofetch
    $sa_install bat eza fzf git-delta grc jq lf ripgrep                         # btm ipcalc

    if ! command -v bat &>/dev/null && command -v batcat &>/dev/null; then
        sudo mv $(which batcat) /usr/bin/bat
    fi

    if ! command -v tldr &>/dev/null; then
        read -p "Install tldr [y/N]? " opt_tldr
        if [[ $opt_tldr == 'y' ]]; then
            $sa_install tldr
            if [ ! -d ~/.local/share ]; then
                mkdir ~/.local/share
            fi
            tldr --update
        fi
    fi
}

clone_symlink_dotfiles() {
    if [ ! -d ~/dotfiles ]; then
        git clone --depth 1 https://github.com/pabloqpacin/dotfiles ~/dotfiles
    fi
    if [ ! -L ~/.gitconfig ]; then
        ln -s ~/dotfiles/.gitconfig ~/                                          # OJO: 'pabloqpacin'
    fi
    if [ ! -L ~/.config/tmux ]; then
        ln -s ~/dotfiles/.config/tmux ~/.config
    fi
    if [ ! -L ~/.config/bat ]; then
        ln -s ~/dotfiles/.config/bat ~/.config
    fi
    if [ ! -L ~/.config/lf ]; then
        ln -s ~/dotfiles/.config/lf ~/.config
    fi
    if [ ! -L ~/.vimrc ]; then
        sed -i "s/nvim'/vim'/g" ~/dotfiles/.zshrc
        sudo ln -s ~/dotfiles/.vimrc /root/ &&
            ln -s ~/dotfiles/.vimrc ~/
    fi
}

setup_nerdfonts(){
    if [ ! -d ~/.fonts ]; then mkdir ~/.fonts; fi

    if ! fc-cache -v | grep -q 'FiraCodeNerdFont'; then
        local FCNF_URL='https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip'
        wget -qO /tmp/FiraCode.zip $FCNF_URL &&
            unzip /tmp/FiraCode.zip -d ~/.fonts/FiraCodeNerdFont &&
            fc-cache -f
    fi

    sed -i 's/FiraCode/FiraCodeNerdFont/' ~/.config/qterminal.org/qterminal.ini
}

tweak_zsh(){
    if ! grep -q 'Custom' ~/.zshrc; then
        cp ~/.zshrc{,.bak}
        {
            echo -e "\n# Custom aliases etc."
            echo "source ~/dotfiles/zsh/aliases.zsh"
            echo "source ~/dotfiles/zsh/plugins/pqp-docker-k8s/pqp-docker-k8s.plugin.zsh"
        } | tee -a ~/.zshrc
        {
            echo -e "\n# ---\n"
            echo "alias agu='sudo apt update'"
            echo "alias aguu='sudo apt update && sudo apt upgrade'"
            echo "alias agi='sudo apt install'"
            echo "alias gst='git status'"
            echo "alias ga='git add'"
            echo "alias gd='git diff'"
            echo "alias gds='git diff --staged'"
        } | tee -a ~/dotfiles/zsh/aliases.zsh
    fi
}

setup_docker(){
    # https://computingforgeeks.com/install-docker-and-docker-compose-on-kali-linux/ -- https://www.kali.org/docs/containers/installing-docker-on-kali/
    if ! docker &>/dev/null; then
        $sa_update && $sa_install \
            curl gnupg2 apt-transport-https software-properties-common ca-certificates
        curl -fsSL https://download.docker.com/linux/debian/gpg | \
            sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-archive-keyring.gpg
        echo "deb [arch=amd64] https://download.docker.com/linux/debian bullseye stable" | \
            sudo tee  /etc/apt/sources.list.d/docker.list

        $sa_update && $sa_install \
            docker-ce docker-ce-cli containerd.io docker-compose-plugin
        sudo usermod -aG docker $USER   # && newgrp docker
    fi
}

install_brave() {
    if ! command -v brave-browser &>/dev/null; then
        sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
            https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] \
            https://brave-browser-apt-release.s3.brave.com/ stable main" \
            | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
        $sa_update && $sa_install brave-browser
    fi
}

# setup_i3(){
#     $sa_update && $sa_install i3 picom
# }

# ---

if [ $(systemctl is-enabled ssh) != 'enabled' ]; then
    sudo systemctl enable --now ssh
    echo ""
fi

set_variables
apt_update_install

clone_symlink_dotfiles
setup_nerdfonts
tweak_zsh

setup_docker
install_brave

echo "" && neofetch
[ -f /var/run/reboot-required ] && echo -e "\nKindly reboot."


