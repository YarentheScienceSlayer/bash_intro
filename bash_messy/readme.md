# Samtools and NanoPlot Quick Guide (Bash + Terminal)

This guide shows how to install and use **samtools** and **NanoPlot** from the terminal, with examples.

## 1) Install tools

### Option A: Install with Bioconda (recommended)

```bash
# 1. Create and activate a conda environment
conda create -n bioinfo -y
conda activate bioinfo

# 2. Add channels (one-time setup)
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge

# 3. Install tools
conda install -y samtools nanoplot
```

### Option B: Install without Bioconda (direct terminal methods)

#### samtools (Ubuntu/Debian apt)
```bash
sudo apt update
sudo apt install -y samtools
```

#### NanoPlot (pip)
```bash
python3 -m pip install --user NanoPlot
```

> Bioconda usually handles dependencies more reliably for bioinformatics tools.

---

## 2) Verify installation

```bash
samtools --version
NanoPlot --version
```

---

## 3) Samtools examples

Assume your alignment file is `sample.bam`.

### View BAM header
```bash
samtools view -H sample.bam
```

### Convert SAM to BAM
```bash
samtools view -bS sample.sam > sample.bam
```

### Sort BAM
```bash
samtools sort -o sample.sorted.bam sample.bam
```

### Index sorted BAM
```bash
samtools index sample.sorted.bam
```

### Get mapping stats
```bash
samtools flagstat sample.sorted.bam
```

### Get per-reference stats
```bash
samtools idxstats sample.sorted.bam
```

---

## 4) NanoPlot examples

NanoPlot is commonly used for Oxford Nanopore QC.

### From FASTQ
```bash
NanoPlot --fastq reads.fastq -o results/nanoplot/fastq_report
```

### From gzipped FASTQ
```bash
NanoPlot --fastq reads.fastq.gz -o results/nanoplot/fastq_gz_report
```

### From BAM
```bash
NanoPlot --bam sample.sorted.bam -o results/nanoplot/bam_report
```

### Useful options
```bash
NanoPlot --fastq reads.fastq.gz \
  --N50 \
  --threads 4 \
  --tsv_stats \
  -o results/nanoplot/report
```

---

## 5) Example mini workflow in Bash

```bash
# Create output folders
mkdir -p results/samtools results/nanoplot

# Sort + index BAM
samtools sort -o sample.sorted.bam sample.bam
samtools index sample.sorted.bam

# Generate BAM QC summary
samtools flagstat sample.sorted.bam > results/samtools/sample.flagstat.txt

# Generate NanoPlot report from FASTQ
NanoPlot --fastq reads.fastq.gz -o results/nanoplot/report --threads 4
```

---

## 6) Tips

- Use `conda activate bioinfo` before running tools installed with Bioconda.
- Keep outputs in separate folders (for example `results/samtools/` and `results/nanoplot/`).
- Use sorted/indexed BAM files for downstream analysis.
