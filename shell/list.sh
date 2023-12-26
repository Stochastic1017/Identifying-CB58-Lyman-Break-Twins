#!/bin/bash

cd ~/data/tgz

for file in [0-9][0-9][0-9][0-9].tgz; do
    echo "${file%%.*}"
done > ~/minkowski/files

cd ~/minkowski
