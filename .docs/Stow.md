# Stow

Stow is a symlink manager. 

By default, will take a directory and symlink all of its contents one dir above.

A few complications may arise:

- Stowing already existing files: use `stow -R dir` to restow files already "installed"
- Stowing directories: Files created in the symlinks may end up falling in the sources. This is not desirable. Use `stow --no-folding` to symlink only the last file in each filetree, instead of creating links for folders.


