#!/bin/bash

#Add FASTQs from Q1
find /data/Wilson_Lab/placenta/valleywise_raw_data/RNAseq -type f -name "*.fastq.gz" | sort >> fastq_list.txt

#Add merged FASTQs from Q2-4
find /data/Wilson_Lab/projects/placentas_VW_ASE/01_multiqc_untrimmed/RNA_seq/merged_fastqs -type f -name "*.fastq.gz" | sort >> fastq_list.txt