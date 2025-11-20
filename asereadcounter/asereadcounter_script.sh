#!/bin/bash

# load GATK module on Biowulf
module load gatk/4.6.0.0

# go to working directory
cd /data/Wilson_Lab/projects/placentas_VW_ASE/asereadcounter

#input TSV with sample info
TSV = "sample_pairs_Q1.tsv"

# other paths
refXX = ""
output_dir = "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/" 

chromosomes = ("8" "X")

#break up TSV into variables
#ignore header
tail -n +2 ${TSV} \
#separate by tab and read into variables
| while IFS=$'\t' read -r dna_id rna_id sex condition

#file containing heterozygous variants
vcf = "${output_dir}vqsr/chr${chromosomes}.gatk.called.vqsr.sv.biallelic.snp.${dna_id}.het.vcf"

#file containing aligned RNA seq reads
##TO FIX!!!!!!!!!!
bam = "${output_dir}rna_bams/${rna_id}_HISAT_pair_trim_sort_mkdup_rdgrp_XX.bam"

#output directory and file that combines ____
outdir = "/data/Wilson_Lab/projects/placentas_VW_ASE/asereadcounter/Q1/chr${chromosomes}/"
mkdir -p ${outdir}
outfile = "${outdir}/${dna_id}_${rna_id}_chr${chromosomes}_${sex}.tsv"

#compose command
gatk ASEReadCounter \
    -R "${refXX}" \
    --output "${outfile}" \
    --input "${bam}" \
    --variant "${vcf}" \
    --min-depth-of-non-filtered-base 1 \
    --min-mapping-quality 10 \
    --min-base-quality 10
done
