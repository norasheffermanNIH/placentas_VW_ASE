# UNPHASED ALLELE BALANCE VIOLIN PLOTS
# This script reads in allele balance tables for all placenta quadrants, folds the allele balance, and makes violin plots faceted by placenta.

library(dplyr)
library(purrr)
library(stringr)
library(ggplot2)

# directory containing allele balance tables
data_dir <- "/data/Wilson_Lab/projects/placentas_VW_ASE/asereadcounter/analyze_ase_results/allele_balance_tables"

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

# combine all placenta-quadrant tables and fold ASE (If ASE < 0.5, 1-ASE)
ase_all <- map_dfr(files, read_ase_file)
ase_all <- ase_all %>% 
  # select just chrX
  filter(chr == "chrX") %>% 
  # if the allele balance is less than 0.5, do 1 - allele balance
  mutate(ASE_folded = ifelse(allele_balance < 0.5, 1 - allele_balance, allele_balance),
         # group normotensive and hypertensive for graphing
         group = ifelse(str_detect(placenta, "^CON"), "Control", "HDP"),
         group = factor(group, levels = c("Control", "HDP"))) %>% 
  # remove PARs
  filter(!(position >= 10001 & position <= 2781479),
         !(position >= 155701383 & position <= 156030895))

# plot
violin_all <- ggplot(ase_all, aes(x = quadrant, y = ASE_folded)) +
  geom_violin(trim = FALSE, fill = "grey80") +
  geom_jitter(width = 0.15, alpha = 0.3, size = 0.7) +
  facet_wrap(~ placenta, ncol = 5) +
  coord_cartesian(ylim = c(0.5, 1)) +
  theme_bw(base_size = 12) +
  labs(
    x = "Quadrant",
    y = "Allele balance",
    title = "Allele balance by placenta and quadrant")
violin_all

ggsave("/vf/users/Wilson_Lab/projects/placentas_VW_ASE/asereadcounter/analyze_ase_results/allele_balance_chrom_plots/violin_allele_balance_allQs.png", violin_all, width = 10, height = 6, dpi = 300)

