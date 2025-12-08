import json
import itertools
import os

chromosomes = ["8", "X"]

refXX = "/data/Wilson_Lab/references/GENCODE/GRCh38.p12.genome.XXonly/GRCh38.p12.genome.XXonly.fa"

output_directory_1 = "/data/Wilson_Lab/projects/placentas_VW_ASE/02_run_asereadcounter/"
output_directory_2 = "/data/Wilson_Lab/projects/placentas_VW_ASE/03_analyze_ase/"

calc_allele_balance_script = "/data/Wilson_Lab/projects/placentas_VW_ASE/03_analyze_ase/calc_allele_balance.py"

# Load config
with open("/data/Wilson_Lab/projects/placentas_VW_ASE/03_analyze_ase/analyze_ase_config.json") as config_json:
    config = json.load(config_json)

quadrants = ["Q1", "Q2", "Q3", "Q4"]

# For all female samples

# Iterate through the dna samples and matching rna samples
#    Each with chromsomes 8 and X
# Issue a ASEReadCounter command
for placenta in config["dna_rna_females"]:
    for quadrant in quadrants:
        sample_id = config["dna_rna_females"][placenta][quadrant]

        for chrom in chromosomes:
            # ASEReadCounter output
            outputfile = (
                f"{output_directory_1}HISAT/{quadrant}/chr{chrom}/"
                f"{sample_id}_chr{chrom}_females.tsv")
        
            # Allele balance analysis output
            analysisfile = (
                f"{output_directory_2}allele_balance_tables/"
                f"{quadrant}/chr{chrom}/"
                f"{placenta}_{sample_id}_chr{chrom}_allele_balance.tsv")
        
            # Build command
            command = (
                f"python {calc_allele_balance_script} "
                f"--input {outputfile} --output {analysisfile} ")
        
            print(f"sbatch --mem=20G -n 2 --wrap=\"{command}\"")