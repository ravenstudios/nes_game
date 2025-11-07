#!/bin/bash

# output file
output="all_code.txt"

# clear previous output
> "$output"

# loop through every .asm file (recursively)
for file in $(find . -type f -name "*.asm"); do
    echo "===== $file =====" >> "$output"
    cat "$file" >> "$output"
    echo -e "\n" >> "$output"
done

echo "✅ All .asm files combined into $output"
