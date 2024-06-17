_ssh_config_completion() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local hosts=$(awk '/^Host/ {print $2}' ~/.ssh/config)
    COMPREPLY=($(compgen -W "$hosts" -- "$cur"))
}

ipof () {
    ssh -G "$1" | awk '/^hostname / { print $2 }'
}
complete -F _ssh_config_completion ipof


ssh2() {
    echo "Experimental function. May yield unexpected side effects."
    until ssh "$1" 2>&1; do
        echo "retrying..."
        sleep 1
    done
}
complete -F _ssh_config_completion ssh2


ping2() {
    ping $(ipof $1)
}
complete -F _ssh_config_completion ping2
