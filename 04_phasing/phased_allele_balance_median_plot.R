# MAKE PLOT OF ALLELE BALANCE MEDIANS FOR PHASED SITES

library(tidyverse)
library(ggplot2)
library(patchwork)

summary <- read_tsv("/data/Wilson_Lab/projects/placentas_VW_ASE/04_phasing/phased_median.tsv")

# Keep chrX only for the top panel
chrX <- summary %>%
  filter(chromosome == "X")
# Manually establish x-axis order
my_order <- c("Plac_HDP01", "Plac_CON06", "Plac_CON05", "Plac_HDP09", "Plac_CON03", "Plac_CON10", "Plac_CON02","Plac_HDP10", "Plac_HDP08")
# Reshape to long
chrX_long <- chrX %>%
  pivot_longer(cols = starts_with("median_"),
               names_to = "quadrant",
               values_to = "median_phased_AB") %>%
  mutate(quadrant = str_replace(quadrant, "median_", ""),
    placenta = factor(placenta, levels = my_order))
# Plot
chrX_plot <- ggplot(chrX_long, aes(x = placenta,
                      y = median_phased_AB, 
                      group = quadrant,
                      color = quadrant,
                      shape = quadrant)) +
  geom_point(size = 3) +
  geom_line(linewidth = 0.7) +
  scale_y_continuous(limits = c(0, 1)) +
  labs(title = "Median Phased Allele Balance per Placenta (chrX)",
       x = "Placenta",
       y = "Median Phased Allele Balance") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))


# Keep chr8 only for the bottom panel
chr8 <- summary %>%
  filter(chromosome == "8")
# Reshape to long
chr8_long <- chr8 %>%
  pivot_longer(cols = starts_with("median_"),
               names_to = "quadrant",
               values_to = "median_phased_AB") %>%
  mutate(quadrant = str_replace(quadrant, "median_", ""),
         placenta = factor(placenta, levels = my_order))
# Plot
chr8_plot <- ggplot(chr8_long, aes(x = placenta,
                      y = median_phased_AB, 
                      group = quadrant,
                      color = quadrant,
                      shape = quadrant)) +
  geom_point(size = 3) +
  geom_line(linewidth = 0.7) +
  scale_y_continuous(limits = c(0, 1)) +
  labs(title = "Median Phased Allele Balance per Placenta (chr8)",
       x = "Placenta",
       y = "Median Phased Allele Balance") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))

# Combine both graphs into two panels
combined <- chrX_plot/chr8_plot
combined

ggsave("/vf/users/Wilson_Lab/projects/placentas_VW_ASE/04_phasing/median_phased_AB_plot.png", plot = combined, width = 8, height = 6, dpi = 300)
