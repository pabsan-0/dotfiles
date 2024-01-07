# Custom fzf navigation
export FZF_DEFAULT_OPTS='--bind "alt-j:down,alt-k:up,ctrl-j:preview-down,ctrl-k:preview-up" '

# Preview files by default
export FZF_DEFAULT_OPTS+=' --preview "batcat --color always {} 2>/dev/null || tree {}" '

# Better fzf for hidden files https://github.com/junegunn/fzf/issues/337
export FZF_DEFAULT_COMMAND="find \! \( -path '*/.git' -prune \) -printf '%P\n'"

# Enable CtrlR and friends
source /usr/share/doc/fzf/examples/key-bindings.bash


# Vim.fzf like fzf, may receive program to run file as arg
F () {
    ${1-"echo"} $(
        fzf --preview 'batcat --color always {} 2>/dev/null || tree {}' |
        awk '{print $1;}'                                               |
        xargs realpath                                                  ;
    )
}

# Vim.fzf like ripgrep, may receive program to run file as arg
R () {
    ${1-"batcat"} $(
        rg -m 1 -L --line-number --with-filename . --color=always --field-match-separator ' ' 2>/dev/null |
        fzf --ansi --preview "batcat --color=always {1} --highlight-line {2}"                             | 
        awk '{print $1;}'                                                                                 |
        xargs realpath 2>/dev/null                                                                        ;
    )
}


# Vim.fzf like Snippets util, may receive program to run file as arg
S () {
    pushd ~/snippets > /dev/null
    R "${1-"batcat"}"
    popd > /dev/null
}
