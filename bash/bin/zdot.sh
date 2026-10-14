#!/bin/sh

[ -n "$1" ] || { echo "usage: ${0##*/} file.dot" >&2; exit 1; }

dot -Tpdf "$1" | zathura -
