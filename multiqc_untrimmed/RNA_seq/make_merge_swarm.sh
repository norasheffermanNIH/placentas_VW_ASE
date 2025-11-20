#!/bin/bash

#script to get all of the unmerged files into one swarm file, can then run swarm job to merge all of the files
cd /data/Wilson_Lab/placenta/valleywise_raw_data/valleywise_placenta_3samples/quadrant_2
for d in Sample_*; do
    sample=$(basename "$d")
    r1_out="/data/Wilson_Lab/projects/placentas_VW_ASE/multiqc_untrimmed/RNA_seq/merged_fastqs/${sample}_quad2_R1_merged.fastq.gz"
    r2_out="/data/Wilson_Lab/projects/placentas_VW_ASE/multiqc_untrimmed/RNA_seq/merged_fastqs/${sample}_quad2_R2_merged.fastq.gz"
    r1_files=$(ls /data/Wilson_Lab/placenta/valleywise_raw_data/valleywise_placenta_3samples/quadrant_2/$d/*_R1_*.fastq.gz | tr '\n' ' ')
    r2_files=$(ls /data/Wilson_Lab/placenta/valleywise_raw_data/valleywise_placenta_3samples/quadrant_2/$d/*_R2_*.fastq.gz | tr '\n' ' ')
    echo "cat $r1_files > $r1_out && cat $r2_files > $r2_out"
done >> /data/Wilson_Lab/users/sheffermannm/placenta_ASE/multiqc_untrimmed/RNA_seq/merge_fastqs.swarm

cd /data/Wilson_Lab/placenta/valleywise_raw_data/valleywise_placenta_3samples/quadrant_3
for d in Sample_*; do
    sample=$(basename "$d")
    r1_out="/data/Wilson_Lab/projects/placentas_VW_ASE/multiqc_untrimmed/RNA_seq/merged_fastqs/${sample}_quad3_R1_merged.fastq.gz"
    r2_out="/data/Wilson_Lab/projects/placentas_VW_ASE/multiqc_untrimmed/RNA_seq/merged_fastqs/${sample}_quad3_R2_merged.fastq.gz"
    r1_files=$(ls /data/Wilson_Lab/placenta/valleywise_raw_data/valleywise_placenta_3samples/quadrant_3/$d/*_R1_*.fastq.gz | tr '\n' ' ')
    r2_files=$(ls /data/Wilson_Lab/placenta/valleywise_raw_data/valleywise_placenta_3samples/quadrant_3/$d/*_R2_*.fastq.gz | tr '\n' ' ')
    echo "cat $r1_files > $r1_out && cat $r2_files > $r2_out"
done >> /data/Wilson_Lab/users/sheffermannm/placenta_ASE/multiqc_untrimmed/RNA_seq/merge_fastqs.swarm

cd /data/Wilson_Lab/placenta/valleywise_raw_data/valleywise_placenta_3samples/quadrant_4
for d in Sample_*; do
    sample=$(basename "$d")
    r1_out="/data/Wilson_Lab/projects/placentas_VW_ASE/multiqc_untrimmed/RNA_seq/merged_fastqs/${sample}_quad4_R1_merged.fastq.gz"
    r2_out="/data/Wilson_Lab/projects/placentas_VW_ASE/multiqc_untrimmed/RNA_seq/merged_fastqs/${sample}_quad4_R2_merged.fastq.gz"
    r1_files=$(ls /data/Wilson_Lab/placenta/valleywise_raw_data/valleywise_placenta_3samples/quadrant_4/$d/*_R1_*.fastq.gz | tr '\n' ' ')
    r2_files=$(ls /data/Wilson_Lab/placenta/valleywise_raw_data/valleywise_placenta_3samples/quadrant_4/$d/*_R2_*.fastq.gz | tr '\n' ' ')
    echo "cat $r1_files > $r1_out && cat $r2_files > $r2_out"
done >> /data/Wilson_Lab/users/sheffermannm/placenta_ASE/multiqc_untrimmed/RNA_seq/merge_fastqs.swarm

