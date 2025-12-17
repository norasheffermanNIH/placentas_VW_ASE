# Methyl Sequencing: FastQC and MultiQC pipeline

## Overview
This README documents the workflow for running FastQC and MultiQC on methyl sequencing samples

For methyl-seq analysis, females (XX) and males (XY) are processed separately to allow use of different sex-aware reference genomes downstream.

---

## 1. Sample Lists

### 1.1 Female (XX) Methylation Samples
File list:
```bash
/data/Wilson_Lab/projects/placenta_multiomics/valleywise_4quad_methylation/valleywise_methylseq_fems/samplesheet_XXonly.csv
```
- Four DNA samples per placenta (one per quadrant)
- Total XX methylation samples: **72**

### 1.2 Male (XY) Methylation Samples
File list:
```bash
/data/Wilson_Lab/projects/placenta_multiomics/valleywise_4quad_methylation/valleywise_methylseq_males/samplesheet_XY.csv
```
- Four DNA samples per placenta (one per quadrant)
- Total XY methylation samples: **88**

---

## 2. Workflow for XX (Females)

### 2.1 Generate FASTQ List (XX)
Use the script `make_fastq_list_XX.sh` to make a list of all XX methyl-seq FASTQ files.
The command:
```bash
bash make_fastq_list_XX.sh
```
creates the output:
```bash
fastq_list_XX.txt
```
which contains the full paths to all XX methyl-seq FASTQ files.

### 2.2 Create FastQC Swarm File (XX)
Use `make_fastqc_swarm_XX.sh` to generate a swarm file that runs FastQC on each XX sample.

The command
```bash
bash make_fastqc_swarm_XX.sh
```
creates the swarm file:
```bash
fastqc_XX.swarm
```
which can then be run as a swarm job:
```bash
swarm -f fastqc_XX.swarm
```

### 2.3 FastQC Output (XX)
FastQC results are written to:
```bash
fastqc_results_XX/
```

## 2.4. Run MultiQC (XX)
Once all XX FastQC jobs are complete, run MultiQC using `run_multiqc_XX.sh`

The command:
```bash
bash run_multiqc_XX.sh
```
runs MultiQC and directs results to:
```bash
multiqc_results_XX/
```

---

## 3. Workflow for XY (Males)

### 3.1 Generate FASTQ List (XY)
Use the script `make_fastq_list_XY.sh` to make a list of all XX methyl-seq FASTQ files.
The command:
```bash
bash make_fastq_list_XY.sh
```
creates the output:
```bash
fastq_list_XY.txt
```
which contains the full paths to all XY methyl-seq FASTQ files.

### 3.2 Create FastQC Swarm File (XY)
Use `make_fastqc_swarm_XY.sh` to generate a swarm file that runs FastQC on each XY sample.

The command
```bash
bash make_fastqc_swarm_XY.sh
```
creates the swarm file:
```bash
fastqc_XY.swarm
```
which can then be run as a swarm job:
```bash
swarm -f fastqc_XY.swarm
```

### 3.3 FastQC Output (XY)
FastQC results are written to:
```bash
fastqc_results_XY/
```

## 3.4. Run MultiQC (XY)
Once all XY FastQC jobs are complete, run MultiQC using `run_multiqc_XY.sh`

The command:
```bash
bash run_multiqc_XY.sh
```
runs MultiQC and directs results to:
```bash
multiqc_results_XY/
```

---

## 4. Summary of Files and Directories
- XX samplesheet:
```bash
/data/Wilson_Lab/projects/placenta_multiomics/valleywise_4quad_methylation/valleywise_methylseq_fems/samplesheet_XXonly.csv
```
- XY samplesheet:
```bash
data/Wilson_Lab/projects/placenta_multiomics/valleywise_4quad_methylation/valleywise_methylseq_males/samplesheet_XY.csv
```
- XX FASTQ list/swarm/outputs:
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/00_multiqc_untrimmed/methyl_seq/fastq_list_XX.txt
/data/Wilson_Lab/projects/placentas_VW_ASE/00_multiqc_untrimmed/methyl_seq/fastqc_XX.swarm
/data/Wilson_Lab/projects/placentas_VW_ASE/00_multiqc_untrimmed/methyl_seq/fastqc_results_XX
/data/Wilson_Lab/projects/placentas_VW_ASE/00_multiqc_untrimmed/methyl_seq/multiqc_results_XX
```
- XY FASTQ list/swarm.outputs:
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/00_multiqc_untrimmed/methyl_seq/fastq_list_XY.txt
/data/Wilson_Lab/projects/placentas_VW_ASE/00_multiqc_untrimmed/methyl_seq/fastqc_XY.swarm
/data/Wilson_Lab/projects/placentas_VW_ASE/00_multiqc_untrimmed/methyl_seq/fastqc_results_XY/
/data/Wilson_Lab/projects/placentas_VW_ASE/00_multiqc_untrimmed/methyl_seq/multiqc_results_XY/
```