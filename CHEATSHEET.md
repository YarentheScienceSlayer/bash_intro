# Bash Cheat Sheet for Bioinformatics 🧬

A quick reference for the most common bash commands when working with FASTQ files and biological data.

## File Navigation

| Command | Description |
|---------|-------------|
| `pwd` | Print working directory |
| `ls` | List files |
| `ls -lh` | List with sizes in human-readable format |
| `cd <dir>` | Change directory |
| `cd ..` | Go up one level |
| `mkdir <dir>` | Create a directory |
| `cp <src> <dst>` | Copy a file |
| `mv <src> <dst>` | Move or rename a file |
| `rm <file>` | Remove a file |

## Viewing Files

| Command | Description |
|---------|-------------|
| `cat <file>` | Print entire file |
| `head -n 8 <file>` | First 8 lines (2 FASTQ reads) |
| `tail -n 4 <file>` | Last 4 lines (1 FASTQ read) |
| `less <file>` | Scroll through file (q to quit) |
| `wc -l <file>` | Count lines |

## Searching

| Command | Description |
|---------|-------------|
| `grep "pattern" <file>` | Find lines matching a pattern |
| `grep -c "pattern" <file>` | Count matching lines |
| `grep -i "pattern" <file>` | Case-insensitive search |
| `grep "pattern" *.fastq` | Search across multiple files |
| `grep -v "pattern" <file>` | Show lines that do NOT match |

## Text Processing

| Command | Description |
|---------|-------------|
| `cut -d',' -f3 <file>` | Extract column 3 from CSV |
| `sort <file>` | Sort lines alphabetically |
| `sort -n <file>` | Sort lines numerically |
| `sort -rn <file>` | Sort numerically, descending |
| `uniq` | Remove adjacent duplicates |
| `uniq -c` | Count adjacent duplicates |
| `tr 'A' 'T'` | Replace characters |

## awk Essentials

| Command | Description |
|---------|-------------|
| `awk '{print $1}' <file>` | Print first column |
| `awk -F',' '{print $3}' <file>` | Print column 3 (CSV) |
| `awk 'NR % 4 == 2' <file>` | Extract sequences from FASTQ |
| `awk 'NR % 4 == 2 {print length}' <file>` | Sequence lengths |
| `awk -F',' '$5 == "tumor"' <file>` | Filter rows by value |

## Pipes & Redirection

| Syntax | Description |
|--------|-------------|
| `cmd1 \| cmd2` | Pipe output of cmd1 into cmd2 |
| `cmd > file` | Write output to file (overwrite) |
| `cmd >> file` | Append output to file |
| `cmd < file` | Read input from file |

## FASTQ Quick Operations

```bash
# Count reads in a FASTQ file
echo $(( $(wc -l < file.fastq) / 4 ))

# Extract only sequences
awk 'NR % 4 == 2' file.fastq

# Extract only headers
grep "^@" file.fastq

# Find reads with N bases
awk 'NR % 4 == 2 && /N/' file.fastq

# Calculate GC content per read
awk 'NR % 4 == 2 {
    gc = gsub(/[GC]/, "", $0)
    printf "%.1f%%\n", (gc / length) * 100
}' file.fastq
```

## Loops

```bash
# Process all FASTQ files
for f in data/*.fastq; do
    echo "Processing $f ..."
    # your command here
done

# Read gene list and search
while read -r gene; do
    grep "$gene" data/sample1.fastq
done < data/genes.txt
```

## Useful Combinations

```bash
# Unique genes from metadata
tail -n +2 data.csv | cut -d',' -f3 | sort -u

# Count samples per organism
tail -n +2 data.csv | cut -d',' -f2 | sort | uniq -c | sort -rn

# Tumor-only genes
awk -F',' '$5 == "tumor" {print $3}' data.csv | sort -u
```
