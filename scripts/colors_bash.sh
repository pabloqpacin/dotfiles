#!/bin/bash

#### Reset
RESET='\e[0m'

#### Text Styles
BOLD='\e[1m'
ITALIC='\e[3m'
UNDERLINE='\e[4m'

#### Text Colors
T_BLACK='\e[30m'
T_BLUE='\e[34m'
T_CYAN='\e[36m'
T_GREEN='\e[32m'
T_MAGENTA='\e[35m'
T_RED='\e[31m'
T_WHITE='\e[37m'
T_YELLOW='\e[33m'

#### Background Colors
B_BLACK='\e[40m'
B_BLUE='\e[44m'
B_CYAN='\e[46m'
B_GREEN='\e[42m'
B_MAGENTA='\e[45m'
B_RED='\e[41m'
B_WHITE='\e[47m'
B_YELLOW='\e[43m'

# DEMO
echo -e "${T_RED}${BOLD}This is red and bold text${RESET}"

# TODO: ./dotfiles/.config/alacritty/print_colors.sh
