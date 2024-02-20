
start_tmux(){

    if [ -n "$TMUX" ]; then
        echo "Inside a tmux session"
    else
        echo "Not inside a tmux session"

        # crear prompt menu para seleccionar directorio de trabajo y crear tmux session con el nombre del dir (lf/fzf)

    fi

}

# start_tmux
