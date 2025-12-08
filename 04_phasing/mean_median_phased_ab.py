import pandas as pd
import numpy as np
import os
import json

# Load config
with open("/data/Wilson_Lab/projects/placentas_VW_ASE/03_analyze_ase/analyze_ase_config.json") as config_json:
    config = json.load(config_json)

PLACENTAS = sorted(config["dna_rna_females"].keys())
CHROMS = ["8", "X"]

phased_dir = "/data/Wilson_Lab/projects/placentas_VW_ASE/04_phasing/phased_allele_balance/"

rows = []

for placenta in PLACENTAS:
    for chrom in CHROMS:
        filepath = os.path.join(
            phased_dir,
            f"{placenta}_chr{chrom}_phased_allele_balance_data.tsv"
        )
        df = pd.read_csv(filepath, sep="\t")

        # Columns for phased allele balance
        cols = [
            "phased_allele_balance_Q1",
            "phased_allele_balance_Q2",
            "phased_allele_balance_Q3",
            "phased_allele_balance_Q4",
        ]

        # Mean and median per quadrant
        means = df[cols].mean()
        medians = df[cols].median()

        rows.append({
            "placenta": placenta,
            "chromosome": chrom,
            "mean_Q1": means["phased_allele_balance_Q1"],
            "median_Q1": medians["phased_allele_balance_Q1"],
            "mean_Q2": means["phased_allele_balance_Q2"],
            "median_Q2": medians["phased_allele_balance_Q2"],
            "mean_Q3": means["phased_allele_balance_Q3"],
            "median_Q3": medians["phased_allele_balance_Q3"],
            "mean_Q4": means["phased_allele_balance_Q4"],
            "median_Q4": medians["phased_allele_balance_Q4"],
        })
        
# Save summary table
summary_df = pd.DataFrame(rows)
summary_df.to_csv(
    "/data/Wilson_Lab/projects/placentas_VW_ASE/04_phasing/phased_AB_summary_all_placentas.tsv",
    sep="\t",
    index=False
)


