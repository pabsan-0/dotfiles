#! /usr/bin/env -S bash

DEFAULT_PORT=8000

echo Serving files from "$PWD"
echo
echo Serving from:
for ip in $(hostname -I); do
    echo "http://$ip:${1-$DEFAULT_PORT}"
done
echo

python3 -m http.server "${1-$DEFAULT_PORT}"
