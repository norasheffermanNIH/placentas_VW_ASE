## 06_males
**Goal**: Repeat all steps (02-05) using male placnetas as a control.

**Directory**:
`/data/Wilson_Lab/projects/placentas_VW_ASE/06_males`

**Scripts**:
- `asereadcounter_script_males.py` - Builds ASEReadCounter commands for male placentas and writes them to a SLURM submission script
- `run_asereadcounter_script_males.py` - Runs job submissions from `asereadcounter_script_males.py`
- `analyze_ase_script_males.py` - Builds commands that calculate allele balance for quadrant samples from male placentas and writes them to a SLURM submission script
- `run_analyze_ase_script_males.py` - Runs job submissions from `analyze_ase_script_males.py`

- `subset_paired_placentas_for_shared_variants_males.py` - Selects only variants expressed all quadrants of the same male placenta
- `phase_males.snakefile` - Chooses sites with more variants where allele balance is greater than the threshold (if allele balance is equal to 0.5, pick random), generates a haplotype by adding all biased alleles together, and calculates allele balance using the phased data for male placentas
- `phased_allele_balance_median_plot_males.R` - Generates plot of median phased allele balance for each quadrant across male placentas using phased allele balance summary tables.

**Steps**:

1. Confirm that the correct config file and all inputs are present in `asereadcounter_script_males.py`. 
2. Generate the SLURM job script. 
```
python asereadcounter_script_males.py > run_asereadcounter_script_males.sh
```
3. Submit jobs.
```
sbatch run_asereadcounter_script_males.sh
```
**Output**:
`/data/Wilson_Lab/projects/placentas_VW_ASE/06_males/HISAT`

This directory contains tables of reference and alternate allele counts at specific variant sites for each quadrant of each male placenta on chrX and chr8.

4. Confirm the correct config file and all inputs are present in `analyze_ase_script_males.py`.
5. Generate the SLURM job script.
```
python analyze_ase_script_males.py > run_analyze_ase_script_males.sh
```
6. Submit jobs.
```
sbatch run_analyze_ase_script.sh
```
**Output**:
`/data/Wilson_Lab/projects/placentas_VW_ASE/06_males/allele_balance_tables`

This directory contains tables calculating the allele balance at specific variant sites for each quadrant of each males placenta on chrX and chr8.

7. Find shared variants across quadrants of the same male placenta.
```
python subset_paired_placentas_shared_variants_males.py X > chrX_summary_stats.txt
python subset_paired_placentas_shared_variants_males.py 8 > chr8_summary_stats.txt
```
**Output:** `/data/Wilson_Lab/projects/placentas_VW_ASE/06_males/paired_placentas_shared_variants`

This directory contains tables of variants that are expressed in all four quadrants of each placenta on chrX and chr8.

8. Compute allele balance for male phased data. 
```
module load snakemake
snakemake --snakefile phase_males.snakefile -j 8
```
**Output:** `/data/Wilson_Lab/projects/placentas_VW_ASE/06_males/phased_allele_balance`

This directory contains phased allele balance summary tables for each each male placenta on chrX and chr8.

9. Combine male phased allele balance summaries for plotting.
```bash
cd 06_males/phased_allele_balance
cat *chrX*allele_balance_summary.tsv | grep -v placenta_id | sort -n -r -k 3,3 > all_placenta_chrX_phased_allele_balance.tsv
cat *chr8*allele_balance_summary.tsv | grep -v placenta_id | sort -n -r -k 3,3 > all_placenta_chr8_phased_allele_balance.tsv
```
Make sure each all placenta summary table has the following header: 
```
placenta_id	chromosome	phasing_quadrant	n_shared_variants	n_biased_Q1	n_biased_Q2	n_biased_Q3	n_biased_Q4	median_phased_allele_balance_Q1	median_phased_allele_balance_Q2	median_phased_allele_balance_Q3	median_phased_allele_balance_Q4
```
10. Run R script to generate summary plots of median phased allele balance for each quadrant across male placentas.
```
module load R
Rscript phased_allele_balance_median_plot_males.R
```
**Output:** `median_phased_AB_plot_males.png`

This plot shows the median phased allele balance for each quadrant of each placenta across all male placentas.