#### MAKE PLOT OF ALLELE BALANCE MEDIANS FOR PHASED SITES, FEMALES ####

# Load in and read packages
library(readr)
library(dplyr)
library(tidyverse)
library(ggplot2)
library(patchwork)

#### CHRX ####
chrX <- read_tsv("/vf/users/Wilson_Lab/projects/placentas_VW_ASE/04_phasing/phased_allele_balance/all_placenta_chrX_phased_allele_balance.tsv")
# Re-format table & rename columns for graphing
# Manually establish x-axis order
my_order <- c("Plac_CON02", "Plac_CON03", "Plac_CON05", "Plac_CON06", "Plac_CON10", "Plac_HDP01", "Plac_HDP08", "Plac_HDP09", "Plac_HDP10")
chrX_medians <- chrX %>% 
  select(placenta_id, starts_with("median_")) %>%
  pivot_longer(cols = starts_with("median_"),
               names_to = "quadrant",
               values_to = "median_phased_AB") %>%
  mutate(quadrant = gsub("median_phased_allele_balance_", "", quadrant),
         placenta = factor(placenta_id, levels = my_order))

# Plot
chrX_plot <- ggplot(chrX_medians, aes(x = placenta,
                                      y = median_phased_AB,
                                      group = quadrant,
                                      color = quadrant,
                                      shape = quadrant)) +
  geom_point(size = 3) +
  scale_y_continuous(limits = c(0, 1)) +
  labs(title = "Median Phased Allele Balance per Placenta (chrX) -- Females",
       x = "Placenta",
       y = "Median Phased Allele Balance") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
chrX_plot

#### CHR 8 ####
# Read in summary table
chr8 <- read_tsv("/vf/users/Wilson_Lab/projects/placentas_VW_ASE/04_phasing/phased_allele_balance/all_placenta_chr8_phased_allele_balance.tsv")
# Re-format table & rename columns for graphing
chr8_medians <- chr8 %>%
  select(placenta_id, starts_with("median_")) %>%
  pivot_longer(cols = starts_with("median_"),
               names_to = "quadrant",
               values_to = "median_phased_AB") %>%
  mutate(quadrant = gsub("median_phased_allele_balance_", "", quadrant),
         placenta = factor(placenta_id, levels = my_order))

# Plot
chr8_plot <- ggplot(chr8_medians, aes(x = placenta,
                                      y = median_phased_AB,
                                      group = quadrant,
                                      color = quadrant,
                                      shape = quadrant)) +
  geom_point(size = 3) +
  scale_y_continuous(limits = c(0, 1)) +
  labs(title = "Median Phased Allele Balance per Placenta (chr8) -- Females",
       x = "Placenta",
       y = "Median Phased Allele Balance") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
chr8_plot

#### COMBINE PLOTS AND SAVE PNG ####
combined <- chrX_plot/chr8_plot
combined
ggsave("/vf/users/Wilson_Lab/projects/placentas_VW_ASE/05_plotting/median_phased_AB_plot_females.png", plot = combined, width = 8, height = 6, dpi = 300)
