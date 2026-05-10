#!/usr/bin/env bash
# filter_by_organism.sh - Filter FASTQ reads by organism from the header line
# Usage: bash scripts/filter_by_organism.sh data/sample1.fastq "Homo sapiens"

set -euo pipefail

if [ $# -ne 2 ]; then
    echo "Usage: $0 <fastq_file> <organism>"
    echo "Filter reads whose header contains the specified organism name."
    echo "Example: $0 data/sample1.fastq 'Homo sapiens'"
    exit 1
fi

file="$1"
organism="$2"

if [ ! -f "$file" ]; then
    echo "Error: File '$file' not found."
    exit 1
fi

# Use awk to print 4-line FASTQ records where the header matches the organism
awk -v org="$organism" '
    /^@/ && $0 ~ org {
        print; getline; print; getline; print; getline; print
    }
' "$file"
