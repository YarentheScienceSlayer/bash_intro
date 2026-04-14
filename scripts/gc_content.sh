#!/usr/bin/env bash
# gc_content.sh - Calculate GC content of sequences in a FASTQ file
# Usage: bash scripts/gc_content.sh data/sample1.fastq

set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 <fastq_file>"
    echo "Calculate the GC content (%) for each read in a FASTQ file."
    exit 1
fi

file="$1"

if [ ! -f "$file" ]; then
    echo "Error: File '$file' not found."
    exit 1
fi

echo "Read_ID GC%"
echo "------- ---"

awk 'NR % 4 == 1 { header = $0 }
     NR % 4 == 2 {
         seq = $0
         len = length(seq)
         gc = gsub(/[GCgc]/, "", seq)
         if (len > 0)
             printf "%s\t%.1f%%\n", header, (gc / len) * 100
     }' "$file"
