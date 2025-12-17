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

## MultiQC pipeline
More information found in `00_mutliqc_untrimmed/README.md`

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

### 02_run_asereadcounter
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/02_run_asereadcounter
```
Scripts:
- `asereadcounter_script.py` - Build ASEReadCounter commands for all quadrant samples
Output:
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/02_run_asereadcounter/HISAT
```

### 03_analyze_ase
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/03_analyze_ase
```
* Filter out variants with a total coverage less than 10
Scripts:
- `analyze_ase_script.py` - Calculates the allele balance for all quadrant samples
Output:
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/03_analyze_ase/allele_balance_tables
```

### 04_phasing
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/04_phasing
```
* Threshold of 0.8 for phasing
Scripts:
- `subset_paired_placentas_for_shared_variants.py` - Selects only variants expressed across all quadrants
- `phase.snakefile` - Chooses site with more variants where allele balance is greater than the threshold (if allele balance is equal to 0.5, pick random), generates a haplotype by adding all biased alleles together, and calculates allele balance using the phased data 
* Once phased allele balance tables are generated, run
```bash
cd /data/Wilson_Lab/projects/placentas_VW_ASE/04_phasing/phased_allele_balance
cat *chrX*allele_balance_summary.tsv | grep -v placenta_id | sort -n -r -k 3, 3 > all_placenta_chrX_phased_allele_balance.tsv
cat *chr8*allele_balance_summary.tsv | grep -v placenta_id | sort -n -r -k 3, 3 > all_placenta_chr8_phased_allele_balance.tsv
```
to get median phased allele balances across all quadrants per placenta.
- `phased_allele_balance_median_plot.R` - Plot median phased allele balance for each quadrant across placentas
Output:
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/04_phasing/paired_placentas_shared_variants
```
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/04_phasing/phased_allele_balance
```

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