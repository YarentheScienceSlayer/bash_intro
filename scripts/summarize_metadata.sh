#!/usr/bin/env bash
# summarize_metadata.sh - Summarize sample metadata from a CSV file
# Usage: bash scripts/summarize_metadata.sh data/sample_metadata.csv

set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 <metadata_csv>"
    echo "Display a summary of the sample metadata CSV file."
    exit 1
fi

file="$1"

if [ ! -f "$file" ]; then
    echo "Error: File '$file' not found."
    exit 1
fi

echo "=== Metadata Summary for: $file ==="
echo ""

total=$(tail -n +2 "$file" | wc -l)
echo "Total samples: $total"
echo ""

echo "--- Samples per organism ---"
tail -n +2 "$file" | cut -d',' -f2 | sort | uniq -c | sort -rn
echo ""

echo "--- Samples per condition ---"
tail -n +2 "$file" | cut -d',' -f5 | sort | uniq -c | sort -rn
echo ""

echo "--- Samples per tissue ---"
tail -n +2 "$file" | cut -d',' -f4 | sort | uniq -c | sort -rn
echo ""

echo "--- Unique genes ---"
tail -n +2 "$file" | cut -d',' -f3 | sort -u
