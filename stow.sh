#! /usr/bin/env bash 

# Convenience util to stow using the default args I always type in

set -x
stow -R --no-folding ${@}
