#!/usr/bin/env bash

# This script aids you in seeking sigmf-meta files with non-empty annotation fields,
# previews the first few, then prints the selected file name.
#
# It does NOT parse annotation content, but uses rg as a grep replacement to feed
# filenames into fzf, parsing open braces in the annotations which is much faster than
# parsing every json to check for non-empty annotations.

select_cb() {
    local selected="$(realpath $1)"

    # Companion .sigmf-data
    local data_file="${selected%.sigmf-meta}.sigmf-data"
    local companion_msg="$([[ -f "$data_file" ]] && echo "$data_file" || echo "(not found)")"

    # Print info
    echo
    echo "Sigmf name: ${selected%.sigmf-meta}"
    echo "Sigmf meta: $selected"
    echo "Sigmf data: $companion_msg"
}

preview_cb() {
    local file="$(realpath $1)"

    # Count annotations
    local count
    count=$(jq '.annotations | length' "$file" 2>/dev/null)

    # Companion .sigmf-data
    local data_file="${file%.sigmf-meta}.sigmf-data"
    local companion_msg="$([[ -f "$data_file" ]] && echo "$data_file" || echo "(not found)")"


    # Print info
    echo "Sigmf-meta: $file"
    echo "Sigmf-data: $companion_msg"
    echo "Non-empty annotations count: $count"
    echo "First few annotations:"
    jq '.annotations[:5]' "$file" 2>/dev/null | jq -C .
}

export -f preview_cb

selected=$(
    rg -l '"annotations": \[[^]]' --glob '*.sigmf-meta' . \
      | fzf --prompt="Select a sigmf-meta file: " \
            --preview="preview_cb {}" 
    )

select_cb "$selected"
