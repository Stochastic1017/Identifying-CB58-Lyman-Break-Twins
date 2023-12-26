#!/bin/bash

# Set the output file
merged="merged.csv"

# Initialize a flag to keep track of whether it's the first file
first=true

# Loop through all CSV files in the directory
for file in *.csv; do
    if [ "$first_file" = true ]; then
        # Copy the header from the first file
        head -n 1 "$file" > "$merged"
        first=false
    else
        # Append content (excluding header) from the rest of the files
        tail -n +2 "$file" >> "$merged"
    fi
done

sort -t, -k+2 -n "$merged"

head -n 100 "$merged" > minkowski_best.csv

# Remove redundant files
rm -f [0-9][0-9][0-9][0-9].csv
rm -f merged.csv
