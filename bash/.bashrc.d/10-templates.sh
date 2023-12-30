__templates_dir="$HOME/Templates"

a () {
    cp "$__templates_dir$1" "${2-.}"
}

__a_completion ()
{
    local cmd=$1 cur=$2 # pre=$3
    local arr i file

    arr=( $( cd "$__templates_dir" && compgen -f -- "$cur" ) )
    COMPREPLY=()
    for ((i = 0; i < ${#arr[@]}; ++i)); do
        file=${arr[i]}
        if [[ -d $MEMO_DIR/$file ]]; then
            file=$file/
        fi
        COMPREPLY[i]=$file
    done
}

complete -F __a_completion a
