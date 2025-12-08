#!/bin/bash

#Define input and output
INPUT_CSV = "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_4quad_methylation/valleywise_methylseq_fems/samplesheet_XY.csv"
OUTPUT_TXT = "fastq_list_XY.txt"

#Extract the 2nd and 3rd columns (fastq_1 and fastq_2)
#Skip the header line (NR>1)
awk -F',' 'NR>1 {print $2 "\n" $3}' $INPUT_CSV > $OUTPUT_TXT