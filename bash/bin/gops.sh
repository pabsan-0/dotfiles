#! /usr/bin/env bash

# Ensure the user provided an input file
if [ -z "$1" ]; then
    echo "Usage: $0 <input_video> [separating-tab-size]"
    exit 1
fi

INPUT_FILE="$1"
SEP="${2-6}"

# Process the file, using a subshell to trap Ctrl+C safely for awk
ffprobe -hide_banner -show_frames -i "$INPUT_FILE" 2>&1 | \
    awk -F'=' '
        $1 == "pict_type" {
            type = $2

            if (type == "I") {
                # If this is not the very first I-frame, drop down to a new line
                if (count++ > 0) {
                    printf "\n"
                }
                # Print I followed by a tab
                printf "I\t"
            }
            else if (type == "P") {
                # Print P surrounded by tabs
                printf "\tP\t"
            }
            else {
                # Print B frames normally so they cluster together (e.g., BBBBB)
                printf "%s", type
            }

            # Force immediate terminal output
            fflush()
        }

        END {
            # Print a final newline so your terminal prompt stays clean
            print ""
        }
    ' | expand -t "$SEP"
