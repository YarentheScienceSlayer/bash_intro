# BASH Intro — Lecture 2: Lecture Notes

---

## 1. I/O Streams

Every Unix process has **three standard data streams** automatically connected to it:

| Stream | Name | Default | Descriptor | Redirect |
|--------|------|---------|------------|---------|
| stdin | Standard Input | Keyboard | 0 | `<` or `\|` |
| stdout | Standard Output | Terminal | 1 | `>` |
| stderr | Standard Error | Terminal | 2 | `2>` |

### Redirection Operators

```bash
# stdout → file
grep "TATA" sequences.fasta > TATA_seq.fasta

# stderr → file
grep "TATA" sequences.fasta 2> error.log

# stdout → stderr (for status messages)
echo "Starting..." >&2

# stderr → stdout
bwa mem ref.fa reads.fq > aln.log 2>&1

# both stdout and stderr → file
fastqc sample.fastq &> fastqc.log
```

> ⚠️ **Order matters!**
> - ✅ `command > file 2>&1` — stderr goes into the file
> - ❌ `command 2>&1 > file` — stderr goes to terminal, not the file

### Discarding Output with /dev/null

```bash
grep "missense_variant" annotations.vcf 2> /dev/null
samtools view -bS aligned.sam 2>/dev/null > aligned.bam
```

### Best Practice: Logging Pipeline Progress

```bash
#!/bin/bash
echo "Starting alignment..." >&2
bwa mem genome.fa reads.fastq > aligned.sam

echo "Calling variants..." >&2
samtools sort aligned.sam | bcftools call > variants.vcf

echo "Done!" >&2
```

Status messages go to `stderr` → keeps `stdout` clean and pipeable.

---

## 2. Exit Status

`$?` stores the **exit status of the last command**.

| Value | Meaning |
|-------|---------|
| `0` | Success |
| `1–225` | Failure / Error |

```bash
bwa mem genome.fa reads.fastq > aligned.sam 2> bwa.log
if [ $? -ne 0 ]; then
    echo "ERROR: Alignment failed!" >&2
    exit 1
fi
echo "Alignment successful, continuing..." >&2
```

---

## 3. Control Operators

| Operator | Behavior |
|----------|----------|
| `&&` | Run next command **only if previous succeeded** (exit 0) |
| `\|\|` | Run next command **only if previous failed** (exit ≠ 0) |
| `;` | Run next command **no matter what** |

```bash
fastqc sample.fastq && echo "QC completed"
fastqc sample.fastq || echo "QC error"
fastqc sample.fastq ; echo "done"
```

---

## 4. Escape Sequences

| Sequence | Meaning |
|----------|---------|
| `\n` | Newline |
| `\t` | Tab |

- **TSV** (Tab-Separated Values): delimiter = `\t`
- **CSV** (Comma-Separated Values): delimiter = `,`

---

## 5. Bash Regular Expressions (Regex)

A regex is a **pattern language** for matching text.

### grep Flags for Regex

| Flag | Description |
|------|-------------|
| `-P` | PCRE mode — supports `\d`, `\w`, `\s` etc. |
| `-E` | Extended regex (ERE) — POSIX standard, no `\d`/`\w`/`\s` |

### Character Shortcuts (PCRE only)

| Pattern | Matches |
|---------|---------|
| `\t` | Tab |
| `\n` | Newline |
| `\d` | Digit `[0-9]` |
| `\D` | Non-digit |
| `\w` | Word char `[a-zA-Z0-9_]` |
| `\W` | Non-word char |
| `\s` | Whitespace |
| `\S` | Non-whitespace |

### Anchors & Wildcards

```bash
echo "ATGCATGC" | grep -oP "A.G"   # dot: any char → matches ATG, ACG
grep "^>" sequences.fasta           # ^ anchors to line start → FASTA headers
grep "TAA$" sequences.txt           # $ anchors to line end → stop codon TAA
```

### Quantifiers

| Symbol | Meaning | Example |
|--------|---------|---------|
| `*` | 0 or more | `grep -E "GT*A"` |
| `+` | 1 or more | `grep -E "A+"` |
| `?` | 0 or 1 (optional) | `grep -E "colou?r"` |
| `{n,m}` | Between n and m | `grep -E "A{3,6}"` |

### Grouping & Alternation

```bash
grep -E "TAA|TAG|TGA" sequences.txt        # pipe = OR
grep -oP "(ATG)+" sequences.txt            # parentheses = group
grep -E "(GT){2,}" introns.txt             # repeat group
```

### Character Classes

```bash
grep -E "[ACGT]+" sequences.txt            # valid DNA bases
grep -E "[^ACGT]" sequences.txt            # NOT ACGT (ambiguous bases)
grep -E "chr[0-9XY]+" genome.bed           # chromosome names
```

### BED Format Regex Example

```bash
grep -P "^chr\w+\t\d+\t\d+" genome.bed    # matches: chrName<tab>start<tab>end
```

### Practical Bioinformatics Regex

```bash
grep -P "(AC){5,}" genome.txt                         # microsatellite repeats
grep -E "^>.*[Hh]omo sapiens" proteome.fasta           # human FASTA headers
grep -oP "ATG[ACGT]{3,}?(TAA|TAG|TGA)" sequence.txt   # simple ORF finder
```

---

## 6. sort

Reorders lines of text (alphabetically by default).

```bash
sort gene_ids.txt             # alphabetical
sort -n gene_ids.txt          # numeric
sort -r gene_ids.txt          # reverse
sort -k3 gene_ids.txt         # by column 3
sort -t$'\t' -k4 gene_ids.tsv # by column 4, tab-separated
sort -u gene_ids.txt          # unique lines only
sort -V file.txt              # version sort (chr1, chr2, chr10 order)
```

---

## 7. uniq

Collapses **consecutive** identical lines. Always pipe `sort` first!

```bash
sort gene_ids.txt | uniq         # remove duplicates
sort gene_ids.txt | uniq -c      # count occurrences
sort gene_ids.txt | uniq -d      # only duplicate lines
sort gene_ids.txt | uniq -u      # only unique lines (appearing once)
sort gene_ids.txt | uniq -i      # case-insensitive
```

### Combined Example

```bash
# Count species frequency, then sort by most common
sort species.txt | uniq -c | sort -rn

# Count variants per chromosome from VCF
grep -v "^#" variants.vcf | cut -f1 | sort | uniq -c | sort -rn
```

---

## 8. cut

Extracts specific columns, characters, or bytes from each line.

```bash
cut -f1 samples.tsv              # column 1 (tab-separated by default)
cut -f1,3 samples.tsv            # columns 1 and 3
cut -f1-3 samples.tsv            # columns 1 through 3
cut -d',' -f1,3 samples.csv      # comma-separated, cols 1 & 3
cut -d':' -f1 /etc/passwd        # colon-separated → usernames
echo "ATGCATGC" | cut -c1-3     # characters 1–3 → ATG
cut -f2 --complement samples.tsv # all columns EXCEPT column 2
```

---

## 9. paste

Merges files **side by side**, joining lines column by column.

```bash
paste geneID.txt Chr.txt           # merge two files (default: tab-delimited)
paste -d',' GeneID.txt Chr.txt     # use comma as delimiter
paste -d'\t' GeneID.txt Chr.txt    # explicit tab delimiter
paste -d'|' GeneID.txt Chr.txt     # use pipe as delimiter
paste -s -d',' GeneID.txt          # serial: all lines into one row
```

---

## 10. comm

Compares **two sorted files** line by line.

| Column | Content |
|--------|---------|
| 1 | Lines only in file1 |
| 2 | Lines only in file2 |
| 3 | Lines in both files |

```bash
comm file1.txt file2.txt               # all 3 columns
comm -12 <(sort A.txt) <(sort B.txt)   # shared lines only
comm -23 <(sort A.txt) <(sort B.txt)   # unique to file1
```

### Bioinformatics Examples

```bash
# Shared genes between two RNA-seq experiments
comm -12 <(sort rna_exp1.txt) <(sort rna_exp2.txt)

# Tumor-specific variants
comm -23 <(sort tumor.txt) <(sort normal.txt)

# Novel variants not in dbSNP
comm -23 <(sort my_variants.txt) <(sort dbSNP.txt) > novel_variants.txt
```

---

## 11. tr

Translates, deletes, or squeezes characters. **Reads only from stdin.**

```bash
tr 'T' 'U' < rna.txt                    # DNA → RNA
echo "ATGC" | tr 'ATGC' 'TACG'          # complement
echo "atgcatgc" | tr 'a-z' 'A-Z'        # lowercase → uppercase
echo "ATG CAT GCA" | tr -d ' '          # remove spaces
tr -d '\n' < sequence.fasta             # collapse multi-line to one line
tr -d '\r' < windows_file.txt           # fix Windows line endings
echo "ATG-CAT_123" | tr -cd 'ACGT\n'   # keep only ACGT and newlines
grep -v '^>' seq.fasta | tr -d '\n'     # extract FASTA sequence as one line
```

---

## 12. sed — Stream Editor

Finds, replaces, deletes, and inserts text line by line.

### Substitution

```bash
sed 's/T/U/g' dna.txt                        # replace all T with U (DNA→RNA)
sed 's/Homo sapiens/H.sapiens/g' species.txt  # abbreviate species names
sed 's/[a-z]/\U&/g' genes.txt                # convert to uppercase
sed 's/ATG/[START]/2' seq.txt                # replace only 2nd ATG
```

### Print Specific Lines

```bash
sed -n '1p' file.fasta          # print line 1 only
sed -n '1,4p' file.fasta        # print lines 1–4
sed -n '/^>/p' file.fasta       # print FASTA headers
```

### Delete Lines

```bash
sed '/^#/d' annotation.gff      # remove comment lines
sed '/^$/d' sequences.txt       # remove blank lines
sed '/^>/d' file.fasta          # remove FASTA headers
sed '5,10d' file.txt            # delete lines 5–10
sed '/START/,/END/d' file.txt   # delete between START and END
```

### In-Place Editing

```bash
sed -i 's/chr/Chr/g' genome.bed          # edit file directly
sed -i.bak 's/T/U/g' dna.txt            # edit file, keep backup (.bak)
```

### Insert and Append

```bash
sed '1i\##Pipeline output v1.0' results.txt   # insert BEFORE line 1
sed '$a\##End of file' results.txt            # append AFTER last line
sed '/^>/a\ORIGIN' file.fasta                 # append after every header
```

### Practical Examples

```bash
sed 's/^/chr/' genome.bed          # rename: "1" → "chr1"
sed 's/^/GENE_/' gene_ids.txt      # add prefix to every gene ID
```

---

## 13. awk

A **mini-language** for processing structured text. Processes line by line, splitting each line into fields.

### Built-in Variables

| Variable | Meaning |
|----------|---------|
| `$0` | Entire current line |
| `$1, $2...` | Fields (columns) |
| `$NF` | Last field |
| `NR` | Current line number |
| `NF` | Number of fields in current line |
| `FS` | Field separator (default: whitespace) |
| `OFS` | Output field separator |

### Print Specific Columns

```bash
awk '{print $1}' genome.bed          # chromosome column
awk '{print $1, $2, $3}' genome.bed  # first 3 columns
awk '{print $NF}' file.txt           # last column
```

### Filtering with Conditions

```bash
awk '$5 > 100' expression.tsv        # expression > 100
awk 'NR > 1' results.tsv             # skip header line
awk '$3 - $2 > 1000' genes.bed       # genes longer than 1000bp
awk '$1 == "chr1"' genome.bed        # only chromosome 1
awk '$6 == "+"' genes.bed            # only forward strand
```

### Custom Field Separators

```bash
awk -F'\t' '{print $1, $4}' file.tsv
awk -F',' '{print $2}' file.csv
awk -F':' '{print $1}' /etc/passwd
awk -F'\t' '$1 != "#" {print $1, $2, $4, $5}' variants.vcf
```

### Reformatting Files

```bash
awk '{print $1":"$2"-"$3"\t"$4}' genes.bed        # BED → custom format
awk '{print $2, $1}' file.txt                       # swap columns
awk 'OFS="\t" {print $0, $3-$2}' genes.bed         # add gene length column
awk -F',' 'BEGIN{OFS="\t"} {$1=$1; print}' file.csv  # CSV → TSV
```

### Pattern Matching

```bash
awk '/^>/' file.fasta            # FASTA header lines
awk '!/>/' file.fasta            # sequence lines only
awk '/TATA/' promoters.txt       # lines with TATA box
awk '$4 ~ /BRCA/' annotation.gtf   # column 4 contains "BRCA"
awk '$4 !~ /pseudo/' annotation.gtf  # column 4 does NOT contain "pseudo"
```

### Calculating Statistics

```bash
# Sum column 2
awk '{sum += $2} END {print "Total:", sum}' counts.txt

# Mean expression (skip header)
awk 'NR>1 {sum += $2; count++} END {print "Mean:", sum/count}' expression.txt

# Min/max read length from FASTQ
awk 'NR%4==2 {len=length($0); if(len>max)max=len; if(len<min||NR==2)min=len} \
END {print "Min:", min, "Max:", max}' reads.fastq
```

### Bioinformatics Examples

```bash
# Top 5 most expressed genes
awk 'NR>1 {print $2, $1}' expression.txt | sort -rn | head -5

# Count sequences in FASTA
awk '/^>/{count++} END{print count}' proteome.fasta

# GC content per sequence line
awk '!/^>/ {
    gc = gsub(/[GC]/,"&")
    total = length($0)
    print gc/total * 100 "% GC"
}' sequences.fasta
```

---

## Quick Reference Summary

| Command | Purpose |
|---------|---------|
| `>`, `2>`, `&>` | Redirect stdout / stderr / both |
| `$?` | Exit status of last command |
| `&&`, `\|\|`, `;` | Conditional command chaining |
| `sort` | Sort lines of text |
| `uniq` | Remove/count adjacent duplicates |
| `cut` | Extract columns or characters |
| `paste` | Merge files side by side |
| `comm` | Compare two sorted files |
| `tr` | Translate/delete characters |
| `sed` | Stream editor (find/replace/delete/insert) |
| `awk` | Field-based text processing mini-language |
