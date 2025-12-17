#### MAKE PLOT OF ALLELE BALANCE MEDIANS FOR PHASED SITES, MALES ####

# Load in and read packages
library(readr)
library(dplyr)
library(tidyverse)
library(ggplot2)
library(patchwork)

#### CHRX ####
chrX_males <- read_tsv("/vf/users/Wilson_Lab/projects/placentas_VW_ASE/05_males/phased_allele_balance/all_placenta_chrX_phased_allele_balance.tsv")
# Re-format table & rename columns for graphing
# Manually establish x-axis order
my_order_males <- c("Plac_HDP06", "Plac_HDP05", "Plac_HDP02", "Plac_HDP07", "Plac_CON09", "Plac_CON08", "Plac_CON07", "Plac_CON04", "Plac_CON01", "Plac_HDP04", "Plac_HDP03")
chrX_medians_males <- chrX_males %>% 
  select(placenta_id, starts_with("median_")) %>%
  pivot_longer(cols = starts_with("median_"),
               names_to = "quadrant",
               values_to = "median_phased_AB") %>%
  mutate(quadrant = gsub("median_phased_allele_balance_", "", quadrant),
         placenta = factor(placenta_id, levels = my_order_males))

# Plot
chrX_plot_males <- ggplot(chrX_medians_males, aes(x = placenta,
                                      y = median_phased_AB,
                                      group = quadrant,
                                      color = quadrant,
                                      shape = quadrant)) +
  geom_point(size = 3) +
  scale_y_continuous(limits = c(0, 1)) +
  labs(title = "Median Phased Allele Balance per Placenta (chrX)",
       x = "Placenta",
       y = "Median Phased Allele Balance") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
chrX_plot_males

#### CHR 8 ####
# Read in summary table
chr8_males <- read_tsv("/vf/users/Wilson_Lab/projects/placentas_VW_ASE/05_males/phased_allele_balance/all_placenta_chr8_phased_allele_balance.tsv")
# Re-format table & rename columns for graphing
chr8_medians_males <- chr8_males %>%
  select(placenta_id, starts_with("median_")) %>%
  pivot_longer(cols = starts_with("median_"),
               names_to = "quadrant",
               values_to = "median_phased_AB") %>%
  mutate(quadrant = gsub("median_phased_allele_balance_", "", quadrant),
         placenta = factor(placenta_id, levels = my_order_males))

# Plot
chr8_plot_males <- ggplot(chr8_medians_males, aes(x = placenta,
                                      y = median_phased_AB,
                                      group = quadrant,
                                      color = quadrant,
                                      shape = quadrant)) +
  geom_point(size = 3) +
  scale_y_continuous(limits = c(0, 1)) +
  labs(title = "Median Phased Allele Balance per Placenta (chr8)",
       x = "Placenta",
       y = "Median Phased Allele Balance") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
chr8_plot_males

#### COMBINE PLOTS AND SAVE PNG ####
combined_males <- chrX_plot_males/chr8_plot_males
combined_males
ggsave("/vf/users/Wilson_Lab/projects/placentas_VW_ASE/05_males/median_phased_AB_plot_males.png", plot = combined_males, width = 8, height = 6, dpi = 300)
