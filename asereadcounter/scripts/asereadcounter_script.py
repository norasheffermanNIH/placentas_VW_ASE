import json
import itertools

chromosomes = ["8", "X"]

gatk_path = "module load GATK/4.6.0.0; gatk"

refXX = "/data/Wilson_Lab/references/GENCODE/GRCh38.p12.genome.XXonly/GRCh38.p12.genome.XXonly.fa"

output_directory_dna = "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/"
output_directory_rna = "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/"
final_output = "/data/Wilson_Lab/projects/placentas_VW_ASE/asereadcounter/"

# Quadrants to process
quadrants = ["Q1", "Q2", "Q3", "Q4"]

for quadrant in quadrants:
    config_path = f"asereadcounter{quadrant}_config.json"
    with open(config_path) as config_json:
        dna_rna_hash = json.load(config_json)   

    # For female samples

    # Iterate through the dna samples and matching rna samples
    #    Each with chromsomes 8 and X
    # Issue a ASEReadCounter command
    for key in dna_rna_hash["dna_rna_females"]:
        for item in dna_rna_hash["dna_rna_females"][key]:
            for chrom in chromosomes:
                # vcf file
                sites = output_directory_dna+"vqsr/chr"+chrom+".gatk.called.vqsr.sv.biallelic.snp."+key+".het.vcf"

                # bam file
                ## Replace based on quadrant
                bam = output_directory_rna+"processed_bams/rna/"+item+"_HISAT_pair_trim_sort_mkdup_rdgrp_XX.bam"

                # Output file that combines vcf, bam, and chromosome
                outputfile = final_output+f"HISAT/{quadrant}/chr"+chrom+"/"+item+"_chr"+chrom+"_females.tsv"
                # Compose command and use it to compose a bash script
                command = gatk_path + " ASEReadCounter -R " + refXX + " --output " + outputfile + " --input " + bam + " --variant " + sites + " --min-depth-of-non-filtered-base 1 --min-mapping-quality 10 --min-base-quality 10"
                print(f"sbatch --mem=20G -n 2 --wrap=\"{command}\"")