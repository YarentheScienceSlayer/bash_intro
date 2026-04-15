# Bash Cheatsheet for Biology/HPC Use Cases

This cheatsheet provides commonly used Bash commands in the context of biological data analysis and high-performance computing (HPC). Each command includes examples relevant to typical biological files like FASTQ, FASTA, and VCF, along with safety notes where applicable.

---

## 1. man/help/--help

To get help on any command, use the following:
```bash
man <command>
<command> --help
```

Example:
```bash
man ls
```  
```bash
ls --help
```

---

## 2. pwd

Print the current working directory:
```bash
pwd
```

---

## 3. cd

Change the directory:
```bash
cd /path/to/directory
```

---

## 4. ls

List directory contents with various flags:
```bash
ls -l           # Long format
ls -lh          # Human-readable sizes
ls -a           # Include hidden files
ls -lt          # Sort by modification time
ls -lS          # Sort by file size
ls -R           # Recursive listing
```

---

## 5. head/tail

Display the beginning or end of files:
```bash
head -n 10 example.fastq    # First 10 lines
tail -n 10 example.fastq    # Last 10 lines
```

---

## 6. wc

Count lines, words, and characters:
```bash
wc -l example.fastq     # Line count
wc -w example.fastq     # Word count
wc -c example.fastq     # Character count
wc -m example.fastq     # Multi-byte character count
```

### FASTQ Lines Tip:
A FASTQ file has 4 lines per sequence:
1. Sequence identifier
2. Raw sequence
3. Separator line (usually '+')
4. Quality scores

---

## 7. cat / zcat

Concatenate and display files:
```bash
cat example.fasta
zcat example.fasta.gz  # For gzipped files
```

---

## 8. less

View the contents of a file page by page:
```bash
less example.vcf
```

### Keys and Options:
- `Space`: Scroll down
- `b`: Scroll up
- `q`: Quit
- `-S`: Prevent line wrapping

---

## 9. file

Determine the file type:
```bash
file example.fastq
```

---

## 10. touch

Create an empty file or update the timestamp:
```bash
touch newfile.txt
```

---

## 11. cp

Copy files and directories:
```bash
cp source.txt destination.txt
cp -r source_dir/ destination_dir/  # for directories
```

---

## 12. mkdir

Create directories:
```bash
mkdir new_dir        # Create a single directory
mkdir -p path/to/new_dir  # Create nested directories
```

---

## 13. rm

Remove files or directories:
```bash
rm filename.txt        # Remove a file
rm -r directory_name/   # Remove a directory
```

### Warning:
Be careful with `rm`, as it permanently deletes files without confirmation. Always check the path and the files you are about to delete.

---

## 14. mv

Move or rename files:
```bash
mv oldname.txt newname.txt
mv file.txt /new/path/
```

---

## 15. Wildcards

Use wildcards to specify multiple files:
```bash
ls *.fastq          # All FASTQ files
ls sample_??.txt    # Matches sample_01.txt, sample_02.txt
```

### Brace Expansion:
```bash
echo {a,b,c}
echo {01..100}   # Generates numbers from 01 to 100
```

---

## 16. grep

Search for patterns in files:
```bash
grep -i "pattern" example.txt                  # Case insensitive
grep -c "pattern" example.txt                  # Count occurrences
grep -A 2 "pattern" example.fastq               # Show 2 lines after match
grep -B 2 "pattern" example.fastq               # Show 2 lines before match
grep -C 2 "pattern" example.fastq               # Context (2 lines before/after)
```

### Context Example with FASTQ:
```bash
grep -A 3 "@SEQ_ID" example.fastq  # Get sequence context
```

---

## 17. Pipes and Redirection

Use pipes and redirection to connect commands:
```bash
cat example.fastq | grep "+" > output.txt  # Redirect output to a file
```

```bash
cat example.fastq >> anotherfile.txt  # Append to a file
```

---

### Safety Notes:
- Always double-check paths when using `rm` and `mv` to prevent accidental data loss.
- Remember that Linux file systems are case-sensitive (e.g., File.txt is different from file.txt).
- Be cautious when using wildcards to avoid unintended file operations.
