#!/usr/bin/env bash

# https://wiki.setenova.es/en/sistemas/linux/usuarios

politicas_contras() {
    if ! dpkg -l | grep -q libpam-pwquality; then
        sudo apt install -y libpam-pwquality
    fi

    if ! grep -q '^minlen' /etc/security/pwquality.conf; then
        sudo cp /etc/security/pwquality.conf{,.bak}
        cat << EOF | sudo tee /etc/security/pwquality.conf > /dev/null
minlen = 21
dcredit = -1
ucredit = -1
lcredit = -1
ocredit = 0
EOF
    fi

    # grep 'password requisite pam_pwquality.so retry=3' /etc/pam.d/common-password

    sudo cp /etc/login.defs{,.bak}

    sudo sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   365/' /etc/login.defs
    sudo sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS   1/' /etc/login.defs
    sudo sed -i 's/^PASS_WARN_AGE.*/PASS_WARN_AGE   14/' /etc/login.defs
}

prepare_skel() {

    #! IMPORTANTE: se asume que ya he ejecutado el install_dotfiles.sh para el usuario admin...

    sudo cp -r /etc/skel{,.bak}

    sudo mkdir -p /etc/skel/.config

    sudo cp -r ~/dotfiles ~/.oh-my-zsh /etc/skel/

    sudo cp -r /etc/skel/dotfiles/{.zshrc,.vimrc} /etc/skel/
    sudo cp -r /etc/skel/dotfiles/.config/{bat,lf,tmux} /etc/skel/.config

    cat << EOF | sudo tee /etc/skel/.gitconfig >/dev/null
[core]
    pager = delta
[interactive]
    diffFilter = delta --color-only
[include]
    path = ~/dotfiles/.config/delta/themes.gitconfig
[delta]
    # features = calochortus-lyallii    # https://github.com/dandavison/delta/blob/main/themes.gitconfig
    # side-by-side = true
    line-numbers = true
    navigate = true
[merge]
    conflictstyle = diff3
[diff]
    colorMoved = default
EOF

    # if dpkg -l | grep -q xfce4; then
    #     echo "xfce4-session" | sudo tee /etc/skel/.xsession >/dev/null
    # fi
}

create_users() {
    local DEFAULT_SHELL="${1:-/usr/bin/zsh}"

    SUDO_USERS=("pquevedo" "agranero")
    NO_SUDO_USERS=("control-user" "dquispe" "ayermak" "lhernando")

    #? TODO: más de 3 intentos para el passwd...

    # Crear usuarios con sudo
    for USER in "${SUDO_USERS[@]}"; do
        echo "================================================"
        id -u "$USER" >/dev/null 2>&1 && { echo "Usuario '$USER' ya existe, saltando (sudo_users)..."; continue; }

        echo "Creando usuario con sudo: '$USER'"
        sudo useradd -m -s "$DEFAULT_SHELL" -U -G sudo "$USER" && \
            echo "Introduce contraseña inicial para: '$USER'" && \
            echo "- Deberá ser cambiada en el primer login" && \
            echo "- Se recomienda autogenerarla con un gestor de contraseñas como KeePassXC" && \
            sudo passwd "$USER" && \

            id "$USER" && \
            ls -ld /home/$USER && \

            sudo chage -d 0 "$USER" && \
            sudo chage -l "$USER"
    done

    # Crear usuarios sin sudo (pero con docker)
    for USER in "${NO_SUDO_USERS[@]}"; do
        echo "================================================"
        id -u "$USER" >/dev/null 2>&1 && { echo "Usuario '$USER' ya existe, saltando (no_sudo_users)..."; continue; }

        echo "Creando usuario sin sudo: '$USER'"
        sudo useradd -m -s "$DEFAULT_SHELL" -U -G docker "$USER" && \
            echo "Introduce contraseña inicial para: '$USER'" && \
            echo "- Deberá ser cambiada en el primer login" && \
            echo "- Se recomienda autogenerarla con un gestor de contraseñas como KeePassXC" && \
            sudo passwd "$USER" && \

            id "$USER" && \
            ls -ld /home/$USER && \

            sudo chage -d 0 "$USER" && \
            sudo chage -l "$USER"
    done
}

delete_users() {
    local USERS=("foo" "bar")
    for USER in "${USERS[@]}"; do
        sudo userdel -r "$USER"
        echo "================================================"
    done
}

# ---

if true; then
    politicas_contras

    DEFAULT_SHELL="/usr/bin/zsh"
    if [ -d "$HOME/dotfiles" ]; then
        prepare_skel
    else
        echo "Aviso: '$HOME/dotfiles' no existe."
        echo "No se ejecuta prepare_skel() y se usará bash en lugar de zsh como shell por defecto para los nuevos usuarios."
        DEFAULT_SHELL="/usr/bin/bash"
    fi

    create_users "$DEFAULT_SHELL"
fi
