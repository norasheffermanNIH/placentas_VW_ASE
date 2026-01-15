## 04_phasing
**Goal**: Compute phased allele balance to identify haplotypes across quadrants.

**Directory**:
`/data/Wilson_Lab/projects/placentas_VW_ASE/04_phasing`

**Scripts**:
- `subset_paired_placentas_for_shared_variants.py` - Selects only variants expressed across all quadrants of the same placenta.
- `phase.snakefile` - Chooses sites with more variants where allele balance is greater than the threshold (if allele balance is equal to 0.5, pick random), generates a haplotype by adding all biased alleles together, and calculates allele balance using the phased data
    - Chose threshold of 0.8 for phasing, can adjust it to be higher or lower

**Steps**:

1. Find shared variants across quadrants of the same placenta.
```
python subset_paired_placentas_shared_variants.py X > chrX_summary_stats.txt
python subset_paired_placentas_shared_variants.py 8 > chr8_summary_stats.txt
```
**Output:** `/data/Wilson_Lab/projects/placentas_VW_ASE/04_phasing/paired_placentas_shared_variants`

This directory contains tables of variants that are expressed in all four quadrants of each placenta on chrX and chr8.

2. Compute allele balance for phased data.
```
# Make sure you are on an interactive node if running on a cluster
module load snakemake
snakemake --snakefile phase.snakefile -j 8
```
**Output:** `/data/Wilson_Lab/projects/placentas_VW_ASE/04_phasing/phased_allele_balance`

This directory contains phased allele balance summary tables for each each placenta on chrX and chr8.

3. Combine phased allele balance summaries for plotting.
```bash
cd 04_phasing/phased_allele_balance
cat *chrX*allele_balance_summary.tsv | grep -v placenta_id | sort -n -r -k 3,3 > all_placenta_chrX_phased_allele_balance.tsv
cat *chr8*allele_balance_summary.tsv | grep -v placenta_id | sort -n -r -k 3,3 > all_placenta_chr8_phased_allele_balance.tsv
```
Make sure each all placenta summary table has the following header: 
```
placenta_id	chromosome	phasing_quadrant	n_shared_variants	n_biased_Q1	n_biased_Q2	n_biased_Q3	n_biased_Q4	median_phased_allele_balance_Q1	median_phased_allele_balance_Q2	median_phased_allele_balance_Q3	median_phased_allele_balance_Q4
```