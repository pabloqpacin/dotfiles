#!/bin/bash

##### NEEDS PROPER TESTING -- apparently should only work before ever running Brave on the machine
##### Might be relevant for Setesur/Setenova (Windows & Chrome) automation endeavours -- also regarding bookmarks, users and other security features

if ! command -v brave-browser &>/dev/null; then
    echo "'brave-browser' not installed. Terminating script"
    return 1
fi

echo "### Installing Brave extensions (needs sudo)"

EXTENSIONS=(
    'eimadpbcbfnmbkopoojfekhnkhdbieeh'      # dark-reader
    'bcjindcccaagfpapjjmafapmmgkkhgoa'      # json-formatter
    'oboonakemofpalcgghocfoadofidjkkk'      # keepassxc-browser
    'gphhapmejobijbbhgpjhcjognlahblep'      # gnome-shell-integration
    # 'efknglbfhoddmmfabeihlemgekhhnabb'    # json-viewer   # like firefox
    # 'hgeljhfekpckiiplhkigfehkdpldcggm'    # auto-refresh
    # 'dphilobhebphkdjbpfohgikllaljmgbn'    # simple-login
)

EXTENSIONS_PATH=/opt/brave.com/brave/extensions
sudo mkdir -p $EXTENSIONS_PATH

for i in "${!EXTENSIONS[@]}"; do
    echo '{ "external_update_url": "https://clients2.google.com/service/update2/crx" }' | sudo tee "${EXTENSIONS_PATH}/${EXTENSIONS[i]}.json"
done

if [[ $? == 0 ]]; then
    echo "### Brave extensions should be ready to be installed. Just open the browser to do so."
fi

# https://stackoverflow.com/questions/73289644/how-to-install-browser-extension-for-namely-brave-through-terminal
# https://support.brave.com/hc/en-us/articles/360044860011-How-Do-I-Use-Command-Line-Flags-in-Brave
# https://support.google.com/chrome/a/answer/187948?hl=en#zippy=
# https://devicetests.com/install-chrome-extensions-terminal

