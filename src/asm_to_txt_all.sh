#!/bin/bash

output="all_code.txt"
> "$output"

for file in *.asm; do
    echo "===== $file =====" >> "$output"
    cat "$file" >> "$output"
    echo >> "$output"
done

echo "✅ All .asm files combined into $output"
