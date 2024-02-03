install_mycli() {
    if ! command -v pip &>/dev/null; then
        echo "ERROR: pip is not installed" && return 1
    fi

    if ! command -v mycli &>/dev/null; then
        pip install -U mycli
    fi
}

install_pgcli() {
    if ! command -v pip &>/dev/null; then
        echo "ERROR: pip is not installed" && return 1
    fi

    if ! command -v pgcli &>/dev/null; then
        pip install -U pgcli
    fi

    # if EFFED UP; then
    #     agi libpq-dev -y
}


config_mycli() {
    if command -v mycli &>/dev/null || [ ! -e ~/.myclirc ]; then
        mycli &>/dev/null & pid=$! && sleep 2 && kill "$pid"
    fi

    if [ -e ~/.myclirc ] && [ ! -L ~/.myclirc ]; then
        mv ~/.myclirc{,.bak} &&
        ln -s ~/dotfiles/.myclirc ~/
    fi
}

config_pgcli() {
    if command -v pgcli &>/dev/null || [ ! -d ~/.config/pgcli ]; then
        pgcli &>/dev/null & pid=$! && sleep 2 && kill "$pid"
    fi

    if [ -d ~/.config/pgcli ] && [ ! -L ~/.config/pgcli/config ]; then
        mv ~/.config/pgcli/config{,.bak} &&
        ln -s ~/dotfiles/.config/pgcli/config ~/.config/pgcli/
    fi
}

# === x ===

install_mycli
install_pgcli

config_mycli
config_pgcli
