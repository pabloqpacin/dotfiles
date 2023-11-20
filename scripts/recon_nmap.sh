#!/bin/bash

echo -e "\n----###############################################################----"
echo -e "########~~~~~{     R3C0N NM4P v0.1.8  by @pabloqpacin    }~~~~~########"
echo -e "----###############################################################----\n"

### Tested successfully on: Arch Debian PopOS Ubuntu (VMs)
# TODO: nmap scripts
# TODO: verbosity

########## VARIABLES & FUNCTIONS ##########

set_variables(){

        # Get distro for compatibility reasons
    distro=$(grep -s "^ID=" /etc/os-release | awk -F '=' '{print $2}')
    case $distro in '') distro='termux' ;; esac

        # Get host & network IPv4 addresses
    case $distro in
                 'termux') ip=$(   ip route | awk '{print $9}') ;;
             'pop'|'arch') ip=$(hostname -i | awk '{print $1}') ;;
        'debian'|'ubuntu') ip=$(hostname -I | awk '{print $1}') ;;
                        *) ip=$(hostname -i | awk '{print $1}') ;;
    esac
    net=$(ip route | grep $ip | grep kernel | awk '{print $1}')

        # Integrate target-lists!!
    targets=("_gateway" "localhost" "scanme.nmap.org")

    if [ -n "$1" ]
        then target_list="$1"
        while IFS= read -r line
            do targets+=("$line")
        done < "$target_list"
    fi

        # Logging scans if possible
    log_dir='/tmp/recon'
    log_temp="$log_dir/scan.txt"
    log="$log_dir/$(date +%F).txt"

    if [ $distro != 'termux' ]
        then do_log="-oN $log_temp"
        else do_log=""
    fi

        # Colorize output if possible
    if command -v grc &>/dev/null;
        then nmap="grc nmap"
        else nmap="nmap"
    fi
}

scan_interfaces() {
    read -p "Scan network interfaces? [y/N] " opt
    case $opt in [Yy]) $nmap --iflist ;; esac
}


set_new_target() {
    while true
        do read -p "Set new target domain or IP (or press Enter to exit): " target_value
        if [ -z "$target_value" ]; then break; fi
        targets+=("$target_value")
    done
}

open_scan() {
    $nmap $hyp --open $1 $do_log
}

ping_scan() {
    $nmap -sP $1 $do_log
}

tcp_scan() {
    $nmap $hyp -sT $1 $do_log
}

syn_scan() {
    sudo $nmap $hyp -sS $1 $do_log
}

version_scan() {
    $nmap $hyp -sV $1 $do_log
}

sam_scan() {
    $nmap -p- -sCV -Pn $1 $do_log
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
    read -p "Delete $log_dir? [y/N] " opt
    case $opt in [Yy]) rm -rf $log_dir ;; esac
    exit 0
}

########## RUNTIME ##########

echo -e "#  NOTE: Run like 'bash recon_nmap.sh target_list.txt' to add extra targets.\n"

set_variables
mkdir -p $log_dir &>/dev/null

scan_interfaces

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
        0) set_new_target ;;
        1) target_prompt; ask_fullscan; open_scan $target_scan ;;
        2) target_prompt; ask_fullscan; ping_scan $target_scan ;;
        3) target_prompt; ask_fullscan; tcp_scan $target_scan ;;
        4) target_prompt; ask_fullscan; syn_scan $target_scan ;;
        5) target_prompt; ask_fullscan; version_scan $target_scan ;;
        8) target_prompt; ask_fullscan; sam_scan $target_scan ;;
        9) custom_command ;;
        s) clear ;;
        r) less $log ;;
        "*") exit_script ;;
    esac

done

# =========x=========

### OJO: UbuntuVM (WP) con 'python3 -m http.server'; un 'nmap -p- localhost' produce un error en varios archivos de '/usr/lib/python3.10/' (socketserver.py, http/server.py, socketserver.py, socket.py)
### TODO: is 'opt' good enough? Safe? Should it be "nulled" after each function?
