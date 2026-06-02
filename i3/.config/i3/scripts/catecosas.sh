#!/usr/bin/env bash

export TERMINAL="konsole -e bash -c"

read -r -d '' YAML <<'YAML' || true

github:                            xdg-open https://github.com/$(git config user.name)
github/gists:                      xdg-open https://gist.github.com/$(git config user.name)
github/repos-org:                  ${TERMINAL} "i3-msg fullscreen enable; exec repos-org --no-term fluendo"
github/repos:                      ${TERMINAL} "i3-msg fullscreen enable; exec repos pabsan-0"

gmail:                             xdg-open https://mail.google.com/
tasks:                             xdg-open https://tasks.google.com/tasks
calendar:                          xdg-open https://calendar.google.com/calendar/u/0/r/week
meet:                              xdg-open https://meet.google.com/landing
meet/new:                          xdg-open https://meet.google.com/new
jira:                              xdg-open https://fluendo.atlassian.net/jira/for-you
jira/open:                         xdg-open https://fluendo.atlassian.net/issues/?filter=-1
jira/manual:                       xdg-open https://fluendo.atlassian.net/wiki/spaces/JG/pages/3359866921/Tasks+workflow
confluence:                        xdg-open https://fluendo.atlassian.net/wiki/home
confluence/company-handbook:       xdg-open https://fluendo.atlassian.net/wiki/spaces/COM/
confluence/how-to-work-eng-team:   xdg-open https://fluendo.atlassian.net/wiki/spaces/ENG/pages/3052077073/How+to+work+in+engineering+team#Merge-to-master
drive/consulting-services:         xdg-open https://drive.google.com/drive/folders/1bZHaoo798QsFkgsvHMW7e8iB1jSx3fxX

gemini:                            xdg-open https://gemini.google.com/app
gh-copilot:                        xdg-open https://github.com/copilot

slack:                             xdg-open https://app.slack.com/client/T2VDBJWL8/D0AL20K8V45
kenjo:                             xdg-open https://app.kenjo.io/
kenjo/attendances:                 xdg-open https://app.kenjo.io/cloud/attendance/my-attendance
travelperk:                        xdg-open https://fluendo.perk.com/home/

term/lazyjira:                     ${TERMINAL} "i3-msg fullscreen enable; exec lazyjira"
term/gh-dash:                      ${TERMINAL} "i3-msg fullscreen enable; exec gh dash 2>/dev/null"
term/gst-1.26.2:                   ${TERMINAL} "i3-msg fullscreen enable; cd /opt/gstreamer--pinned/1.26.8/ && vim -c 'set clipboard=unnamedplus' "

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
