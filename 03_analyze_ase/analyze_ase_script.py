import json
import itertools
import os

# Load config
with open("/data/Wilson_Lab/projects/placentas_VW_ASE/troubleshooting/variant_overlap_correct_swapping/correct_swapped_samples.json") as config_json:
    config = json.load(config_json)

chromosomes = ["8", "X"]
quadrants = ["Q1", "Q2", "Q3", "Q4"]

refXX = "/data/Wilson_Lab/references/GENCODE/GRCh38.p12.genome.XXonly/GRCh38.p12.genome.XXonly.fa"

output_directory_1 = "/data/Wilson_Lab/projects/placentas_VW_ASE/02_run_asereadcounter/run_asereadcounter_correct_swapping/"
output_directory_2 = "/data/Wilson_Lab/projects/placentas_VW_ASE/03_analyze_ase/analyze_ase_correct_swapping/"

calc_allele_balance_script = "/data/Wilson_Lab/projects/placentas_VW_ASE/03_analyze_ase/calc_allele_balance.py"

# for all female samples

# iterate through the dna samples and matching rna samples
#    each with chromsomes 8 and X
#    each with quadrants Q1 to Q4
# issue a ASEReadCounter command
for placenta in config["dna_rna_females"]:
    for quadrant in quadrants:
        entry = config["dna_rna_females"][placenta][quadrant]
        sample_id = entry["sample"]
        for chrom in chromosomes:
            # ASEReadCounter output
            outputfile = output_directory_1+"HISAT/"+quadrant+"/chr"+chrom+"/"+placenta+"_"+quadrant+"_chr"+chrom+"_females.tsv"
        
            # Allele balance analysis output
            outdir = output_directory_2+"allele_balance_tables/"+quadrant+"/chr"+chrom+"/"
            print(f"mkdir -p {outdir}")
            analysisfile = outdir+placenta+"_"+quadrant+"_chr"+chrom+"_allele_balance.tsv"
        
            # Build command and use it to compose a bash script
            command = "python3 " + calc_allele_balance_script + " --input " + outputfile + " --output " + analysisfile
            print(f"sbatch --mem=20G -n 2 --wrap=\"{command}\"")