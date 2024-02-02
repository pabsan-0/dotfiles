# Vim-like bash history, script implementation, use qq better
hhh () {
    source ~/bin/hhh.sh
}


# Vim-like bash history, preferred macro implementation
qq () {
    # Write history to temp file. Braces allow multiline pipes
    tempfile="$(mktemp)"
    {
    history                                               | 
        sort --numeric-sort                               |
        awk '{$1=""; sub(/^[[:space:]]+/, ""); print $0}' |
        cat > "$tempfile" 
    }

    # Open file in vim, running two commands on startup
    #  1) Focus bottom of file
    #  2) Remap <CR> to erasing all but the current line, then :wq
    vim -c "$" -c "nnoremap <CR> YggVGp:wq!<CR>" "$tempfile" 

    # Store file and num_lines, then cleanup file
    cmd=$(cat "$tempfile")
    len=$(wc -l < "$tempfile")
    rm "$tempfile"

    # If single command found, run and inject it into the history
    if [ "$len" -eq 1 ]; then
        history -s $cmd
        eval $cmd
    else
        echo 'Aborted. Use <CR> to select a command.'
    fi
}


# Edit mode switching 
switch_edit_mode () {
    if  set -o | grep -q '^vi\s*off'; then 
        set -o vi 
        bind '"\C-`":"\eddiswitch_edit_mode\n\C-y"'
        bind 'set show-mode-in-prompt on'
        bind 'set vi-ins-mode-string "\033[1;33m "'
        bind 'set vi-cmd-mode-string "\033[1;32m "'
    else 
        set -o emacs
        bind '"\C-`":"\C-a\C-kswitch_edit_mode\n\C-y"'
        bind 'set show-mode-in-prompt off'
    fi
}
