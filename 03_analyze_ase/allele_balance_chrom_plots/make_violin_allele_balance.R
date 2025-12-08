# UNPHASED ALLELE BALANCE VIOLIN PLOTS
# This script reads in allele balance tables for all placenta quadrants, folds the allele balance, and makes violin plots faceted by placenta.

library(dplyr)
library(purrr)
library(stringr)
library(ggplot2)

# directory containing allele balance tables
data_dir <- "/data/Wilson_Lab/projects/placentas_VW_ASE/03_analyze_ase/allele_balance_tables/"

# list all placenta files by sample and quadrant
files <- list.files(data_dir, pattern = "\\.tsv$", full.names = TRUE, recursive = TRUE)

# read one file and add placenta/quadrant from filename
read_ase_file <- function(filepath){
  # extract filename only
  fname <- basename(filepath)
  # extract placenta and quadrant from filename
  placenta_id <- str_match(fname, "^Plac_([^_]+)_")[, 2]
  quad_match <- str_match(fname, "quadrant([1-4])")
  if(!is.na(quad_match[1])) {
    quadrant_id <- paste0("Q", quad_match[2])
  } else {quadrant_id <- "Q1"}
  
  df <- read.table(filepath, header = TRUE, sep = "\t", stringsAsFactors = FALSE)

  colnames(df) <- c("chr", "position", "ref_allele", "alt_allele", "ref_count", "alt_count", "total_count", "allele_balance")
  
  # ensure numeric for counts and allele balance
  df <- df %>%
    mutate(
      position       = as.numeric(position),
      ref_count      = as.numeric(ref_count),
      alt_count      = as.numeric(alt_count),
      total_count    = as.numeric(total_count),
      allele_balance = as.numeric(allele_balance),
      placenta       = factor(placenta_id),
      quadrant       = factor(quadrant_id, levels = c("Q1", "Q2", "Q3", "Q4"))
    )
  
  df
}

# CHR X
# Combine all placenta-quadrant tables and fold ASE (If ASE < 0.5, 1-ASE)
ase_all <- map_dfr(files, read_ase_file)
ase_all_X <- ase_all %>% 
  # select just chrX
  filter(chr == "chrX") %>% 
  # if the allele balance is less than 0.5, do 1 - allele balance
  mutate(ASE_folded = ifelse(allele_balance < 0.5, 1 - allele_balance, allele_balance),
         # group normotensive and hypertensive for graphing
         group = ifelse(str_detect(placenta, "^CON"), "Control", "HDP"),
         group = factor(group, levels = c("Control", "HDP"))) %>% 
  # remove PARs
  filter(!(position >= 10001 & position <= 2781479) &
         !(position >= 155701383 & position <= 156030895))

# Plot each placenta separately, with 4 quadrants
violin_all_X <- ggplot(ase_all_X, aes(x = quadrant, y = ASE_folded)) +
  geom_violin(trim = FALSE, fill = "grey80") +
  geom_jitter(width = 0.15, alpha = 0.3, size = 0.7) +
  facet_wrap(~ placenta, ncol = 5) +
  coord_cartesian(ylim = c(0.5, 1)) +
  theme_bw(base_size = 12) +
  labs(
    x = "Quadrant",
    y = "Allele balance",
    title = "Allele balance by placenta and quadrant (chrX)")
violin_all_X
# Save plot
ggsave("/data/Wilson_Lab/projects/placentas_VW_ASE/03_analyze_ase/allele_balance_chrom_plots/violin_allele_balance_allQs_chrX.png", violin_all_X, width = 10, height = 6, dpi = 300)

# CHR 8 
# Combine all placenta-quadrant tables and fold ASE (If ASE < 0.5, 1-ASE)
ase_all_8 <- ase_all %>% 
  # select just chr8
  filter(chr == "chr8") %>% 
  # group normotensive and hypertensive for graphing
  mutate(group = ifelse(str_detect(placenta, "^CON"), "Control", "HDP"),
         group = factor(group, levels = c("Control", "HDP")))

# Plot each placenta separately, with 4 quadrants
violin_all_8 <- ggplot(ase_all_8, aes(x = quadrant, y = allele_balance)) +
  geom_violin(trim = FALSE, fill = "grey80") +
  geom_jitter(width = 0.15, alpha = 0.3, size = 0.7) +
  facet_wrap(~ placenta, ncol = 5) +
  coord_cartesian(ylim = c(0.5, 1)) +
  theme_bw(base_size = 12) +
  labs(
    x = "Quadrant",
    y = "Allele balance",
    title = "Allele balance by placenta and quadrant (chr8)")
violin_all_8
# Save plot
ggsave("/data/Wilson_Lab/projects/placentas_VW_ASE/03_analyze_ase/allele_balance_chrom_plots/violin_allele_balance_allQs_chr8.png", violin_all_8, width = 10, height = 6, dpi = 300)



# Compute median allele balance per sample per quadrant
medians_x <- ase_all_X %>% 
  group_by(placenta, quadrant) %>% 
  summarize(median = median(ASE_folded),
            q1 = quantile(ASE_folded, 0.25),
            q3 = quantile(ASE_folded, 0.75),
            n = n())
medians_x

median_plot_x <- ggplot(medians_x, aes(x = placenta, y = median)) +
  geom_point(size = 3) + 
  geom_errorbar(aes(ymin = q1, ymax = q3), width = 0.15) +
  theme_bw(base_size = 14) + 
  labs(y = "Median folded allele balance")
median_plot_x

# Compute mean allele balance per sample per quadrant
means_x <- ase_all_X %>% 
  group_by(placenta, quadrant) %>% 
  summarize(mean = mean(ASE_folded),
            q1 = quantile(ASE_folded, 0.25),
            q3 = quantile(ASE_folded, 0.75),
            n = n())
means_x

means_plot_x <- ggplot(means_x, aes(x = placenta, y = mean)) +
  geom_point(size = 3) +
  geom_errorbar(aes(ymin = q1, ymax = q3), width = 0.15) +
  theme_bw(base_size = 14) +
  labs(y = "Mean folded allele balance")
means_plot_x
