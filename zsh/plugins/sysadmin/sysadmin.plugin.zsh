
### dig
### iptables, nft, ufw
### netstat
### VBoxManage

# ---

##### dig, nslookup

whatismyip(){
    dig +short myip.opendns.com @resolver1.opendns.com
}

dig-mx(){
    dig "$1" mx | bat -pl URL       # bat --list-languages | grep 'INI'
}

# dig-mx pabloqpacin.com; dig-mx setesur.com

# $(command -v nslookup || command -v dnslookup || command -v tlslookup) ns.cluster.net


### iptables, nft, ufw

# iptables -S
# iptables -L
# iptables -L -n
# iptables -F|f         # eliminar movidas

alias ipt_show='sudo grc iptables --verbose --numeric --list --line-numbers'
alias nft_show='sudo nft list ruleset | bat -l conf'

# alias ufw='foo'


##### netstat

# net-tools (en ubuntuserver)
check-ports(){
    sudo netstat -lnp | grep named
}

##### VBoxManage

# VBoxManage list hostinfo | grep 'nested HW virtualization'
alias vboxrunningvms='VBoxManage list runningvms'
# VBoxManage list vms
# VBoxManage list groups
# VBoxManage list dhcpservers
# VBoxManage list hostonlyifs
# VBoxManage list intnets
# VBoxManage list natnets

# ---

#--- WIP


# pkgs=(
#   'curl' 'dig' 'dnslookup' 'nslookup' 'tlslookup' 'whois' 'wget'
#   'host' 'net-tools (netstat)'
# )
#
# curl -v pabloqpacin.com
# whois pabloqpacin.com
# dig pabloqpacin.com
# dig pabloqpacin.com mx
# nslookup pabloqpacin.com


