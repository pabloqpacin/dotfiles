#!/bin/bash

if ! command -v pwsh &>/dev/null
    then echo "Command 'pwsh' not found. Aborting script" && exit 1
elif [[ ! -d ${HOME}/.cache/oh-my-posh ]]
    then echo "Installation/themes '~/.cache/oh-my-posh' path not found. Aborting script" && exit 1
fi

trash_themes=(
    '1_shell' 'agnoster' 'aliens' 'atomicBit' 'atomic' 'avit' 'blue-owl' 'bubbles' 'catppuccin_latte'
    'catppuccin' 'cert' 'chips' 'cinnamon' 'clean-detailed' 'cloud-context' 'cloud-native-azure'
    'cobalt2' 'craver' 'darkblood' 'devious-diamonds' 'dracula' 'easy-term' 'emodipt-extend' 'fish'
    'free-ukraine' 'froczh' 'grandpa-style' 'honukai' 'hotstick' 'hul10' 'hunk' 'if_tea' 'iterm2'
    'jandedobbeleer' 'jonnychipz' 'json' 'jtracey93' 'jv_sitecorian' 'kushal' 'lambdageneration'
    'larserikfinholt' 'lightgreen' 'markbull' 'mojada' 'montys' 'mt' 'neko' 'nu4a' 'paradox'
    'patriksvensson' 'peru' 'pixelrobots' 'plague' 'poshmon' 'powerlevel10k_classic'
    'powerlevel10k_modern' 'powerlevel10k_rainbow' 'quick-term' 'remk' 'rudolfs-dark'
    'rudolfs-light' 'slimfat' 'slim' 'sonicboom_dark' 'sonicboom_light'
    'takuya' 'thecyberden' 'the-unnamed' 'tiwahu' 'tokyo'
    'unicorn' 'velvet' 'wholespace'
)

# themes="${HOME}/.cache/oh-my-posh/themes/${trash_themes}.omp.json"

for trash in "${trash_themes[@]}"; do
    theme="${HOME}/.cache/oh-my-posh/themes/${trash}.omp.json"
    if [[ -e "${theme}" ]]; then
        rm -v "${theme}"
    fi
done


# TODO: handle "${trash}.omp.yaml"
