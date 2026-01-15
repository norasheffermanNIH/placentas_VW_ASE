# Placenta Allele Specific Expression, Methylation, and X-Chromosome Inactivation

## Background
A total of 20 placentas were sampled:
- 10 normotensive (5 male, 5 female)
- 10 hypertensive/preeclampsia (6 male, 4 female)

Each placenta was sectioned into 4 quadrants for sampling. One DNA sample was sequenced from each placenta while RNA and methylation samples were sequenced from each quadrant of each placenta. 

## Goal
To test correlations between methylation and allele specific expression, and overall expression in the placenta.

## Steps:
1. QC
2. Allele Specific Expression
3. 
4. 

## QC 
EXPLAIN. 

#### 00_QC
Explain.

## Allele Specifc Expression
______.The ASEReadCounter tool from the GATK package calculates read counts per allele at specific variant sites, allowing for downstream allele-specific expression (ASE) analysis.

#### Requirements
- RNA BAM files with read groups and proper headers
- VCF files containing variant sites
#### BAM File Locations
- Quadrant 1:
`/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/processed_bams/rna/`
- Quadrants 2, 3, and 4:
`/data/Wilson_Lab/projects/placenta_multiomics/valleywise_3samples/processed_bams_HG38/rna/`

#### VCF File Locations
- All quadrants: `/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/vqsr`

### 01_generate_files

### 02_analyze_ase

### 03_analyze_ase

### 04_phasing

### 05_plotting

### 06_males






### 06_chr20
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/06_chr20
```

Repeat all steps using chr20 from female placentas as a control

Scripts:
- `asereadcounter_script_chr20.py`
- `analyze_ase_script_chr20.py`
- `subset_paired_placentas_for_shared_variants_chr20.py`
- `phase_chr20.snakefile`
- `phased_allele_balance_median_plot_chr20.R`

Output:
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/06_chr20/HISAT
```
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/06_chr20/allele_balance_tables
```
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/06_chr20/placentas_shared_variants
```
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/06_chr20/phased_allele_balance
```