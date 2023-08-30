## Stow

Stow is a symlink farm manager.

Calling stow on those packages will symlink the filetree below them, appending them to `target-directory`. The target directory is the one above the `stow-directory` with gnu `stow`.

#### Stow example
```
$ tree target-directory

target-directory
├── stow-directory
│   ├── package-1
│   │   └── .dotfile-1
│   └── package-2
│      └── .config
|           └── .dotfile-2

$ cd target-directory/stow-directory
$ stow package-1 package-2
$ tree ../../target-directory

target-directory
├── stow-directory
│   ├── package-1
│   │   └── .dotfile-1
│   └── package-2
│      └── .config
|           └── .dotfile-2
├── .dotfile-1  -> stow-dir/package-1/.dotfile-1          # new!
├── .config                                               # new!
│      └── .dotfile-2  -> stow-dir/package-2/.dotfile-2   # new!
```


#### Stow --adopt example

```
$ tree target-directory

target-directory
├── stow-directory
│   ├── package-1
│   │   └── .dotfile-1  # empty or not
├── .dotfile-1          # not a symlink, but an old file


$ cd target-directory/stow-directory
$ stow --adopt package-1
$ tree ../../target-directory

target-directory
├── stow-directory
│   ├── package-1
│   │   └── .dotfile-1                              # rewritten!
├── .dotfile-1  -> stow-dir/package-1/.dotfile-1    # replaced by symlink
```

### Acknowledgements

- https://www.jakewiesler.com/blog/managing-dotfiles#understanding-stow