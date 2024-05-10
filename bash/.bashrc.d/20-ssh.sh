ipof () {
    ssh -G "$1" | awk '/^hostname / { print $2 }'
}
_ipof_completion() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  local hosts=$(awk '/^Host/ {print $2}' ~/.ssh/config)
  COMPREPLY=($(compgen -W "$hosts" -- "$cur"))
}
complete -F _ipof_completion ipof

