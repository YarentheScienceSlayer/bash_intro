#!/usr/bin/env bash
# search_gene.sh - Search for reads matching a specific gene in FASTQ files
# Usage: bash scripts/search_gene.sh "TP53" data/*.fastq

set -euo pipefail

if [ $# -lt 2 ]; then
    echo "Usage: $0 <gene_name> <fastq_file> [fastq_file2 ...]"
    echo "Search for reads matching a gene name across one or more FASTQ files."
    echo "Example: $0 TP53 data/*.fastq"
    exit 1
fi

gene="$1"
shift

echo "=== Searching for gene: $gene ==="
echo ""

total_hits=0

for file in "$@"; do
    if [ ! -f "$file" ]; then
        echo "Warning: File '$file' not found, skipping."
        continue
    fi

    hits=$(grep -c "$gene" "$file" 2>/dev/null || true)
    if [ "$hits" -gt 0 ]; then
        echo "--- $file ($hits match(es)) ---"
        grep "$gene" "$file"
        echo ""
        total_hits=$((total_hits + hits))
    fi
done

echo "Total matches found: $total_hits"
