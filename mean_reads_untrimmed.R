# MEAN NUMBER OF READS

#load in packages
library(readr)
library(dplyr)
library(stringr)
library(tidyr)
library(writexl)

#Exome Seq Total Sequence Count Summary
exome <- read_tsv("/data/Wilson_Lab/projects/placentas_VW_ASE/multiqc_untrimmed/exome_seq/multiqc_results/multiqc_data/multiqc_fastqc.txt")
#organize by patient, quadrant, replicate 
summary_exome <- exome %>% 
  select(Sample, `Total Sequences`) %>% 
  mutate(Patient = str_extract(Sample, "(CON\\d+|HDP\\d+)"),
         Quadrant = str_extract(Sample, "_(Q[1-4])_") %>%
                    str_replace_all("_", "")) %>% 
  mutate(Assay = "Exome")

#Methyl Seq Total Sequence Count Summary
#XX
methyl_XX <- read_tsv("/data/Wilson_Lab/projects/placentas_VW_ASE/multiqc_untrimmed/methyl_seq/multiqc_results_XX/multiqc_data/multiqc_fastqc.txt")
#organize by patient, quadrant, replicate 
summary_methyl_XX <- methyl_XX %>% 
  select(Sample, `Total Sequences`) %>% 
  mutate(Patient = str_extract(Sample, "(Cont\\d+|HDP\\d+)") %>% 
           str_replace("Cont", "CON"),
         Quadrant = str_extract(Sample, "_([A-D]|Q[1-4])_") %>%
           str_replace_all("_", "") %>% 
           recode("A" = "Q1", "B" = "Q2", "C" = "Q3", "D" = "Q4")) %>% 
  mutate(Assay = "Methyl_XX")
#XY
methyl_XY <- read_tsv("/data/Wilson_Lab/projects/placentas_VW_ASE/multiqc_untrimmed/methyl_seq/multiqc_results_XY/multiqc_data/multiqc_fastqc.txt")
#organize by patient, quadrant, replicate 
summary_methyl_XY <- methyl_XY %>% 
  select(Sample, `Total Sequences`) %>% 
  mutate(Patient = str_extract(Sample, "(Cont\\d+|HDP\\d+)") %>% 
           str_replace("Cont", "CON"),
         Quadrant = str_extract(Sample, "_([A-D]|Q[1-4])_") %>%
           str_replace_all("_", "") %>% 
           recode("A" = "Q1", "B" = "Q2", "C" = "Q3", "D" = "Q4")) %>% 
  mutate(Assay = "Methyl_XY")

#RNA Seq Total Count Summary
RNA <- read_tsv("/data/Wilson_Lab/projects/placentas_VW_ASE/multiqc_untrimmed/RNA_seq/multiqc_results/multiqc_data/multiqc_fastqc.txt")
#organize by patient, quadrant, replicate 
summary_RNA <- RNA %>% 
  select(Sample, `Total Sequences`) %>% 
  mutate(Patient = str_extract(Sample, "(Cont\\d+|cont\\d+|-cont-\\d+|HDP\\d+)") %>% 
           str_replace("Cont", "CON") %>% 
         str_replace("cont", "CON") %>% 
           str_replace("-CON-", "CON"),
         Quadrant = str_extract(Sample, "_([A-D]|quad[1-4]|Q[1-4])_") %>%
           str_replace_all("_", "") %>% 
           recode("quad1" = "Q1", "quad2" = "Q2", "quad3" = "Q3", "quad4" = "Q4")) %>% 
  #all NAs in the Quadrant column correspond to Q1, formatting that
  mutate(Quadrant = if_else(is.na(Quadrant), "Q1", Quadrant)) %>% 
  mutate(Assay = "RNA")

#Combine each table into one big table containing all assays and sequence counts
combined <- bind_rows(summary_exome, summary_methyl_XX, summary_methyl_XY, summary_RNA) %>% 
  select(Patient, Quadrant, `Total Sequences`, Assay)

#Calculate mean number of reads 
#Assay
mean_by_assay <- combined %>% 
  group_by(Assay) %>% 
  summarise(mean_reads = mean(`Total Sequences`, na.rm = TRUE))
#Patient
mean_by_patient <- combined %>% 
  group_by(Assay, Patient) %>% 
  summarise(mean_reads = mean(`Total Sequences`, na.rm = TRUE))
#Quadrant
mean_by_quad <- combined %>% 
  group_by(Assay, Patient, Quadrant) %>% 
  summarise(mean_reads = mean(`Total Sequences`, na.rm = TRUE))

#Table to export
mean_reads_wide <- mean_by_quad %>%
  pivot_wider(names_from = Quadrant, values_from = mean_reads) %>%
  arrange(Assay, Patient)
#Save table
write_tsv(mean_reads_wide, "/data/Wilson_Lab/projects/placentas_VW_ASE/multiqc_untrimmed/mean_reads_untrimmed.tsv")
