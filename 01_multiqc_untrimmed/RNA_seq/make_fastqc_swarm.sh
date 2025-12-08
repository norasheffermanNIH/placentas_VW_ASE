#!/bin/bash

OUTPUT_DIR=/data/Wilson_Lab/projects/placentas_VW_ASE/01_multiqc_untrimmed/RNA_seq/fastqc_results/
mkdir -p $OUTPUT_DIR

cat fastq_list.txt | sed "s|^|fastqc -o $OUTPUT_DIR |" > fastqc.swarm