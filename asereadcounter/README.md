# ASE Read Counter Pipeline

## 1. Overview
The ASEReadCounter tool from the GATK package calculates read counts per allele at specific variant sites, allowing for allele-specific expression (ASE) analysis of RNA-seq data.

## 2. Requirements
- BAM files with read groups and proper headers
- VCF files containing variant sites

## 3. Input Data
### 3.1 BAM File Locations
- Quadrant 1:
```bash
/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/processed_bams/rna/
```
- Quadrants 2, 3, and 4:
```bash
/data/Wilson_Lab/projects/placenta_multiomics/valleywise_3samples/processed_bams_HG38/rna/
```

### 3.2 VCF File Locations
```bash 
/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/vqsr/
```

## 4. Generating Processed BAMs (Q1)
Processed BAM files for RNA for Quadrant 1 did not exist originally and had to be generated.

Scripts:
- `processed_bams_Q1.snakefile` - Snakemake workflow to generate RNA BAMs for Q1
- `run_snakemake.slurm` - SLURM script to run the Snakemake workflow on Biowulf

### 4.1 Run Snakemake on Biowulf
```bash
sbatch run_snakemake.slurm
```
*Note*: `processed_bams_Q1.snakefile` can be adapted for other quadrants if needed.

## 5. Running ASEReadCounter
Once all BAM and VCF files are ready, scripts to run ASEReadCounter are located in:
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/asereadcounter/scripts/
```

### 5.1 Create Bash Script with ASEReadCounter Commands
Use `asereadcounter_script.py` to build ASEReadCounter commands for all quadrant RNA samples.
Create a batch submission script: 
```bash
python asereadcounter_script.py >> run_asereadcounter_script.sh
```
Before running the command, create the file `run_asereadcounter_script.sh` and add the appropriate `#SBATCH` parameters to the header.

### 5.2 Submit ASEReadCounter Jobs
```bash
bash run_asereadcounter_script.sh
```

*Note*: ASEReadCounter was only run on female placentas.

## 6. Output
Allele count tables are located at
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/asereadcounter/HISAT
```
Files are organized by quadrant in the corresponding subdirectories.

## 7. Analyze ASEReadCounter
ASEReadCounter results were processed to compute the unphased allele balance of each variant.

### 7.1 Create Bash Script to Calculate Unphased Allele Balance for Each Variant
Use `analyze_ase_script.py` to calculate the allele balance for all quadrant RNA samples.
Create a bash submission script:
```bash
python analyze_ase_script.py >> run_analyze_ase_script.sh
```
Before running the command, create the file `run_analyze_ase_script.sh` and add the appropriate `#SBATCH` parameters to the header.

### 7.2 Submit Job
```bash
bash run_analyze_ase_script.sh
```
Tables with the allele balance of each variant are located at
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/asereadcounter/analyze_ase_results/allele_balance_tables/
```
Files are organized by quadrant in the corresponding subdirectories. 

### 7.3 Plot Unphased Allele Balance Across the X Chromosome
Use `make_unphased_allele_balance_plots.R` located in the `scripts/` subdirectory to plot the unphased allele balance across chromosomes X and 8. 
Submit as a batch job:
```bash
sbatch plot_unphased_allele_balance.slurm
```
Plots are located at 
```bash
/data/Wilson_Lab/projects/placentas_VW_ASE/asereadcounter/analyze_ase_results/allele_balance_chrom_plots/
```
Files are organized by quadrant in the corresponding subdirectories.
