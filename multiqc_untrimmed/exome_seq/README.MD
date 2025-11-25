# Exome Sequencing: FastQC and MultiQC pipeline

## Overview
This README documents the workflow for running FastQC and MultiQC on exome sequencing samples

---

## 1. Raw Data
All exome raw FASTQ files are located at:
```bash
/data/Wilson_Lab/placenta/valleywise_raw_data/exome
```
- One DNA sample per placenta (Q1 only)
- Total exome samples: **40**

## 2. Generate FASTQ List
Use the script `make_fastq_list.sh` to make a list of all exome FASTQ files.

The command:
```bash
bash make_fastq_list.sh
```
creates the output:
```bash
fastq_list.txt
```
which contains the full paths to all exome FASTQ files.

---

## 3. Create FastQC Swarm File
Use `make_fastqc_swarm.sh` to generate a swarm file that runs FastQC on each sample.

The command
```bash
bash make_fastqc_swarm.sh
```
creates the swarm file:
```bash
fastqc.swarm
```
which can then be run as a swarm job:
```bash
swarm -f fastqc.swarm
```

### 3.1 FastQC Output
FastQC results are written to:
```bash
fastqc_results/
```

## 4. Run MultiQC
Once all FastQC jobs are complete, run MultiQC using `run_multiqc.sh`

The command:
```bash
bash run_multiqc.sh
```
runs MultiQC and directs results to:
```bash
multiqc_results/
```

## 5. Sumamry of Files and Directories
- Raw exome FASTQs:
```bash
data/Wilson_Lab/placenta/valleywise_raw_data/exome
```
- FASTQ list:
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/multiqc_untrimmed/exome_seq/fastq_list.txt
```
- FastQC swarm file:
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/multiqc_untrimmed/exome_seq/fastqc.swarm
```
- FastQC output directory:
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/multiqc_untrimmed/exome_seq/fastqc_results/
```
- MultiQC output directory:
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/multiqc_untrimmed/exome_seq/multiqc_results/
```

