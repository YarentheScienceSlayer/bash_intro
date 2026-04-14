#!/usr/bin/env bash
# extract_sequences.sh - Extract only the DNA sequences from a FASTQ file
# Usage: bash scripts/extract_sequences.sh data/sample1.fastq

set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 <fastq_file>"
    echo "Extract DNA sequences (every 2nd line out of 4) from a FASTQ file."
    exit 1
fi

file="$1"

if [ ! -f "$file" ]; then
    echo "Error: File '$file' not found."
    exit 1
fi

# In a FASTQ file, the sequence is on lines 2, 6, 10, ... (every 4th line starting at 2)
awk 'NR % 4 == 2' "$file"
