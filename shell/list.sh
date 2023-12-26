#!/bin/bash

# change directiry temporarily
cd ~/data/tgz

for file in *.tgz; do
    echo "${file%%.*}"
done > ~/minkowski/files

cd ~/minkowski
