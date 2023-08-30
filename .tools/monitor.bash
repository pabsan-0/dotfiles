#! /usr/bin/bash

if [ -e .git ]; then :; else "Run from git repo root!"; fi


for folder in ./*/
do
    pushd "$folder" > /dev/null
    find . -type f | sed "s:^./::g" | xargs -I {} stat -c%N ~/{}
    popd > /dev/null
done

