## 05_plotting
**Goal**: Plot median phased allele balances across all quadrants per placenta.

**Directory**:
`/data/Wilson_Lab/projects/placentas_VW_ASE/05_plotting`

**Scripts**:
- `phased_allele_balance_median_plot.R` - Generates plot of median phased allele balance for each quadrant across female placentas using phased ASE summary tables.

**Steps**:

1. Run R script to generate summary plots of median phased allele balance for each quadrant across female placentas.
```
module load R
Rscript phased_allele_balance_median_plot.R
```

**Output:** `median_phased_AB_plot_females.png`

This plot shows the median phased allele balance for each quadrant of each placenta across all female placentas.
