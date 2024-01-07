#!/bin/bash

# Change the standard timestamp in zsh_history entries such as
            # : 1704639072:0;docker ps -a
# to        #   2024/01/07 15:51 CET - : 1704639072:0;docker ps -a
# with      #   date -d '@1704639072' +'%Y/%m/%d %H:%M:%S %Z'

get_files(){

    input_file=$(find $HOME -path '**/**/.zsh_history' -or -name '.zsh_history' 2>/dev/null)    # $HOME == /home || /root

    if [ -z $input_file ]; then
            echo "Error: File '.zsh_history' not found at /home or /root (\$HOME)"
            if ! grep 'zsh' /etc/shells; then
                echo "       Shell 'zsh' not found in /etc/shells"
                echo "       Please install zsh and (1) chsh manually or (2) install oh-my-zsh (recommended)"
            else
                echo "       Shell 'zsh' was found in /etc/shells tho, please troubleshoot..."
            fi
            exit 1
    fi

    if [ -d "/tmp" ]; then
        temp_dir="/tmp"
    else
        if [ -n "$TMPDIR" ] && [ -d "$TMPDIR" ]; then       # Termux
            temp_dir="$TMPDIR"
        else
            echo "Error: Unable to find a suitable temporary directory." >&2
            exit 1
        fi
    fi

    output_file="$temp_dir/$(date +%F).zsh_history"

}

export_zsh_history() {

    while IFS= read -r line; do
        if [[ $line =~ :[[:space:]]([0-9]+): ]]; then

            timestamp="${BASH_REMATCH[1]}"
            echo "$(date -d @$timestamp +'%Y/%m/%d %H:%M:%S %Z') - $line" >> "$output_file"

        else
            echo "$line" >> "$output_file"

        fi
    done < "$input_file"

    if [ $? -ne 0 ]; then
        echo 'FAIL'
    else
        echo 'DONE'
    fi

}

get_files
echo "Total lines in '$input_file': $(wc -l $input_file | awk '{print $1}')"

while true; do

    read -p "Log '$input_file' at '$output_file'? [Y/n] " user_input

    case $user_input in
        'y'|'Y'|'') export_zsh_history && break ;;
        'n'|'N') echo "Script terminated" && exit 1 ;;
        *)  echo "Please answer Y or N" ;;
    esac

done


# cron() {
#     crontab -e "0 0 * * * /path/to/backup_script.sh"
# }


# ========x=========

# In Bash, the =~ operator is used for pattern matching within the [[ ... ]] conditional expression. When a match occurs, Bash sets the BASH_REMATCH array with the portions of the string that matched the regular expression.
# In the regular expression :[[:space:]]([0-9]+):, the part ([0-9]+) is enclosed in parentheses. This is called a capturing group, and it captures the matched digits (the numbers you are interested in) within the parentheses. The [0-9]+ part ensures that one or more digits are matched.
# So, when a line matches the pattern, the value of the matched digits is stored in the BASH_REMATCH array. The index [1] corresponds to the first capturing group, which is the part ([0-9]+) in the regular expression.
# For example, if the line is : 1704501232:0;bash zsh.sh, the regular expression matches the numbers between ': ' and ':' (1704501232). The value is stored in BASH_REMATCH[1], and then it's assigned to extracted_number using the syntax ${BASH_REMATCH[1]}. As a result, extracted_number holds the value '1704501232'.

# In each iteration of the loop, the BASH_REMATCH array is updated with the results of the most recent successful pattern match. Specifically, ${BASH_REMATCH[1]} corresponds to the content captured by the first set of parentheses in your regular expression.
# This behavior allows you to capture different parts of the matched string in a more complex regular expression with multiple capturing groups.
# In your case, since you have a simple regular expression with only one capturing group (([0-9]+)), you are using ${BASH_REMATCH[1]} to access the matched digits directly. If you had more capturing groups, you would use additional indices like ${BASH_REMATCH[2]}, ${BASH_REMATCH[3]}, and so on.
# Just be aware that after each successful match, the entire BASH_REMATCH array is updated with the results of the latest match, and any previous values are overwritten. So, if you need to preserve multiple matches simultaneously, you might need to store them in separate variables within the loop or process them immediately.

# TODO: measure performance on different loop statements

# MIND --> $HISTFIlE (either .zsh_history or .bash_history)

# https://serverfault.com/questions/225798/can-i-make-find-return-non-0-when-no-matching-files-are-found
