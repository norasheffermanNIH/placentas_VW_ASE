#!/bin/bash

#Load MultiQC
module load multiqc

#Define directories
INPUT_DIR="/data/Wilson_Lab/projects/placentas_VW_ASE/01_multiqc_untrimmed/methyl_seq/fastqc_results_XX/"
OUTPUT_DIR="/data/Wilson_Lab/projects/placentas_VW_ASE/01_multiqc_untrimmed/methyl_seq/multiqc_results_XX/"

mkdir -p $OUTPUT_DIR

#Run MultiQC
multiqc $INPUT_DIR -o $OUTPUT_DIR