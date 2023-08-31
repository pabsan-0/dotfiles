#! /usr/bin/bash

for ws in {1..10}
do
    i3-save-tree --workspace "$ws"
done