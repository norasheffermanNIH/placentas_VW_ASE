#!/bin/bash

#Load MultiQC
module load multiqc

#Define directories
INPUT_DIR = "/data/Wilson_Lab/projects/placentas_VW_ASE/multiqc_untrimmed/RNA_seq/fastqc_results"
OUTPUT_DIR = "/data/Wilson_Lab/projects/placentas_VW_ASE/multiqc_untrimmed/RNA_seq/multiqc_results"

mkdir -p $OUTPUT_DIR

#Run MultiQC
multiqc $INPUT_DIR -o $OUTPUT_DIR