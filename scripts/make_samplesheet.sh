#!/bin/bash
# Set the input folder and output file based on command-line arguments
input_folder=$1
output_file="sample.tsv"

# Check if the input folder was provided
if [ -z "$input_folder" ]; then
  echo "Error: Input folder must be specified." >&2
  exit 1
fi

# Make sure the input folder exists
if [ ! -d "$input_folder" ]; then
  echo "Error: Input folder does not exist." >&2
  exit 1
fi

# Process the files in the input folder
for file in "$input_folder"/*.gz; do
    echo "$file"
done | paste - - | awk '{print $0=$1"\t"$1"\t"$2}' | \
    # paste the output into three columns
    awk -v "OFS=\t" '{$1=$1; sub(/^.*Exp8/, "Exp8", $1); split($1, arr, "_"); $1=arr[1]}1' | \
    # replace everything up to "MB" in only the first column and remove everything after the 2nd underscore
    sed $'1 i\\\nsampleID\tforwardReads\treverseReads' > "$output_file"
    # add header and save the output in the sample.tsv file
