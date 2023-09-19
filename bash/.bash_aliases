find_up () {
    local path=$(pwd)

    while [[ "$path" != "" && ! -e "$path/$1" ]]; do
        path=${path%/*}
    done
    echo "$path"
}

addToPathFront() {
    if [[ "$PATH" != *"$1"* ]]; then
        export PATH=$1:$PATH
    fi
}

# Aliases for configuration
alias conf_dotfiles='code ~/dotfiles'
alias conf_i3='vim ~/.config/i3/config'
alias conf_bashrc='vim ~/.bashrc'
alias conf_vim='vim ~/.vimrc'
alias conf_tmux='vim ~/.tmux.conf'

alias ros_foxy_setup='source /opt/ros/foxy/setup.bash'
alias ros_noetic_setup='source /opt/ros/noetic/setup.bash'

# Aliases for me
alias l='lsd -lah'
alias ,='xdg-open'
alias gitcd='cd $(git rev-parse --show-toplevel)'