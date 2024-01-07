# Source me for best compatibility with aliases
# Else, execute. Do NOT place a shebang

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

