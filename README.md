# bash_intro



## Quick terminology (very brief)
- **Hardware**: physical parts (CPU, RAM, disk).
- **Software**: instructions that run on hardware (OS, applications).
- **Program**: a specific executable set of instructions (a type of software).
- **OS (Operating System)**: manages hardware + provides services to programs (Linux/macOS/Windows).
- **Kernel**: the OS core controlling CPU/memory/devices.
- **Shell**: a program that accepts your commands and asks the kernel to run them (Bash is a shell).
- **CLI**: command line interface (typed commands). Great for automation + remote work (SSH).
- **GUI**: graphical interface (windows/icons).
- **Server/HPC**: remote machines (often Linux, often no GUI) used for compute-heavy work.

## Why Bash/Linux for bioinformatics?
- Most tools are Linux-native (e.g., BWA, samtools, BLAST, Kraken2, GATK)
- Easy scripting/automation (process many samples reliably)
- HPC schedulers (SLURM/PBS) are Linux-based
- Reproducibility: scripts document exactly what you ran

## What is Bash?
**Bash** = *Bourne Again SHell* (1989). It is the default shell on many Linux systems.

Check your current shell:

```bash
echo $SHELL
```

## Filesystem basics
- **Root**: `/` (everything lives under it)
- **Home**: `~` (your user’s starting directory)

Home directory locations:
- Linux: `/home/username/`
- macOS: `/Users/username/`
- Windows: `C:\Users\username\`

### Paths
- **Absolute path**: starts from `/` or `~` (works from anywhere)
- **Relative path**: starts from your current location

Special directories:
- `.` current directory
- `..` parent directory

## Command structure
A typical command looks like:

```text
command -options arguments
```

- **command**: program to run (`ls`, `grep`, `cat`)
- **options/flags**: modify behavior (`-l`, `-a`, `-n 5`)
- **arguments**: what it acts on (file/dir/pattern)

The shell runs in a REPL: **Read → Eval → Print → Loop**.

## Important Bash rules
- Spaces separate command/options/arguments → avoid spaces in filenames (use `_`)
- Linux is **case-sensitive** (`File1` ≠ `file1`)
- Linux doesn’t truly *require* extensions, but programs may still rely on them

## Core commands

### Help / docs
- `man <cmd>`: manual pages (external commands)
- `help <builtin>`: help for shell builtins
- `<cmd> --help`: quick usage

Example:

```bash
man grep
grep --help
```

### Where am I?

```bash
pwd
```

### Move around

```bash
cd /data/project
cd ..
cd ../..
cd -
cd ~
```

### List files

```bash
ls
ls -l
ls -lh
ls -a
ls -lt
ls -lS
ls -R
ls /data/samples/
```

### Peek into files
- `head` / `tail` are great for huge files (FASTQ/FASTA/logs).

```bash
head sample_R1.fastq
head -n 12 sample_R1.fastq
tail -n 20 slurm-12345.out
```

### Count lines/words

```bash
wc -l reads.fastq
# FASTQ has 4 lines per read → reads = lines / 4
```

### Print / combine files

```bash
cat notes.txt
cat sample1.stats sample2.stats > merged.stats
```

If your sequencing data is gzipped:

```bash
zcat sample_R1.fastq.gz | head
```

### Page through files

```bash
less big.log
less sample_R1.fastq.gz
```

Useful keys: `q` quit, `/pattern` search, `n` next match, `G` end.

### Identify file type

```bash
file sample.txt
file sample_R1.fastq.gz
```

### Create files/dirs

```bash
touch run_notes.txt
mkdir results
mkdir -p results/qc
```

### Copy / move / remove (be careful)

```bash
cp sample.fa results/
mv sample.fa sample_reference.fa
rm old.tmp
rm -r old_results/
```

⚠️ Terminal deletes are permanent (no trash).

### Wildcards
- `*` any characters
- `?` single character
- `{}` brace expansion

```bash
ls *.fastq.gz
ls sample_?.fastq.gz
echo sample_{A,B,C}.fastq.gz
echo sample_{01..10}.fastq.gz
```

### Search text with grep

```bash
# Find lines mentioning adapter contamination in a QC report
grep -i "adapter" fastp.json

# Search FASTQ for a specific motif/sequence and include the record context
grep -B1 -A2 "ACGTACGT" reads.fastq
```

Useful flags: `-i` ignore case, `-c` count, `-w` whole word, `-A/-B/-C` context.

## Pipes & redirection
- `|` pipe output of one command into another
- `>` overwrite a file
- `>>` append to a file

Examples:

```bash
# Count how many reads contain a motif (very rough example)
grep -c "ACGTACGT" reads.fastq

# Save a directory listing to a file
ls -lh > dir_listing.txt

# Append another listing later
ls -lh results/ >> dir_listing.txt
```

## Next
- See `CHEATSHEET.md` for a longer, example-heavy reference.
