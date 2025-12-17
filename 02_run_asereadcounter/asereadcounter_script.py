import json
import itertools

#Load config
with open("/data/Wilson_Lab/projects/placentas_VW_ASE/02_run_asereadcounter/asereadcounter_config.json") as config_json:
    config = json.load(config_json)

chromosomes = ["8", "X"]

gatk_path = "module load GATK/4.6.0.0; gatk"

refXX = "/data/Wilson_Lab/references/GENCODE/GRCh38.p12.genome.XXonly/GRCh38.p12.genome.XXonly.fa"

output_directory = "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/"
final_output = "/data/Wilson_Lab/projects/placentas_VW_ASE/02_run_asereadcounter/"

bam_dirs = {
    "Q1": "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/processed_bams/rna/",
    "Q2": "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_3samples/processed_bams_HG38/rna/",
    "Q3": "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_3samples/processed_bams_HG38/rna/",
    "Q4": "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_3samples/processed_bams_HG38/rna/",
}

# Quadrants to process
quadrants = ["Q1", "Q2", "Q3", "Q4"]

# for all female samples

# iterate through the dna samples and matching rna samples
#    each with chromsomes 8 and X
#    each with quadrants Q1 to Q4
# issue a ASEReadCounter command
for placenta in config["dna_rna_females"]:
    for quadrant in quadrants:
        sample_id = config["dna_rna_females"][placenta][quadrant]
        for chrom in chromosomes:
            # VCF file
            sites = output_directory+"vqsr/chr"+chrom+".gatk.called.vqsr.sv.biallelic.snp."+placenta+".het.vcf"

            # BAM file
            bam = bam_dirs[quadrant]+sample_id+"_HISAT_pair_trim_sort_mkdup_rdgrp_XX.bam"

            # Output file that combines vcf, bam, and chromosome
            outputfile = final_output+"HISAT/"+quadrant+"/chr"+chrom+"/"+sample_id+"_chr"+chrom+"_females.tsv"
                
            # Compose command and use it to compose a bash script
            command = gatk_path + " ASEReadCounter -R " + refXX + " --output " + outputfile + " --input " + bam + " --variant " + sites + " --min-depth-of-non-filtered-base 1 --min-mapping-quality 10 --min-base-quality 10"
            print(f"sbatch -time=24:00:00 --mem=20G -n 2 --wrap=\"{command}\"")