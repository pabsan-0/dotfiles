__templates_dir="$HOME/Templates"

ftemplate () {
    selected=$(cd $__templates_dir && fzf --preview 'cat {}') 
    if [[ $selected ]]; then
        cp -vi "$__templates_dir/$selected" "$PWD"
    fi
}


template () {
    cp -vi "$__templates_dir/$1" "${2-.}"
}

__template_completion ()
{
    local cmd=$1 cur=$2 pre=$3
    local arr i file


    if [ $COMP_CWORD -gt 2 ]; then
        COMPREPLY=()

    elif [ $COMP_CWORD -gt 1 ]; then
        compopt -o default

    else
        arr=( $( cd "$__templates_dir" && compgen -f -- "$cur" ) )
        COMPREPLY=()
        for ((i = 0; i < ${#arr[@]}; ++i)); do
            file=${arr[i]}
            if [[ -d $__templates_dir/$file ]]; then
                file=$file/
            fi
            COMPREPLY[i]=$file
        done
    fi
}

complete -o nospace -F __template_completion template
