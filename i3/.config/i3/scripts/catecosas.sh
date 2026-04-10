#!/usr/bin/env bash

read -r -d '' YAML <<'YAML' || true

github/repos:                      $HOME/bin/repos-org-rofi
github/gists:                      xdg-open https://gist.github.com/$(git config user.name)
github/repos-pabsan:               xdg-open https://github.com/$(git config user.name)?tab=repositories

gmail:                             xdg-open https://mail.google.com/
tasks:                             xdg-open https://tasks.google.com/tasks
calendar:                          xdg-open https://calendar.google.com/calendar/u/0/r/week
meet:                              xdg-open https://meet.google.com/landing
jira:                              xdg-open https://fluendo.atlassian.net/jira/for-you
jira/open:                         xdg-open https://fluendo.atlassian.net/issues/?filter=-1
jira/manual:                       xdg-open https://fluendo.atlassian.net/wiki/spaces/JG/pages/3359866921/Tasks+workflow
confluence:                        xdg-open https://fluendo.atlassian.net/wiki/home
confluence/company-handbook:       xdg-open https://fluendo.atlassian.net/wiki/spaces/COM/
drive/consulting-services:         xdg-open https://drive.google.com/drive/folders/1bZHaoo798QsFkgsvHMW7e8iB1jSx3fxX

gemini:                            xdg-open https://gemini.google.com/app
gh-copilot:                        xdg-open https://github.com/copilot

slack:                             xdg-open https://app.slack.com/client/T2VDBJWL8/D0AL20K8V45
kenjo:                             xdg-open https://app.kenjo.io/
kenjo/attendances:                 xdg-open https://app.kenjo.io/cloud/attendance/my-attendance
travelperk:                        xdg-open https://fluendo.perk.com/home/


YAML

main() {
    selected="$(
        printf '%s' "$YAML" |
        yq -r '. | to_entries[].key' |
        rofi -dmenu -i -p "pabsan-0";
    )"
    if [[ -z "${selected:-}" ]]; then
        exit 0
    else
        cmd="$(printf '%s' "$YAML" | yq -r ".[\"$selected\"]")"
        bash -lc "$cmd"
    fi

    # Debug info
    # echo "$0:$selected:$cmd" | xargs dunstify
}
main

## Does not work with new versions' YAML syntax, neither do I need it rn
# open_in_terminal () {
#     if command -v konsole >/dev/null; then
#         konsole -e "$1"
#     elif command -v terminator >/dev/null; then
#         terminator -e "$1"
#     elif command -v gnome-terminal >/dev/null; then
#         gnome-terminal -- bash -c "$1; read -p 'Press Enter to exit'"
#     elif command -v x-terminal-emulator >/dev/null; then
#         x-terminal-emulator -e "$1"
#     else
#         echo "No supported terminal emulators found."
#     fi
# }
