
paws() {
    # Extract the output format from the command arguments
    local output_format
    output_format=$(echo "$@" | grep -oP '(?<=--output )\S+')

    # If no output format is provided, default to json
    if [ -z "$output_format" ]; then
        output_format="json"
    fi

    case $output_format in
        yaml)
            aws "$@" | bat -l yaml
            ;;
        # text)
        #     grc -c ~/.grc/aws.conf  aws "$@"
        #     # aws "$@" | grc -c ~/.grc/aws.conf | less -R
        #     ;;
        text | table)
            aws "$@" | less -SFXR
            ;;
        json)
            aws "$@" | jq -C | bat -p
            ;;
        *)
            aws "$@" |jq -C | bat -p 
            ;;
    esac
}



