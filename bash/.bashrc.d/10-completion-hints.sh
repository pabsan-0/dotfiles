# A completion enhanced that will underline what you've typed.
# Useful for browsing files with very similar names.

hinted_complete() {
    local prefix="$1"
    compgen -f -- "$prefix" | while IFS= read -r f; do
        local rest="${f#$prefix}"
        # Underline the prefix, keep rest as-is
        echo -e "\e[4m$(basename "$prefix")\e[24m${rest}"
    done | column
}

_hinted_complete_trigger() {
    local full_line="$READLINE_LINE"
    local cursor_pos=$READLINE_POINT

    # Get the current word fragment (for filename match)
    local cur_word="${READLINE_LINE:0:READLINE_POINT}"
    local current_token="${cur_word##* }"

    echo "${PS1@P}${full_line}"
    hinted_complete "$current_token"

    # Restore input line — Bash will redraw the prompt automatically
    READLINE_LINE="$full_line"
    READLINE_POINT=$cursor_pos
}

bind -x '"\C-x\C-f":_hinted_complete_trigger'
