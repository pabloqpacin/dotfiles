#!/bin/bash

### Nvim tweaks
nvim_lsp="$HOME/.config/nvim/after/plugin/lsp.lua"
lsp_2_sed=('clangd' 'gopls' 'lua_ls' 'powershell' 'sqlls' 'rust_analyzer')

for lsp in "${lsp_2_sed[@]}"; do
    if grep -q "$lsp" "$nvim_lsp"; then
        sed -i "/$lsp/s/^/-- /" $nvim_lsp
        grep "$lsp" "$nvim_lsp"
    fi
done


### recon_nmap.sh
recon_script="$HOME/dotfiles/scripts/recon_nmap.sh"

grep "log_dir=" $recon_script
sed -i "/log_dir=/c\log_dir=$HOME/tmp/recon; mkdir \$log_dir &>/dev/null" $recon_script
grep "log_dir=" $recon_script
    # sed -i 's/-oN $log_temp//g' $recon_script

