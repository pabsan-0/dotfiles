#! /usr/bin/env -S bash -x

selected=$(echo -e "bitbucket-token\ngithub-token" | fzf)

bw get password "$selected" | xclip -sel c && sleep 1
