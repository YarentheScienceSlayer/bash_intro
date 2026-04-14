# Bash for Bioinformatics — A Lab Intro 🧬

A hands-on guide to essential bash commands for working with biological data. This tutorial uses real-world FASTQ files and metadata so you can practice on the command line right away.

## Table of Contents

- [Getting Started](#getting-started)
- [Repository Layout](#repository-layout)
- [What Is a FASTQ File?](#what-is-a-fastq-file)
- [Bash Basics](#bash-basics)
  - [Navigating the File System](#1-navigating-the-file-system)
  - [Viewing File Contents](#2-viewing-file-contents)
  - [Searching with grep](#3-searching-with-grep)
  - [Counting and Summarizing with wc](#4-counting-and-summarizing-with-wc)
  - [Sorting and Finding Unique Values](#5-sorting-and-finding-unique-values)
  - [Cutting Columns from CSVs](#6-cutting-columns-from-csvs)
  - [Piping Commands Together](#7-piping-commands-together)
  - [Using awk for Column-based Data](#8-using-awk-for-column-based-data)
  - [Redirecting Output to Files](#9-redirecting-output-to-files)
  - [Loops for Batch Processing](#10-loops-for-batch-processing)
- [Ready-to-Use Scripts](#ready-to-use-scripts)
- [Practice Exercises](#practice-exercises)
- [Quick Reference](#quick-reference)

---

## Getting Started

Clone this repository and navigate into it:

```bash
git clone https://github.com/YarentheScienceSlayer/bash_intro.git
cd bash_intro
```

No extra software is needed — just a terminal.

---

## Repository Layout

```
bash_intro/
├── README.md                  # This tutorial
├── CHEATSHEET.md              # Quick-reference card
├── data/
│   ├── sample1.fastq          # FASTQ reads (10 reads, clean)
│   ├── sample2.fastq          # FASTQ reads (10 reads, some low-quality)
│   ├── genes.txt              # List of gene names
│   └── sample_metadata.csv    # Sample information table
└── scripts/
    ├── count_reads.sh          # Count reads in FASTQ files
    ├── extract_sequences.sh    # Pull out DNA sequences
    ├── filter_by_organism.sh   # Filter reads by species
    ├── gc_content.sh           # Calculate GC content per read
    ├── find_low_quality.sh     # Find reads with N (ambiguous) bases
    ├── search_gene.sh          # Search for a gene across files
    └── summarize_metadata.sh   # Summarize the metadata CSV
```

---

## What Is a FASTQ File?

FASTQ is the standard format for storing sequencing reads. Every read occupies **four lines**:

```
@SEQ_ID_001 Homo sapiens mRNA for TP53, sample 1          ← Header (starts with @)
GATTTGGGGTTCAAAGCAGTATCGATCAAATAGTAAATCCATTTGTTCAACTCACAGTTT  ← DNA sequence
+                                                              ← Separator
!''*((((***+))%%%++)(%%%%).1***-+*''))**55CCF>>>>>>CCCCCCC65   ← Quality scores (ASCII)
```

| Line | Contains | Notes |
|------|----------|-------|
| 1 | Header | Starts with `@`, holds read ID and description |
| 2 | Sequence | The actual A, T, G, C bases (N = unknown) |
| 3 | Separator | Always `+` (sometimes repeats the header) |
| 4 | Quality | One ASCII character per base — higher = better |

---

## Bash Basics

All examples below use the files in the `data/` directory. Run each command from the **repository root**.

### 1. Navigating the File System

```bash
pwd                  # Print current directory
ls                   # List files and folders
ls data/             # List contents of the data directory
ls -lh data/         # Long format with human-readable file sizes
cd data              # Move into the data directory
cd ..                # Move back up one level
```

### 2. Viewing File Contents

```bash
cat data/sample1.fastq          # Print the entire file
head data/sample1.fastq         # Show the first 10 lines
head -n 8 data/sample1.fastq    # First 8 lines (= first 2 reads)
tail -n 4 data/sample1.fastq    # Last 4 lines (= last read)
less data/sample1.fastq         # Scroll through the file (press q to quit)
```

### 3. Searching with `grep`

```bash
# Find all header lines (start with @)
grep "^@" data/sample1.fastq

# Find reads related to TP53
grep "TP53" data/sample1.fastq

# Search across multiple files
grep "BRCA1" data/*.fastq

# Count how many reads mention Homo sapiens
grep -c "Homo sapiens" data/sample1.fastq

# Find lines containing N bases (low quality) in sequences
grep "NNN" data/sample2.fastq
```

### 4. Counting and Summarizing with `wc`

```bash
# Count lines, words, and characters
wc data/sample1.fastq

# Count only lines
wc -l data/sample1.fastq

# Quick read count: total lines / 4
echo "$(( $(wc -l < data/sample1.fastq) / 4 )) reads"

# Count lines in all FASTQ files
wc -l data/*.fastq
```

### 5. Sorting and Finding Unique Values

```bash
# Sort genes alphabetically
sort data/genes.txt

# Get unique organisms from the metadata
tail -n +2 data/sample_metadata.csv | cut -d',' -f2 | sort -u

# Count samples per organism
tail -n +2 data/sample_metadata.csv | cut -d',' -f2 | sort | uniq -c | sort -rn
```

### 6. Cutting Columns from CSVs

```bash
# Show just the gene column (column 3)
cut -d',' -f3 data/sample_metadata.csv

# Show sample_id and condition (columns 1 and 5)
cut -d',' -f1,5 data/sample_metadata.csv

# Get all tissue types
tail -n +2 data/sample_metadata.csv | cut -d',' -f4 | sort -u
```

### 7. Piping Commands Together

Pipes (`|`) let you chain commands — the output of one feeds into the next:

```bash
# How many unique genes are in the metadata?
tail -n +2 data/sample_metadata.csv | cut -d',' -f3 | sort -u | wc -l

# Which genes appear in tumor samples?
grep "tumor" data/sample_metadata.csv | cut -d',' -f3 | sort -u

# Find headers of Mus musculus reads across all FASTQ files
grep "Mus musculus" data/*.fastq
```

### 8. Using `awk` for Column-based Data

```bash
# Print just column 3 (gene) from the CSV
awk -F',' '{print $3}' data/sample_metadata.csv

# Filter metadata to only tumor samples
awk -F',' '$5 == "tumor"' data/sample_metadata.csv

# Extract just the DNA sequences from a FASTQ file (every 2nd of 4 lines)
awk 'NR % 4 == 2' data/sample1.fastq

# Print sequence lengths
awk 'NR % 4 == 2 { print length($0) }' data/sample1.fastq
```

### 9. Redirecting Output to Files

```bash
# Save all TP53 reads to a new file
grep "TP53" data/sample1.fastq > results_tp53.txt

# Append results from sample2
grep "TP53" data/sample2.fastq >> results_tp53.txt

# Extract sequences and save them
awk 'NR % 4 == 2' data/sample1.fastq > sequences_only.txt
```

### 10. Loops for Batch Processing

```bash
# Count reads in every FASTQ file
for file in data/*.fastq; do
    reads=$(( $(wc -l < "$file") / 4 ))
    echo "$file: $reads reads"
done

# Search for every gene from genes.txt across all FASTQ files
while read -r gene; do
    count=$(grep -c "$gene" data/sample1.fastq || true)
    echo "$gene: $count matches in sample1"
done < data/genes.txt
```

---

## Ready-to-Use Scripts

The `scripts/` directory contains helpful scripts you can run directly. Make them executable first:

```bash
chmod +x scripts/*.sh
```

| Script | What It Does | Example |
|--------|-------------|---------|
| `count_reads.sh` | Count reads in FASTQ files | `bash scripts/count_reads.sh data/*.fastq` |
| `extract_sequences.sh` | Print only DNA sequences | `bash scripts/extract_sequences.sh data/sample1.fastq` |
| `filter_by_organism.sh` | Keep reads from one species | `bash scripts/filter_by_organism.sh data/sample1.fastq "Homo sapiens"` |
| `gc_content.sh` | Calculate GC% per read | `bash scripts/gc_content.sh data/sample1.fastq` |
| `find_low_quality.sh` | Report reads with N bases | `bash scripts/find_low_quality.sh data/sample2.fastq` |
| `search_gene.sh` | Search for a gene in files | `bash scripts/search_gene.sh TP53 data/*.fastq` |
| `summarize_metadata.sh` | Summarize the metadata CSV | `bash scripts/summarize_metadata.sh data/sample_metadata.csv` |

---

## Practice Exercises

Try these on your own to build confidence:

1. **How many reads are in `sample2.fastq`?**
2. **Which reads in `sample2.fastq` have low-quality N bases?** *(Hint: use `grep "N"` on sequence lines)*
3. **What is the average sequence length in `sample1.fastq`?** *(Hint: pipe `awk` into another `awk`)*
4. **List all genes from `sample_metadata.csv` that were sequenced from "blood" tissue.**
5. **Find reads that appear in both samples for gene TP53.** *(Hint: use `grep` and `diff` or `comm`)*
6. **Create a loop that calculates GC content for all FASTQ files and saves results to a file.**
7. **Filter the metadata to show only Mus musculus control samples.**

<details>
<summary>Click for answers</summary>

```bash
# 1
echo "$(( $(wc -l < data/sample2.fastq) / 4 )) reads"

# 2
awk 'NR % 4 == 2 && /N/' data/sample2.fastq

# 3
awk 'NR % 4 == 2 { total += length($0); count++ } END { print total/count }' data/sample1.fastq

# 4
awk -F',' '$4 == "blood" { print $3 }' data/sample_metadata.csv

# 5
grep "TP53" data/sample1.fastq data/sample2.fastq

# 6
for f in data/*.fastq; do
    bash scripts/gc_content.sh "$f"
done > gc_results.txt

# 7
awk -F',' '$2 == "Mus musculus" && $5 == "control"' data/sample_metadata.csv
```

</details>

---

## Quick Reference

See [CHEATSHEET.md](CHEATSHEET.md) for a printable one-page reference of all the commands covered here.