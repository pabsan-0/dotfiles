# Dotfiles 

These are my dotfiles. I use these across a few **ubuntu** computers with a few modifications. Do not copypaste blindly.

`stow -R --no-folding vim`

## Usage

#### Dotfiles

You can either replace your system's files or read and paste the bits in here that interest you. My canonical setup method uses `stow`.

Here's an example to stow i3 into your system.
```bash
cd ~
git clone https://www.github.com/pabsan-0/dotfiles
cd dotfiles

stow --no-folding i3
stow --no-folding -R i3
```

#### Software setup

- Applications: Installed from text files. The command to be used is commented at the top of each packages.*.txt files
- Browser extensions: Installed via GUI. A script will open the extension URLs, then I simply click on them.

Here's how I would install all my SW:

```bash

# Apt and snap packages. Snap may fail due to --classic flags
sudo apt install $(sed "s/#.*//g" packages.apt.txt  | xargs)
sudo snap install $(sed "s/#.*//g" packages.snap.txt  | xargs)

# Firefox extensions. This opens a few tabs which need interaction
firefox $(sed "s/#.*//g" packages.ffext.txt  | xargs)
```

## First time setups

Here's a todo list when using these on a new system:
- Install software from text files
- Stow all dotfiles
- If using i3:  
    - Log out and back in
    - Check i3 works in general - it usually will
    - Check i3blocks are working - more prone to conflicts
- Handling credentials:
    - Password manager and extensions
    - Set git user and email automtically


### See also

- [Components](.docs/Components.md) 
- [Issues](.docs/Issues.md)


<img src="./.docs/preview.png" width="640" height="360" />

