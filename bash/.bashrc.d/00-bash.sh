# Create dir and cd in
take() {
    mkdir "$1" && cd "$1"
}


# Cd into directory and ls
cdd() {
    cd "$1" && ls
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
