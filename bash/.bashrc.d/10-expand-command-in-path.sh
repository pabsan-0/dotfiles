# A combo shortcut to directly expand a filename in PATH to its realpath

_resolve_command_in_path() {
  local word resolved

  # Grab the last word from the current readline buffer
  word=${READLINE_LINE##* }

  # Guard: empty input or trailing space
  [[ -z $word || $READLINE_LINE =~ [[:space:]]$ ]] && return 0

  # Resolve command
  resolved=$(command -v -- "$word" 2>/dev/null) || {
    printf "\aCannot expand '%s'\n" "$word" >&2
    return 0
  }

  # Replace only the last word
  READLINE_LINE="${READLINE_LINE%$word}$resolved"
  READLINE_POINT=${#READLINE_LINE}
}

bind -x '"\C-x=": _resolve_command_in_path'

