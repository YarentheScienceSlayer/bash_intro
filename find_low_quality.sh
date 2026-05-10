#!/usr/bin/env bash
# find_low_quality.sh - Identify reads with low-quality bases (N characters)
# Usage: bash scripts/find_low_quality.sh data/sample2.fastq

set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 <fastq_file>"
    echo "Find reads that contain N (ambiguous) bases, which indicate low quality."
    exit 1
fi

file="$1"

if [ ! -f "$file" ]; then
    echo "Error: File '$file' not found."
    exit 1
fi

echo "=== Reads containing N bases in $file ==="
echo ""

count=0
awk 'NR % 4 == 1 { header = $0 }
     NR % 4 == 2 {
         if ($0 ~ /N/) {
             n_count = gsub(/N/, "N", $0)
             printf "%s\n  Sequence: %s\n  N count: %d\n\n", header, $0, n_count
         }
     }' "$file"

total_reads=$(awk 'END { print NR/4 }' "$file")
n_reads=$(awk 'NR % 4 == 2 && /N/' "$file" | wc -l)
echo "Summary: $n_reads out of $total_reads reads contain N bases."
