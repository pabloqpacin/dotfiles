#!/bin/bash

echo -e "\n----###############################################################----"
echo -e "#########~~~~~{     R3C0N NM4P v1.3  by @pabloqpacin    }~~~~~#########"
echo -e "----###############################################################----\n"

# Basic addresses throughout session
targets=("_gateway" "localhost" "scanme.nmap.org")
net=$(ip route | grep 'link src' | head -n1 | awk '{print $1}')
ip=$(ip route | grep 'link src' | head -n1 | awk '{print $9}')
# distro=$(awk -F '=' 'NR == 3 {print $2}' /etc/os-release 2>/dev/null || uname -o)

# Targets and $1 list
echo -e "#  NOTE: Run './recon_nmap.sh target_list.txt' to add extra targets.  #\n"
if [ -n "$1" ]
    then target_list="$1"
    while IFS= read -r line
        do targets+=("$line")
    done < "$target_list"
fi

# Logging scans
log_dir=/tmp/recon; mkdir $log_dir &>/dev/null
log_name=$(date +%Y-%m-%d)
log_temp="$log_dir/scan.txt"
log="$log_dir/$log_name.txt"

# Determine whether to 'grc' -- https://github.com/garabik/grc
if command -v grc &>/dev/null
    then nmap="grc nmap"
    else nmap="nmap"
fi

# Fetch interfaces
read -p "Scan network interfaces? [y/N] " opt
if [[ $opt == "Y" || $opt == "y" ]]
    then $nmap --iflist
fi

# 0)
function set_target {
    while true
        do read -p "Set new target domain or IP (or press Enter to exit): " target_value
        if [ -z "$target_value" ]; then
            break
        fi
        targets+=("$target_value")
    done
}

# function set_target {
#     for i in {3..5}; do
#         local target_variable="target_$i"
#         if [ -z "${!target_variable}" ]; then
#             read -p "Set new target domain or IP for $target_variable: " "${target_variable}"
#             # "${target_variable}"="$1"
#             break
#         fi
#     done
# }

# 1)
function open_target {
    $nmap --open $1 -oN $log_temp
}

# 2)
function ping_scan_target {
    $nmap -sP $1 -oN $log_temp
}

# 3)
function TCP_scan_target {
    $nmap -sT $1 -oN $log_temp
}

# 4)
function SYN_scan_target {
    sudo $nmap -sS $1 -oN $log_temp
}

# 5)
function Version_scan_target {
    $nmap -sV $1 -oN $log_temp
    # script -qc "$nmap -sV $1" -a $log; sed_del
}

# MORE: nmap scripts...

# 8)
function Sam_scan {
    $nmap -p- -sCV -Pn $1 -oN $log_temp
}

# 9)
function custom_command {
    read -p "Enter the command to be run: " custom
    (eval "$custom")
}

# *)
function exit_script {
    read -p "Delete $log_dir? [Y/n] " opt
    if [[ $opt == "Y" || $opt == "y" || $opt == "" ]]
        then rm -rf $log_dir
    fi
    exit 0
}

# Determine target for every scan -- https://www.gnu.org/software/bash/manual/html_node/Arrays.html; https://opensource.com/article/18/5/you-dont-know-bash-intro-bash-arrays
function target_prompt {
    read -p "Enter target IPv4, domain name or keyword (net, ip, t1 t2 ...): " target_answer

    if [[ $target_answer == t* ]]
        then local target_index="${target_answer#t}"
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
    echo -e "#######################################################################\n"
}

# function target_prompt {
#     local target_answer=""
#     read -p "Enter target IPv4, domain name or keyword (e.g. net ip t1 t2 t3...): " target_answer
#     case $target_answer in
#         "ip") target_scan="$ip" ;;
#         "net") target_scan="$net" ;;
#         "t1") target_scan="${targets[0]}" ;;
#         "t2") target_scan="${targets[1]}" ;;
#         "t3") target_scan="${targets[2]}" ;;
#         "t4") target_scan="${targets[3]}" ;;
#         "t5") target_scan="${targets[4]}" ;;
#         "t6") target_scan="${targets[5]}" ;;
#         "t7") target_scan="${targets[6]}" ;;
#         "t8") target_scan="${targets[7]}" ;;
#         "t9") target_scan="${targets[8]}" ;;
#         *) target_scan="$target_answer" ;;
#     esac
# }

while true
do
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
    # echo -e "\t6)   *WIP*                          --script"
    # echo -e "\t7)   *WIP*                          --script"
    echo -e "\t8) Sam scan -----------------------> nmap -p- -sCV -Pn -T4 ..."
    echo -e "\t9) Custom command."
    echo -e "\ts) Clear screen."
    echo -e "\tr) Read log."
    echo -e "\t*) Exit.\n"
    
    read -p "Select action: " opt
    # read -p "Enter target: " target_scan

    case $opt in
        "0") set_target ;;
        "1") target_prompt; open_target $target_scan ;;
        "2") target_prompt; ping_scan_target $target_scan ;;
        "3") target_prompt; TCP_scan_target $target_scan ;;
        "4") target_prompt; SYN_scan_target $target_scan ;;
        "5") target_prompt; Version_scan_target $target_scan ;;
        "8") target_prompt; Sam_scan $target_scan ;;
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
