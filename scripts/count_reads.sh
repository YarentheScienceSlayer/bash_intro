#!/usr/bin/env bash
# count_reads.sh - Count the number of reads in FASTQ files
# Usage: bash scripts/count_reads.sh data/sample1.fastq

set -euo pipefail

if [ $# -eq 0 ]; then
    echo "Usage: $0 <fastq_file> [fastq_file2 ...]"
    echo "Count the number of reads in one or more FASTQ files."
    exit 1
fi

for file in "$@"; do
    if [ ! -f "$file" ]; then
        echo "Error: File '$file' not found."
        continue
    fi

    # Each FASTQ read has 4 lines: header, sequence, +, quality
    total_lines=$(wc -l < "$file")
    read_count=$((total_lines / 4))
    echo "$file: $read_count reads"
done
