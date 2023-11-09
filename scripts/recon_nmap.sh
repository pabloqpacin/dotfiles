#!/bin/bash

echo -e "\n----###############################################################----"
echo -e "########~~~~~{     R3C0N NM4P v0.1.6  by @pabloqpacin    }~~~~~########"
echo -e "----###############################################################----\n"

### Tested successfully on: Arch Debian PopOS Ubuntu (VMs)
### TODO: nmap scripts
### TODO: verbosity

################################################################################
#                                  VARIABLES                                   # 
################################################################################

ip=$(hostname -i | awk '{print $1}')
net=$(ip route | grep $ip | tail -1 | awk '{print $1}')
target_list=''
targets=("_gateway" "localhost" "scanme.nmap.org")
nmap=''
hyp=''

log_dir='/tmp/recon'
log_tmp="$log_dir/scan.txt"
log="$log_dir/$(date +%F).txt"

################################################################################
#                                  FUNCTIONS                                   # 
################################################################################

set_new_target() {
    while true
        do read -p "Set new target domain or IP (or press Enter to exit): " target_value
        if [ -z "$target_value" ]; then break; fi
        targets+=("$target_value")
    done
}

open_scan () {
    $nmap $hyp --open $1 -oN $log_tmp
}

ping_scan() {
    $nmap -sP $1 -oN $log_tmp
}

tcp_scan() {
    $nmap $hyp -sT $1 -oN $log_tmp
}

syn_scan() {
    sudo $nmap $hyp -sS $1 -oN $log_tmp
}

version_scan() {
    $nmap $hyp -sV $1 -oN $log_tmp
}

sam_scan() {
    $nmap -p- -sCV -Pn $1 -oN $log_tmp
}

target_prompt() {
    read -p "Enter target IPv4, domain name or keyword (net, ip, t1 t2 ...): " target_answer
    if [[ $target_answer == t* ]]; then
        local target_index="${target_answer#t}"
        target_scan="${targets[target_index - 1]}"
    else
        declare -A target_mapping=(
            [ip]="$ip"
            [net]="$net"
        )
        if [ -n "${target_mapping[$target_answer]}" ]
            then target_scan="${target_mapping[$target_answer]}"
            else target_scan="$target_answer"
        fi
    fi
}

ask_fullscan() {
    read -p "Add '-p-' flag for full scan (all ports)? [y/N]: " opt
    if [[ $opt == "Y" || $opt == "y" ]]
        then hyp='-p-'; else hyp=''
    fi
    echo -e "#######################################################################\n"
}

# ask_verbosity() { }

custom_command() {
    read -p "Enter the command to be run: " custom
    (eval "$custom")
}

exit_script() {
    read -p "Delete $log_dir? [Y/n] " opt
    if [[ $opt == "Y" || $opt == "y" || $opt == "" ]]
        then rm -rf $log_dir
    fi
    exit 0
}

################################################################################
#                                   RUNTIME                                    # 
################################################################################

mkdir $log_dir &>/dev/null

if command -v grc &>/dev/null; then nmap="grc nmap"; else nmap="nmap"; fi

echo -e "#  NOTE: Run './recon_nmap.sh target_list.txt' to add extra targets.  #\n"
if [ -n "$1" ]
    then target_list="$1"
    while IFS= read -r line
        do targets+=("$line")
    done < "$target_list"
fi

read -p "Scan network interfaces? [y/N] " opt
if [[ $opt == "Y" || $opt == "y" ]]
    then $nmap --iflist
fi

while true; do
    if [[ -e $log_temp ]]
        then cat $log_temp >> $log; echo "---" >> $log
    fi

    echo -e "\n#######################################################################"
    echo -e "# Scan log ................................. $log"
    echo -e "# Active subnet ............................ $net"
    echo -e "# Active IP................................. $ip"
    echo -e "# Known targets:"
    for i in "${!targets[@]}"
        do echo -e "\tt$((i+1)) ................................. ${targets[i]}"
    done

    echo -e "\nActions available:"
    echo -e "\t0) Set new target."
    echo -e "\t1) Scan open ports ----------------> nmap --open ..."
    echo -e "\t2) Ping-scan target ---------------> nmap -sP ..."
    echo -e "\t3) TCP-scan target ----------------> nmap -sT ..."
    echo -e "\t4) SYN-scan target ----------------> sudo nmap -sS ..."
    echo -e "\t5) App Version scan ---------------> nmap -sV ..."
    echo -e "\t8) Sam scan -----------------------> nmap -p- -sCV -Pn -T4 ..."
    echo -e "\t9) Custom command."
    echo -e "\ts) Clear screen."
    echo -e "\tr) Read log."
    echo -e "\t*) Exit.\n"
    
    read -p "Select action: " opt

    case $opt in
        "0") set_new_target ;;
        "1") target_prompt; ask_fullscan; open_scan $target_scan ;;
        "2") target_prompt; ask_fullscan; ping_scan $target_scan ;;
        "3") target_prompt; ask_fullscan; tcp_scan $target_scan ;;
        "4") target_prompt; ask_fullscan; syn_scan $target_scan ;;
        "5") target_prompt; ask_fullscan; version_scan $target_scan ;;
        "8") target_prompt; ask_fullscan; sam_scan $target_scan ;;
        "9") custom_command ;;
        "s") clear ;;
        "r") less $log ;;
        "*") exit_script ;;
    esac

done


###################### ~~~ ######################

# if [[ $distro != 'Android' ]]
#     then ip=$(ip route get 1 | awk '{print $7}')
#     else ip=$(ip route get 1 | awk '{print $9}')
# fi
# if [[ $distro != 'arch' ]]
#     then net=$(ip route | grep 'src' | awk '{print $1}' | head -n 1)
#     else net=$(ip route | grep 'link' | awk '{print $1}')
# fi  # Because diff output since diff 'iproute2' version or $(ip -V)


# int_up=    WHICHEVER IS UP IN ip a || WHEREVER THERES AN IPv6
# TODO: verify if the logic: variable>function call>reassignment(later call)>runtime... is fine or is it broken.
#       If broken, need to have defined whether --p before the "Action call" !!!
#       Also, instead of using a variable, use a function to return the flag as $2 or smth....
# EDIT: IT SEEMS TO WORK AS EXPECTED!!

### OJO: UbuntuVM (WP) con 'python3 -m http.server'; un 'nmap -p- localhost' produce un error en varios archivos de '/usr/lib/python3.10/' (socketserver.py, http/server.py, socketserver.py, socket.py)
### TODO: is 'opt' good enough? Safe? Should it be "nulled" after each function?
