#! /usr/bin/env bash

packages_apt=(
    # Basic utilities
    stow               # Dotfiles (symlink) manager
    vim                # Text editor
    vim-gtk3           # provides clipboard integration, etc
    konsole            # Low input latency terminal
    tmux               # Terminal multiplexer
    tmuxinator         # tmux compositor

    # Window manager and desktop
    i3                 # main WM
    i3lock             # Lock screen
    i3status           # i3 status bar
    i3blocks           # i3 status bar app compositor
    compton            # Window transparency renderer
    dmenu              # Fallback application launcher
    rofi               # Application launcher, window menu and more
    feh                # Sets window background
    lxappearance       # GUI customiser
    xbacklight         # Brightness controls
    fonts-font-awesome # Emoji charset
    diodon             # clipboard manager

    # Hardware interactions
    xserver-xorg-input-synaptics  # sensible touchpad defaults, requires reboot
    pavucontrol        # GUI volume mixer
    flameshot          # print screen button
    udiskie            # auto usb mounter
    xbindkeys          # keyboard remaps
    xvkbd              # keyboard actions

    # Useful extras
    xdotool            # X window utilities
    snap               # Yet another package manager
    lm-sensors         # Monitor CPU temperature
    fzf                # the fuzzy finder
    ripgrep            # grep but faster
    task-spooler       # task spooler for job queueing

    # Funky stuff
    neofetch           # System stats
    fortune            # Random quotes
    cowsay             # Funky animal display
    sl                 # Steam machine, yay!

    # Integrations
    rclone             # OneDrive CLI API
    gh                 # github api && other utils

    # Hardware
    brightnessctl      # control brightness
    arandr             # xrandr gui
    autorandr          # auto randr
)

packages_snap=(
    spotify
    code
    brave
    bitwarden
    bw
)

# Public packages as listed above
set -x
sudo apt install "${packages_apt[@]}"
sudo snap install "${packages_snap[@]}"

# Custom github packages
mkdir -p /opt/pabsan-0
cd /opt/pabsan-0 && (
    git clone https://github.com/pabsan-0/flashcards && (
        cd flashcards &&
        ln -s "$PWD/flashcards.bash" "$HOME/bin/flashcards"
    )

    git clone https://github.com/pabsan-0/fortunes && (
        cd fortunes &&
        fortune_pabsan --update &&
        ln -s "$PWD/fortune" "$HOME/bin/fortune_pabsan"
    )

    git clone https://github.com/pabsan-0/snippets
)
