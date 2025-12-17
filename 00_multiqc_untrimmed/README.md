# MultiQC Untrimmed Summary

## Overview
This directory contains MultiQC analysis of untrimmed sequencing reads across exome, RNA, and methylation assays for the Valleywise placenta study.

A total of 20 placentas were sampled:
- 10 normotensive (5 male, 5 female)
- 10 hypertensive/preeclampsia (6 male, 4 female)

Each placenta was sectioned into 4 quadrants for sampling.

---

## 1. Exome Sequencing MultiQC
Only one DNA sample was sequenced from each placenta (Quadrant 1 only). 
Total exome samples: **40**

### 1.1 Sample paths
Raw data can be found at:
```bash
/data/Wilson_Lab/placenta/valleywise_raw_data/exome
```
Sample names and paths can be found at:
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/00_multiqc_untrimmed/exome_seq/fastq_list.txt
```
The `fastq_list.txt` was used to generate the `fastqc.swarm` script. More details on the pipeline can be found in `/data/Wilson_Lab/projects/placentas_VW_ASE/00_multiqc_untrimmed/exome_seq/README.md` .

### 1.2 Output
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/00_multiqc_untrimmed/exome_seq/multiqc_results
```

---

## 2. RNA Sequencing MultiQC
RNA samples were sequenced from each quadrant of each placenta, but Q1 samples were sequenced first while Q2-Q4 samples were sequenced months later. All RNA samples were collected at the same time.
Total RNA samples: **160**

### 2.1 Sample paths
Raw data can be found at:
- Quadrant 1:
```bash
/data/Wilson_Lab/placenta/valleywise_raw_data/RNAseq
```
- Quadrants 2, 3, and 4:
```bash
/data/Wilson_Lab/placenta/valleywise_raw_data/valleywise_placenta_3samples
```
Sample names and paths can be found at:
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/00_multiqc_untrimmed/RNA_seq/fastq_list.txt.
```
The `fastq_list.txt` was used to generate the `fastqc.swarm` script. More details on the pipeline can be found in `/data/Wilson_Lab/projects/placentas_VW_ASE/00_multiqc_untrimmed/RNA_seq/README.md` .

### 2.2 Lane merging
Q2-Q4 samples were sequenced across two lanes, so they had to be merged before FastQC and MultiQC analysis. The workflow for this can be found in `/data/Wilson_Lab/projects/placentas_VW_ASE/00_multiqc_untrimmed/RNA_seq/README.md`.

### 2.3 Output
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/00_multiqc_untrimmed/RNA_seq/multiqc_results
```

---

## 3. Methylation Sequencing MultiQC
Methylation samples were sequenced from each quadrant of each placenta at the same time. MultiQC is run separately on female and males samples to later use a different sex-aware version of the reference genome for each. 
Total methylation samples: **160**

### 3.1 Sample paths
Raw data can be found at:
```bash
/data/Wilson_Lab/placenta/valleywise_raw_data/methylseq
```
Sample names and paths can be found at:
- Female - 72 samples
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/00_multiqc_untrimmed/methyl_seq/fastq_list_XX.txt
```
- Male - 88 samples
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/00_multiqc_untrimmed/methyl_seq/fastq_list_XY.txt
```
The `fastq_list.txt` for each sex was used to generate the `fastqc.swarm` scripts. More details on the pipeline can be found in `/data/Wilson_Lab/projects/placentas_VW_ASE/00_multiqc_untrimmed/methyl_seq/README.md` .

### 3.2 Output
### XX (females)
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/00_multiqc_untrimmed/methyl_seq/multiqc_results_XX
```
### XY (males)
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/00_multiqc_untrimmed/methyl_seq/multiqc_results_XY
```

---

## 4. Read Depth Summaries
The script:
`mean_reads_untrimmed.R` 
produces two summary tables:

### 4.1 Mean read depth between assays in the same quadrant
`mean_reads_quad.tsv`

### 4.2 Mean read depth across all quadrants in a patient
`mean_reads_patient.tsv` 

These tables can be found in:
`data/Wilson_Lab/projects/placentas_VW_ASE/00_multiqc_untrimmed`

