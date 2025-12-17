import json
import itertools
import os

# Load config
with open("/data/Wilson_Lab/projects/placentas_VW_ASE/05_males/asereadcounter_config_males.json") as config_json:
    config = json.load(config_json)

chromosomes = ["20"]

refXY = "/data/Wilson_Lab/references/GENCODE/GRCh38.p12.genome.XY/GRCh38.p12.genome.XY.fa"

output_directory = "/data/Wilson_Lab/projects/placentas_VW_ASE/05_males/"

calc_allele_balance_script = "/data/Wilson_Lab/projects/placentas_VW_ASE/03_analyze_ase/calc_allele_balance.py"

# Quadrants to process
quadrants = ["Q1", "Q2", "Q3", "Q4"]

# for all male samples

# iterate through the dna samples and matching rna samples
#    each with chromsomes 8 and X
#    each with quadrants Q1 to Q4
# issue a ASEReadCounter command
for placenta in config["dna_rna_males"]:
    for quadrant in quadrants:
        sample_id = config["dna_rna_males"][placenta][quadrant]
        for chrom in chromosomes:
            # ASEReadCounter output
            outputfile = output_directory+"HISAT/"+quadrant+"/chr"+chrom+"/"+sample_id+"_chr"+chrom+"_males.tsv"
        
            # Allele balance analysis output
            analysisfile = output_directory+"allele_balance_tables/"+quadrant+"/chr"+chrom+"/"+placenta+"_"+sample_id+"_chr"+chrom+"_allele_balance.tsv"

            # Build command and use it to compose a bash script
            command = "python " + calc_allele_balance_script + " --input " + outputfile + " --output " + analysisfile
            print(f"sbatch --mem=20G -n 2 --wrap=\"{command}\"")