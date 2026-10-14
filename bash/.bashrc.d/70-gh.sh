# A hijacking of github CLI that, when creating a PR
# auto-sets its title to the current branch.
gh() {
    if [[ "$1" == "pr" && "$2" == "create" ]]; then
        shift 2
        local has_title=0
        local arg

        for arg in "$@"; do
            case "$arg" in
                --title|-t|--title=*)
                    has_title=1
                    break
                    ;;
            esac
        done

        if (( has_title )); then
            command gh pr create "$@"
        else
            echo 'Running hijacked command: gh pr create --title $(git branch --show-current) $@'
            command gh pr create --title "$(git branch --show-current)" "$@"
        fi

    # elif [[ "$1" == "worktree" && "$2" == "remove" && $(($# != 3 )) ]]; then
    #     mkdir -p _"archived"
    #     mv "$3" "_archived/$3"
    #     command gh $@
    else
        command gh "$@"
    fi
}
