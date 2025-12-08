import json
import itertools

chromosomes = ["8", "X"]

gatk_path = "module load GATK/4.6.0.0; gatk"

refXX = "/data/Wilson_Lab/references/GENCODE/GRCh38.p12.genome.XXonly/GRCh38.p12.genome.XXonly.fa"

output_directory_dna = "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/"
output_directory_rna = "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/"
final_output = "/data/Wilson_Lab/projects/placentas_VW_ASE/02_run_asereadcounter/"

# Load config
with open("/data/Wilson_Lab/projects/placentas_VW_ASE/02_run_asereadcounter/asereadcounter_config.json") as config_json:
    config = json.load(config_json)

# Quadrants to process
quadrants = ["Q1", "Q2", "Q3", "Q4"]

for placenta in config["dna_rna_females"]:
    for quadrant in quadrants:
        rna_sample = config["dna_rna_females"][placenta][quadrant]
        
        for chrom in chromosomes:
            # VCF file
            sites = output_directory_dna+"vqsr/chr"+chrom+".gatk.called.vqsr.sv.biallelic.snp."+placenta+".het.vcf"

            # BAM file
            bam = output_directory_rna+"processed_bams/rna/"+rna_sample+"_HISAT_pair_trim_sort_mkdup_rdgrp_XX.bam"

            # Output file that combines vcf, bam, and chromosome
            outputfile = final_output+f"HISAT/{quadrant}/chr"+chrom+"/"+rna_sample+"_chr"+chrom+"_females.tsv"
                
            # Compose command and use it to compose a bash script
            command = gatk_path + " ASEReadCounter -R " + refXX + " --output " + outputfile + " --input " + bam + " --variant " + sites + " --min-depth-of-non-filtered-base 1 --min-mapping-quality 10 --min-base-quality 10"
            print(f"sbatch --mem=20G -n 2 --wrap=\"{command}\"")