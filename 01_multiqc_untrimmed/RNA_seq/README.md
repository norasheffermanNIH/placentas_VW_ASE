# RNA Sequencing: FastQC and MultiQC pipeline

## Overview
This README documents the workflow for running FastQC and MultiQC on RNA sequencing samples

---

## 1. Raw Data
All RNA raw FASTQ files are located at:
```bash
/data/Wilson_Lab/placenta/valleywise_raw_data/
```
- **Quadrant 1 (Q1):**
```bash
/data/Wilson_Lab/placenta/valleywise_raw_data/RNAseq
```
- **Quadrants 2-4 (Q2, Q3, Q4):**
```bash
/data/Wilson_Lab/placenta/valleywise_raw_data/valleywise_placenta_3samples
```
- Four DNA samples per placenta (one per quadrant)
- Total RNA samples: **160**

---

## 2. Merging FASTQ Files for Q2-Q4
Q2-Q4 samples were sequences across two lanes, so the FASTQ files must be merged before FastQC and MultiQC analysis.

### 2.1 Generate Merge Swarm File
Use the script `make_merge_swarm.sh` to merge FASTQ files.

The command:
```bash
bash make_merge_swarm.sh
```
creates the swarm file:
```bash
merge_fastqs.swarm
```
which can then be run as a swarm job:
```bash
swarm -f merge_fastqs.swarm
```

### 2.2 Merge Output
Merged FASTQs are written to
```bash
merged_fastqs/
```

---

## 3. Generate FASTQ List
After merging, use the script `make_fastq_list.sh` to make a list of all RNA FASTQ files.

The command:
```bash
bash make_fastq_list.sh
```
creates the output:
```bash
fastq_list.txt
```
which contains the full paths to all RNA FASTQ files.

---

## 4. Create FastQC Swarm File
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

### 4.1 FastQC Output
FastQC results are written to:
```bash
fastqc_results/
```

---

## 5. Run MultiQC
Once all FastQC jobs are complete, run MultiQC using `run_multiqc.sh`

The command:
```bash
bash run_multiqc.sh
```
runs MultiQC and directs results to:
```bash
multiqc_results/
```

---

## 6. Sumamry of Files and Directories
- Raw RNA FASTQs:
```bash
/data/Wilson_Lab/placenta/valleywise_raw_data/RNAseq
/data/Wilson_Lab/placenta/valleywise_raw_data/valleywise_placenta_3samples
```
- Merge swarm and outputs:
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/multiqc_untrimmed/RNA_seq/merge_fastqs.swarm
/data/Wilson_Lab/projects/placentas_VW_ASE/multiqc_untrimmed/RNA_seq/merged_fastqs/
```
- FASTQ list:
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/multiqc_untrimmed/RNA_seq/fastq_list.txt
```
- FastQC swarm file:
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/multiqc_untrimmed/RNA_seq/fastqc.swarm
```
- FastQC output directory:
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/multiqc_untrimmed/RNA_seq/fastqc_results/
```
- MultiQC output directory:
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/multiqc_untrimmed/RNA_seq/multiqc_results/
```