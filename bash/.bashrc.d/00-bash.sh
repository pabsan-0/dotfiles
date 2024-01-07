# Misc exports
export EDITOR="/usr/bin/vim"
export TERMINAL="/usr/bin/konsole"
export PATH="/home/pablo/bin:$PATH"
export DOTFILES="/home/pablo/dotfiles"
export BASHRC_D="/home/pablo/.bashrc.d"


# Bindings for tmux sessioizer
bind '"\C-f":"tmux-sessionizer\n"'
bind '"\C-^":"tmux-sessionizer /home/pablo \n"' # Ctrl Shift `

hhh () {
    source ~/bin/hhh.sh
}

# Straightforward xdg-open, silent
,() {
    xdg-open "$1" 2>&1 >/dev/null &
}

# Straightforward xdg-open
,,() {
    xdg-open "$1"
}


# Create dir and cd in
take() {
    mkdir "$1" && cd "$1"
}


# Cd into directory and ls
cdd() {
    cd "$1" && ls
}


# Print definition and location of function
whereis2() {
    shopt -s extdebug
    declare -f "$1"
    declare -F "$1"
    shopt -u extdebug
}


# Use regex to parse declared funtions in a given shell script
parse_shell_functions () {
    grep -E '^[[:space:]]*([[:alnum:]_]+[[:space:]]*\(\)|function[[:space:]]+[[:alnum:]_]+)' "$1"
}


# Find a file above, return its parent dir
find_up () {
    local path=$(pwd)

    while [[ "$path" != "" && ! -e "$path/$1" ]]; do
        path=${path%/*}
    done
    echo "$path"
}


# Retrieve the directory of the file from where this function is called
this_file_path () {
    local SOURCE=${BASH_SOURCE[0]}
    local DIR=

    # resolve $SOURCE until the file is no longer a symlink
    while [ -L "$SOURCE" ]; do 
        DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
        SOURCE=$(readlink "$SOURCE")
        # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
        [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE 
    done
    echo $( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
}


# Source several files passed as args
source_many () {
    for file in "$@"; do
        if [ -f "$file" ]; then
            source "$file"
        else
            echo "File not found: $file"
        fi
    done
}


# Source all files inside a directory
source_dir () {
    local dir="${1:-.}"

    if [ -d "$dir" ]; then
        for file in "$dir"/*; do
            if [ -f "$file" ] && [[ "$file" =~ \.(sh|bash)$ ]]; then
                source "$file"
            fi
        done
    else
        echo "Directory not found: $dir"
    fi
}


# capture the output of a command so it can be retrieved with ret
cap () { 
    tee /tmp/capture.out; 
}


# return the output of the most recent command that was captured by cap
ret () {
    cat /tmp/capture.out; 
}
