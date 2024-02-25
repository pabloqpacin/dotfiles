#!/bin/bash

# random_pic=$(find $HOME/dotfiles/img/wallpapers/. -type f | shuf -n 1)
random_pic=$HOME/dotfiles/img/wallpapers/er_nd.jpg

function set_random_pic {
    swaybg -i $random_pic -m fill &
}

while true; do
    set_random_pic; OLD_PID=$!
    sleep 400
    set_random_pic; NEXT_PID=$!
    sleep 5
    kill $OLD_PID
    OLD_PID=$NEXT_PID
done


# https://sylvaindurand.org/dynamic-wallpapers-with-sway/