#!/bin/bash

### ojo $OMB_THEME_RANDOM_SELECTED

themes_dir="${HOME}/.oh-my-bash/themes"
inop_themes=(
    'bobby' 'dos' 'doubletime_multiline_pyonly' 'emperor' 'hawaii50'
    'modern-t' 'powerline-plain' 'pro' 'rainbowbrite' 'rr' 'tonka'
)

for i in "${!inop_themes[@]}"; do
    if [[ -d "${themes_dir}/${inop_themes[i]}" ]]; then
        rm -rf "${themes_dir}/${inop_themes[i]}"
        echo "Theme deleted: '~/.oh-my-bash/themes/${inop_themes[i]}'."
    else
        echo "Theme not found: '~/.oh-my-bash/themes/${inop_themes[i]}'."
    fi
done

# NOTES: hawaii50 fetches the public IP; axin is good;
# FAVES: axin powerline-naked
