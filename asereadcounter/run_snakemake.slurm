#!/bin/bash
#SBATCH --job-name=snakemake
#SBATCH --cpus-per-task=64
#SBATCH --mem=64g
#SBATCH --time=48:00:00
#SBATCH --output=snakemake.%j.out

module load snakemake
module load fastqc
module load multiqc
module load samtools
module load bamtools
module load perl
module load picard
module load hisat2

cd /data/Wilson_Lab/projects/placentas_VW_ASE/asereadcounter
snakemake -s processed_bams_Q1.snakefile --cluster "sbatch --mem={resources.mem_mb} --cpus-per-task=4" -j 10
