#!/bin/bash

OUTPUT_DIR = /data/Wilson_Lab/projects/placentas_VW_ASE/multiqc_untrimmed/methyl_seq/fastqc_results_XY
mkdir -p $OUTPUT_DIR

cat fastq_list_XY.txt | sed "s|^|fastqc -o $OUTPUT_DIR |" > fastqc_XY.swarm