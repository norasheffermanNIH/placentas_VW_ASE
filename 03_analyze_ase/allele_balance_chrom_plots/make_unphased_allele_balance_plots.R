# TWO-PANEL UNPHASED ALLELE BALANCE CHROMOSOME PLOTS
# This script reads in unphased allele balance tables for chrX and chr8 for a given placenta quadrant, and makes two-panel scatter plots of allele balance vs. position for each sample.
# This script can be submitted to the cluster to generate all the plots at once. 

library(ggplot2)
library(readr)
library(dplyr)
library(stringr)
library(patchwork)

args <- commandArgs(trailingOnly = TRUE)
quadrant <- args[1]

base_in  <- "/data/Wilson_Lab/projects/placentas_VW_ASE/03_analyze_ase/allele_balance_tables/"
base_out <- "/data/Wilson_Lab/projects/placentas_VW_ASE/03_analyze_ase/allele_balance_chrom_plots/"

indir  <- file.path(base_in, quadrant)
outdir <- file.path(base_out, quadrant)

if (!dir.exists(outdir)) dir.create(outdir, recursive = TRUE)

# Find input files
# chrX and chr8 TSVs for this quadrant
files_chrX <- list.files(file.path(indir, "chrX"),
                         pattern = "\\.tsv$", full.names = TRUE)
files_chr8 <- list.files(file.path(indir, "chr8"),
                         pattern = "\\.tsv$", full.names = TRUE)

# Extract sample id from filename: everything before "_chr"
get_sample_id <- function(f) {
  str_extract(basename(f), "^.+?(?=_chr)")}

df_chrX_files <- data.frame(
  sample_id = get_sample_id(files_chrX),
  file_chrX = files_chrX,
  stringsAsFactors = FALSE)

df_chr8_files <- data.frame(
  sample_id = get_sample_id(files_chr8),
  file_chr8 = files_chr8,
  stringsAsFactors = FALSE)

# Match chrX and chr8 by sample_id
pairs <- inner_join(df_chrX_files, df_chr8_files, by = "sample_id")

message("Found ", nrow(pairs), " sample(s) in ", quadrant)

# Loop over samples
for (i in seq_len(nrow(pairs))) {
  sid   <- pairs$sample_id[i]
  fX    <- pairs$file_chrX[i]
  f8    <- pairs$file_chr8[i]
  
  # Read tables
  chrX <- read_tsv(fX, show_col_types = FALSE)
  chr8 <- read_tsv(f8, show_col_types = FALSE)
  
  # bp -> Mb
  chrX <- chrX %>% mutate(pos_Mb = position / 1e6)
  chr8 <- chr8 %>% mutate(pos_Mb = position / 1e6)
  
  sample_name <- paste0(sid, "_", quadrant)
  
  px <- ggplot(chrX, aes(x = pos_Mb, y = allele_balance)) +
    geom_point(size = 1, alpha = 0.8) +
    ylim(0, 1) +
    scale_x_continuous(breaks = seq(0, max(chrX$pos_Mb), by = 20)) +
    labs(
      title = sample_name,
      x = "Chromosome X position (Mb)",
      y = "Unphased allele balance"
    ) +
    theme_bw()
  
  p8 <- ggplot(chr8, aes(x = pos_Mb, y = allele_balance)) +
    geom_point(size = 1, alpha = 0.8) +
    ylim(0, 1) +
    scale_x_continuous(breaks = seq(0, max(chr8$pos_Mb), by = 20)) +
    labs(
      title = sample_name,
      x = "Chromosome 8 position (Mb)",
      y = "Unphased allele balance"
    ) +
    theme_bw()
  
  # Combine the two plots using patchwork
  combined <- px/p8
  
  outfile <- file.path(outdir, paste0("unphased_allele_balance_chrX_chr8_", sample_name, ".png"))
  
  ggsave(outfile, combined, width = 10, height = 6, dpi = 300)
}
