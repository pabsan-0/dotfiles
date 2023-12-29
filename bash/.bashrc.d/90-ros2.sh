ros2_source_foxy () {
    source /opt/ros/foxy/setup.bash
}


ros2_source_ws () {
    pushd $(ros2_parent_ws)
    source install/setup.bash
    echo "$PWD: sourced install/setup.bash"
    popd
}


# Print the path to the ros_ws found above
ros2_parent_ws () {
    path=$(pwd)
    while [[ "$path" != "" && ! -e "$path/install/setup.bash" ]]; do
        path=${path%/*}
    done
    echo "$path"
}


# Print the names of the packages in the current ws
ros2_list_ws_pkgs () {
    # find package.xml, convert fullpath to dirname, filter uniques, then flatten
    find $(ros2_parent_ws) -type f -name package.xml -exec dirname {} \; |\
        awk -F '/' '{print $NF}' | sort -u | xargs
}


# Changedirs to either the upper ros_ws[/*] or a package in it.
ros2_cd () {
    if [[ "$1" = @(src||log|build|install) ]]; then
        cd $(ros2_parent_ws)/"$1"
    else
        pkg=$(find $(ros2_parent_ws)/src -type d -name ${1} -print -quit)
        if [ "$pkg" ]; then
            cd "$pkg"
        else
            echo Failed to find package.
        fi
    fi
}
## Tests pending
# complete -W "$(ros2_list_ws_pkgs)" ros2_cd
complete -F ros2_list_ws_pkgs ros2_cd


# Cleans up the current ros2 workspace towards a rebuild
__ros2_prune_ws_cache () {
    # remove build, but keep install files not to erase setup.bash
    rm -r build
    find install/*/ -type d -exec rm -r {} \;
}
ros2_colcon_clean () {
    pushd $(ros2_parent_ws) && __ros2_prune_ws_cache
    popd
}


# Autocds, builds and sources the current ws
ros2_colcon_build () {
    pushd $(ros2_parent_ws)
    colcon build
    popd
    ros2_source_ws
}


# Fixes a weird issue on vscode, kept as memo
ros2_vscode_fix () {
    unset GTK_PATH
}


# Kills gazebo server and client
ros2_kill_gzserver () {
    kill -9 `pgrep gzclient`
    kill -9 `pgrep gzserver`
}
