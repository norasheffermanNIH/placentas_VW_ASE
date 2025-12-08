# In this script, we want to calculate median allele balance across all variants for each individual placenta
# Input file is "/data/Wilson_Lab/projects/placentas_VW_ASE/03_analyze_ase/allele_balance_tables/{quadrant}/chr{chr}/{sample_id}_chr{chr}_allele_balance.tsv"
# Each file is the output of calc_allele_balance.py with columns: ['chr', 'position', 'ref_allele', 'alt_allele', 'ref_count', 'alt_count', 'total_count', 'allele_balance']

import os
import pandas as pd
import argparse
import json

parser = argparse.ArgumentParser(description='Calculate median allele balance for placenta samples.')
parser.add_argument('--chromosome',required=True,help='Input the chromosome number')
parser.add_argument('--files_dir',required=True,help='Input the path to the directory where the tsv file of the allele balance is')
parser.add_argument('--threshold',required=True,help='Input the threshold to subset the total count with')
parser.add_argument('--include_pars',required=True,help='Yes if PARs are included in the calculation. No otherwise.')
parser.add_argument('--out_placenta',required=True,help='Input the path to the output tsv with median allele balance per placenta')

args = parser.parse_args()

chromosome = args.chromosome
files_dir = args.files_dir
threshold = float(args.threshold)
include_pars = args.include_pars
out_placenta = args.out_placenta

quadrant = os.path.basename(os.path.dirname(files_dir))

# Remove pars
def remove_pars(df):
    mask_par1 = (df["position"] >= 10001) & (df["position"] <= 2781479)
    mask_par2 = (df["position"] >= 155701383) & (df["position"] <= 156030895)
    return df[~(mask_par1 | mask_par2)]

rows = []

for fname in os.listdir(files_dir):
    if not fname.endswith(".tsv"):
        continue

    filepath = os.path.join(files_dir, fname)

    # sample_id = everything before "_chr"
    sample_id = fname.split("_chr")[0]

    df = pd.read_csv(filepath, sep="\t")

    # ensure required columns exist
    required_cols = {"position", "total_count", "allele_balance"}
    if not required_cols.issubset(df.columns):
        raise ValueError(f"File {filepath} is missing required columns: {required_cols}")

    # filter on coverage
    df = df[df["total_count"] >= threshold]

    # optional: remove PARs for chrX
    if chromosome.upper() == "X" and include_pars == "No":
        df = remove_pars(df)

    if df.empty:
        median_ab = float("nan")
    else:
        median_ab = df["allele_balance"].median()

    rows.append({"placenta": sample_id, "chromosome": chromosome, "median_allele_balance": median_ab, "quadrant": quadrant})

# convert to DataFrame and append to output
out_df = pd.DataFrame(rows).sort_values(["placenta", "quadrant"])
out_df.to_csv(out_placenta, sep="\t", index=False, mode="a", header=not os.path.exists(out_placenta))