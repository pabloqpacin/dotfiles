#!/bin/bash

themes_dir="${HOME}/.config/alacritty/themes/"
theme_files=("${themes_dir}"*.yaml)
random_index=$((RANDOM % ${#theme_files[@]}))
selected_theme="${theme_files[random_index]}"
# echo "[$selected_theme]"

grep 'themes' "${HOME}/.config/alacritty/alacritty.yml"
sed -i "s|/home/pabloqpacin/.*|${selected_theme}|" "${HOME}/.config/alacritty/alacritty.yml"
grep 'themes' "${HOME}/.config/alacritty/alacritty.yml"
