# WHICH GENES ARE ESCAPING X-INACTIVATION?

## NEED TO EDIT

library(dplyr)
library(readr)
library("biomaRt")

HDP_01_Q1 <- read_tsv("/vf/users/Wilson_Lab/projects/placentas_VW_ASE/asereadcounter/analyze_ase_results/allele_balance_tables/Q1/chrX/Plac_HDP01_VW-ASUPlace-HDP01_167_026_S193_L001_chrX_allele_balance.tsv")
HDP_01_Q1 %>% filter(!(position >= 10001 & position <= 2781479) &
                              !(position >= 155701383 & position <= 156030895)) %>% 
  filter(allele_balance < 0.75)
#Genes: XG, Xp11, CLCN5
#CLCN5 usually is silenced....

mart <- useEnsembl(biomart = "genes", dataset = "hsapiens_gene_ensembl", host = "https://dec2023.archive.ensembl.org")
all.gene <- getBM(
  attributes=c("ensembl_gene_id","hgnc_symbol","chromosome_name","start_position","end_position"),
  filters=c("chromosome_name", "start", "end"),
  values=list(chromosome="X", start="3310370",end="3310370"),
  mart=mart)



HDP_01_Q3 <- read_tsv("/vf/users/Wilson_Lab/projects/placentas_VW_ASE/asereadcounter/analyze_ase_results/allele_balance_tables/Q3/chrX/Plac_HDP01_HDP01_quadrant3_Sample_11_021_172_chrX_allele_balance.tsv")
HDP_01_Q3 %>% dplyr::filter(!(position >= 10001 & position <= 2781479) &
                              !(position >= 155701383 & position <= 156030895)) %>% 
  dplyr::filter(allele_balance < 0.75)
#Genes: XG, Xp11 region, CLCN5

CON_02_Q1 <- read_tsv("/vf/users/Wilson_Lab/projects/placentas_VW_ASE/asereadcounter/analyze_ase_results/allele_balance_tables/Q1/chrX/Plac_CON02_VW-ASUPlace-Cont02_180_013_S184_L001_chrX_allele_balance.tsv")
CON_02_Q1 %>% dplyr::filter(!(position >= 10001 & position <= 2781479) &
                              !(position >= 155701383 & position <= 156030895)) %>% 
  dplyr::filter(allele_balance < 0.75)
#Genes: XG

HDP_08_Q1 <- read_tsv("/vf/users/Wilson_Lab/projects/placentas_VW_ASE/asereadcounter/analyze_ase_results/allele_balance_tables/Q1/chrX/Plac_HDP08_VW-ASUPlace-HDP08_Q1RNA1_178_015_S200_L001_chrX_allele_balance.tsv")
HDP_08_Q1 %>% dplyr::filter(!(position >= 10001 & position <= 2781479) &
                              !(position >= 155701383 & position <= 156030895)) %>% 
  dplyr::filter(allele_balance < 0.75)