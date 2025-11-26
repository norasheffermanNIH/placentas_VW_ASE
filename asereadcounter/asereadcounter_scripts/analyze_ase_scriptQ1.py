import json
import itertools
import os

config_json = open("asereadcounter_config.json")

dna_rna_hash = json.load(config_json)

chromosomes = ["8", "X"]

refXX = "/data/Wilson_Lab/references/GENCODE/GRCh38.p12.genome.XXonly/GRCh38.p12.genome.XXonly.fa"

output_directory_dna = ""

calc_allele_balance_script = 