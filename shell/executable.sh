#!/bin/bash

# untar your R installation. Make sure you are using the right version!
echo "Unpacking R413.tar.gz ..."
tar -xzf R413.tar.gz

# (optional) if you have a set of packages (created in Part 1), untar them also
echo "Unpacking packages_FITSio.tar.gz ..."
tar -xzf packages_FITSio.tar.gz

# make sure the script will use your R installation, 
# and the working directory as its home location
export PATH=$PWD/R/bin:$PATH
export RHOME=$PWD/R
export R_LIBS=$PWD/packages

echo "Unpacking current *.tgz file"
tar -xzf $2.tgz

# run your script
Rscript minkowski_spectra.R $1 $2
