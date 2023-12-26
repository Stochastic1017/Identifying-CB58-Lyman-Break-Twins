#!/bin/bash

# untar R installation on compute node.
echo "Unpacking R413.tar.gz ..."
tar -xzf R413.tar.gz

# untar required libraries
echo "Unpacking packages_FITSio.tar.gz ..."
tar -xzf packages_FITSio.tar.gz

# path dependencies for compute nodes to run 'Rscript'
export PATH=$PWD/R/bin:$PATH
export RHOME=$PWD/R
export R_LIBS=$PWD/packages

# unpack current .tgz file
echo "Unpacking current *.tgz file"
tar -xzf $2.tgz

# run R script
Rscript minkowski_spectra.R $1 $2
