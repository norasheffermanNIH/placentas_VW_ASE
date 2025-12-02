import json
import itertools
import os

chromosomes = ["8", "X"]

refXX = "/data/Wilson_Lab/references/GENCODE/GRCh38.p12.genome.XXonly/GRCh38.p12.genome.XXonly.fa"

output_directory_dna = "/data/Wilson_Lab/projects/placentas_VW_ASE/asereadcounter/"

calc_allele_balance_script = "/data/Wilson_Lab/projects/placentas_VW_ASE/asereadcounter/scripts/calc_allele_balance.py"

#quadrants to process
quadrants = ["Q1", "Q2", "Q3", "Q4"]

for quadrant in quadrants:
    config_path = f"asereadcounter{quadrant}_config.json"
    with open(config_path) as config_json:
        dna_rna_hash = json.load(config_json)

    # for all female samples

    # iterate through the dna samples and matching rna samples
    #    each with chromsomes 8 and X
    # issue a ASEReadCounter command
    for key in dna_rna_hash["dna_rna_females"]:
        for item in dna_rna_hash["dna_rna_females"][key]:
            for chrom in chromosomes:
                # asereadcounter output
                outputfile = output_directory_dna+f"HISAT/{quadrant}/chr"+chrom+"/"+item+"_chr"+chrom+"_females.tsv"
                analysisfile = output_directory_dna+f"analyze_ase_results/allele_balance_tables/{quadrant}/chr"+chrom+"/"+key+"_"+item+"_chr"+chrom+"_allele_balance.tsv"
                # compose command
                command = "python "+calc_allele_balance_script+" --input "+outputfile+" --output "+analysisfile
                print(f"sbatch --mem=20G -n 2 --wrap=\"{command}\"")
