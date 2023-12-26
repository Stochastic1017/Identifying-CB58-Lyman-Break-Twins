#!/bin/bash

IFS=$'\n'
data_directory="~/tgz"
output_directory="~/minkowski"

for filename in $(tail -n +2 100_minkowski_best.csv | head -n 10 | cut -d ',' -f 3); do

    echo "Moving to data directory"
    if [[ -d "$data_directory" ]]; then
        cd "$data_directory"
    else
        echo "Error: Data directory does not exist."
        exit 1
    fi

    echo "Currently at: ${filename}"
    pattern="spec-([0-9]+)-([0-9]+)-([0-9]+)\.fits"

    if [[ $filename =~ $pattern ]]; then
        filenumber="${BASH_REMATCH[1]}"
        idnumber="${BASH_REMATCH[2]}"
        fitnumber="${BASH_REMATCH[3]}"
        echo "File Number: ${filenumber}, ID Number: ${idnumber}, Fit Number: ${fitnumber}"

        echo "Unpacking current ${filenumber}.tgz file and sending file to home directory"
        if [[ -e "${filenumber}.tgz" ]]; then
            tar -xzf "${filenumber}.tgz" -C "$output_directory"
        else
            echo "Error: ${filenumber}.tgz not found."
            exit 1
        fi
    else
        echo "Error: No match found. Unable to transfer data from source."
        exit 1
    fi

    echo "Moving to home directory"
    if [[ -d "$output_directory" ]]; then
        cd "$output_directory"
    else
        echo "Error: Output directory does not exist."
        exit 1
    fi

    echo "Finding and retaining ${filename} from ${filenumber}"
    
    filename=$(echo "$filename" | tr -d '"')
    
    echo "Checking if ${filename} exists in ${filenumber}"
    if [[ -e "${filenumber}/${filename}" ]]; then
        mv "${filenumber}/${filename}" "$output_directory"
    else
        echo "Error: ${filename} not found in ${filenumber}."
        exit 1
    fi

    echo "Removing redundant files"
    rm -rf "${filenumber}"

    echo "Finished processing ${filename}"

done

