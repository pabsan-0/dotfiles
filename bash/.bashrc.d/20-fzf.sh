# Custom fzf navigation
export FZF_DEFAULT_OPTS='--bind "alt-j:down,alt-k:up,ctrl-j:preview-down,ctrl-k:preview-up"'

# Better fzf for hidden files https://github.com/junegunn/fzf/issues/337
export FZF_DEFAULT_COMMAND="find \! \( -path '*/.git' -prune \) -printf '%P\n'"

# Enable CtrlR and friends
source /usr/share/doc/fzf/examples/key-bindings.bash
