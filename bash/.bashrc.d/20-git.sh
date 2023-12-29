# Cds into the root of a git repo
gitcd () {
    cd $(git rev-parse --show-toplevel)
}


# Open the remote of a git repo in the browser
gitremote () {
    xdg-open $(git remote get-url origin)
}


## https://medium.com/@GroundControl/better-git-diffs-with-fzf-89083739a9cb
gitdiff () {
    pushd $(git rev-parse --show-toplevel)
    preview="git diff $@ --color=always -- {-1}"
    selected=$(git diff $@ --name-only | fzf -m --ansi --preview "$preview")
    vim "$selected"
    popd
}
