# Keyboards

I either use a US or ES keyboard on a switching layout, mapped to `super+space`. This behavior is native on Ubuntu GNOME.


## Terminal

Monitor your setup
```
localectl                           # Gets the current language and keyboard model
localectl list-x11-keymap-layouts   # Gets available language layouts, I use us,es
setxkbmap -query                    # This shows your current configuration
```

The following command sets my configuration properly on a terminal.
```
setxkbmap -model pc105 -layout us,es -option grp:win_space_toggle
```

## I3 config file

On `i3wm`, for some reason `setxkbmap` cannot run too soon. Initially I saw that the toggling would only work after an i3 reload.

```
# This did not work
exec_always "setxkbmap -model pc105 -layout us,es -option grp:win_space_toggle"

# But this did!!
exec_always "sleep 5; setxkbmap -model pc105 -layout us,es -option grp:win_space_toggle"
```