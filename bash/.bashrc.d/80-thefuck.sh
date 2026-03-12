# Thefuck is a last-command corrector
# Significant uptime, so delayed evaluation to avoid impacting shell start time

alias fuck='if ! declare -f fuck &>/dev/null; then eval "$(thefuck --alias)"; fi && fuck'
alias f='if ! declare -f fuck &>/dev/null; then eval "$(thefuck --alias)"; fi && fuck'
