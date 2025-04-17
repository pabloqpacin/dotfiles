#!/usr/bin/env bash

nerdfonts_version='v3.3.0'
desired_nerdfonts=('FiraCode' 'CascadiaCode')

if [[ ! -d ~/.fonts ]]; then
    mkdir "${HOME}/.fonts"
fi

for nerdfont in "${desired_nerdfonts[@]}"; do
    if ! fc-cache -v | grep -q "${nerdfont}"; then
        wget -qO "/tmp/${nerdfont}.zip" \
            "https://github.com/ryanoasis/nerd-fonts/releases/download/${nerdfonts_version}/${nerdfont}.zip" && \
        unzip "/tmp/${nerdfont}.zip" -d "${HOME}/.fonts/${nerdfont}"
    fi
done

fc-cache -f
