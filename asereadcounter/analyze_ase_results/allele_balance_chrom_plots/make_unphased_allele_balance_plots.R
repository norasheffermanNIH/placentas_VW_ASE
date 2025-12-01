# TWO-PANEL ALLELE-BALANCE PLOTS

library(ggplot2)
library(readr)
library(dplyr)
library(patchwork)

# This code makes the plots for chrX and chr8 of one quadrant (Q1) from one sample (Plac_CON02_VW-ASUPlace-Cont02_180_013_S184_L001)
# The code can be adapted for all other quadrants and samples, I will indicate what to change

# Read allele balance tsv
## Replace the paths with the tables you want to use to make the graph
chrX <- read_tsv("/vf/users/Wilson_Lab/projects/placentas_VW_ASE/asereadcounter/analyze_ase_results/allele_balance_tables/Q1/chrX/Plac_CON02_VW-ASUPlace-Cont02_180_013_S184_L001_chrX_allele_balance.tsv")
chr8 <- read_tsv("/vf/users/Wilson_Lab/projects/placentas_VW_ASE/asereadcounter/analyze_ase_results/allele_balance_tables/Q1/chr8/Plac_CON02_VW-ASUPlace-Cont02_180_013_S184_L001_chr8_allele_balance.tsv")

# Change chromosome position from b to Mb
chrX <- chrX %>% 
  mutate(pos_Mb = position/1e6)
chr8 <- chr8 %>% 
  mutate(pos_Mb = position/1e6)

# Make a plot for each chromosome
## Change sample name based on which sample you are using
sample_name <- "Plac_CON02_VW-ASUPlace-Cont02_Q1"

px <- ggplot(chrX, aes(x = pos_Mb, y = allele_balance)) +
  geom_point(size = 1, alpha = 0.8) +
  ylim(0, 1) +
  scale_x_continuous(breaks = seq(0, max(chrX$pos_Mb), by = 20)) +
  labs(
    title = sample_name, 
    x = "Chromosome X position (Mb)",
    y = "Unphased allele balance") +
  theme_bw()
px

p8 <- ggplot(chr8, aes(x = pos_Mb, y = allele_balance)) +
  geom_point(size = 1, alpha = 0.8) +
  ylim(0, 1) +
  scale_x_continuous(breaks = seq(0, max(chrX$pos_Mb), by = 20)) +
  labs(
    title = sample_name, 
    x = "Chromosome 8 position (Mb)",
    y = "Unphased allele balance") +
  theme_bw()
p8

## Combine the two plots using patchwork
combined <- px/p8
combined
ggsave("/vf/users/Wilson_Lab/projects/placentas_VW_ASE/asereadcounter/analyze_ase_results/allele_balance_chrom_plots/Q1/unphased_allele_balance_chrX&8_Plac_CON02_VW-ASUPlace-Cont02_Q1.png", combined, width = 10, height = 6, dpi = 300)
