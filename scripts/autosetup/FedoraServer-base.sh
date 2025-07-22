#!/usr/bin/env bash

echo -e "\n----################################################################----"
echo -e   "#######~~~~{     FedoraServer-base v1.0  by @pabloqpacin    }~~~~#######"
echo -e   "----################################################################----\n"

### Tested successfully on Fedora 39 (fresh VM):
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/pabloqpacin/dotfiles/main/scripts/autosetup/FedoraServer-base.sh)"

########## VARIABLES ##########

sdnf_update="sudo dnf check-update"
sdnf_install="sudo dnf install"
current_shell="$(echo "${SHELL}" | awk -F '/' '{print $NF}')"

########## FUNCTIONS ##########

set_variables() {
    read -r -p "Skip all 'sudo dnf install <pkg>' prompts? [y/N] " opt
    case ${opt} in
        'Y' | 'y') sdnf_install="sudo dnf install -y" ;;
        *) ;;
    esac
}

update_system() {
    if ! grep -q 'parallel' /etc/dnf/dnf.conf || ! grep -q 'fastest' /etc/dnf/dnf.conf; then
        echo -e "max_parallel_downloads=10\nfastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf
    fi

    ${sdnf_update} && sudo dnf up --refresh -y && \
        sudo dnf autoremove -y && \
        sudo dnf clean all
}

install_base_dnf() {

    ${sdnf_install} perl-Time-Piece   # https://superuser.com/questions/520708/in-fedora-perl-program-cannot-find-timepiece-library
    ${sdnf_install} neofetch --setopt=install_weak_deps=False
    ${sdnf_install} bat eza fzf git git-delta grc mycli nmap ripgrep tldr tmux zsh    # cheat

    if [[ ! -d ~/.cache/tldr ]]; then tldr --update; fi

    sudo dnf copr enable atim/bottom -y
    ${sdnf_install} bottom

    sudo dnf copr enable pennbauman/ports -y
    ${sdnf_install} lf
}

clone_dotfiles() {
    if [[ ! -d ~/dotfiles ]]; then
        git clone --depth 1 https://github.com/pabloqpacin/dotfiles ~/dotfiles; fi

    if [[ ! -d ~/.config ]]; then
        mkdir ~/.config &>/dev/null; fi

    if [[ ! -L ~/.myclirc ]]; then
        ln -s ~/dotfiles/.myclirc ~/; fi

    if [[ ! -L ~/.config/lf ]]; then
        ln -s ~/dotfiles/.config/lf ~/.config; fi

    if [[ ! -L ~/.config/tmux ]]; then
        ln -s ~/dotfiles/.config/tmux ~/.config; fi

    if [[ ! -L ~/.config/bottom ]]; then
        ln -s ~/dotfiles/.config/bottom ~/.config; fi

    if [[ ! -L ~/.config/bat ]]; then
        ln -s ~/dotfiles/.config/bat ~/.config
        sed -i 's/OneHalfDark/Coldark-Dark/' ~/.config/bat/config
    fi

    if [[ ! -L ~/.vimrc ]]; then
        ln -s ~/dotfiles/.vimrc ~/ && \
        sudo ln -s "${HOME}/dotfiles/.vimrc" /root/
        sed -i 's/nvim/vim/g' ~/dotfiles/.zshrc
    fi

    if [[ ! -L ~/.gitconfig ]]; then
        # sed ... theme
        sed -i '/github/d' ~/dotfiles/.gitconfig && \
        sed -i "s/pabloqpacin/${USER}/" ~/dotfiles/.gitconfig
        ln -s ~/dotfiles/.gitconfig ~/
    fi
}

setup_zsh() {
    
    if [[ ! -d ~/.oh-my-zsh ]]; then
        yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
        bash "${HOME}/dotfiles/scripts/setup/omz-msg_random_theme.sh"
    fi
    
    if [[ "${current_shell}" != 'zsh' ]]; then
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

install_docker() {

    if ! command -v docker &>/dev/null; then
        # https://docs.docker.com/engine/install/fedora/
        sudo dnf -y install dnf-plugins-core
        sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
        yes | sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || true
        sudo systemctl enable --now docker
        sudo usermod -aG docker "${USER}"
    fi
}


########### RUNTIME ###########

# echo -e "$(dnf list --installed | wc -l) paquetes intalados\n" >> /tmp/install.log && \
# df -h | grep '/$' >> /tmp/install.log

set_variables
update_system
install_base_dnf
clone_dotfiles
setup_zsh
install_docker

# hostname # localhost.localdomain

echo "" && neofetch && echo -e "\nKindly reboot.\n"

