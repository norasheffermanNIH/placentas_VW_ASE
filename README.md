# Placenta Allele Specific Expression

## Background
A total of 20 placentas were sampled:
- 10 normotensive (5 male, 5 female)
- 10 hypertensive/preeclampsia (6 male, 4 female)

Each placenta was sectioned into 4 quadrants for sampling. One DNA sample was sequenced from each placenta while RNA and methylation samples were sequenced from each quadrant of each placenta. 

## Goal
To test correlations between methylation and allele specific expression, and overall expression in the placenta.

## Steps:
1. MultiQC
2. ASE Read Counter
3. 

## MultiQC pipeline
More information can be found in `00_multiqc_untrimmed/multiqc_untrimmed.md`

## ASE Read Counter Pipeline
The ASEReadCounter tool from the GATK package calculates read counts per allele at specific variant sites, allowing for allele-specific expression (ASE) analysis of RNA-seq data.

### Requirements
- RNA BAM files with read groups and proper headers
- VCF files containing variant sites

#### BAM File Locations
- Quadrant 1:
```bash
/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/processed_bams/rna/
```
- Quadrants 2, 3, and 4:
```bash
/data/Wilson_Lab/projects/placenta_multiomics/valleywise_3samples/processed_bams_HG38/rna/
```

#### VCF File Locations
```bash 
/data/Wilson_Lab/projects/placentas_VW_ASE/01_generate_files/vcfs/vqsr
```

### 01_generate_files
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/01_generate_files
```
#### RNA BAMs
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/01_generate_files/rna_bams
```

Scripts:
- `processed_bams_Q1.snakefile` - Snakemake workflow to generate RNA BAMs for Q1

#### VCFs
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/01_generate_files/vcfs
```

Scripts:
- `process_female_dna.snakefile` - Snakemake workflow to generate VCFs for chr8 and chrX of female placentas
- `process_male_dna.snakefile` - Snakemake workflow to generate VCFs for chr8 and chrX of male placentas

### 02_analyze_ase

### 03_analyze_ase

### 04_phasing

### 05_plotting


### 05_males
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/05_males
```

Repeat all steps using male placentas as a control

Scripts:
- `asereadcounter_script_males.py`
- `analyze_ase_script_males.py`
- `subset_paired_placentas_for_shared_variants_male.py`
- `phase_male.snakefile`
- `phased_allele_balance_median_plot_males.R`

Output:
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/05_males/HISAT
```
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/05_males/allele_balance_tables
```
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/05_males/placentas_shared_variants
```
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/05_males/phased_allele_balance
```

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