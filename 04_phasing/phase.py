# This script computes allele balance using the phased data
import random
import numpy as np
import pandas as pd
import argparse
import os

parser = argparse.ArgumentParser(description='Compute allele balance using the phased data.')
parser.add_argument('--placenta_id',required=True,help='Input the placenta id., e.g. Plac_CON02')
parser.add_argument('--chromosome',required=True,help='Input the chromosome, e.g. chr8 or chrX')
parser.add_argument('--shared_variants',required=True,help='Input the path to the shared variants file.')
parser.add_argument('--out_summary',required=True,help='Output TSV summarizing phased allele balance per placenta/chromosome')
parser.add_argument('--out_phased_data',required=True,help='Output TSV detailing the phased information')

args = parser.parse_args()

# Read data
df = pd.read_csv(args.shared_variants, sep='\t')

# Choose phasing quadrant
thresh = 0.8

biased_count = {
    "Q1": (df['allele_balance_Q1'] > thresh).sum(),
    "Q2": (df['allele_balance_Q2'] > thresh).sum(),
    "Q3": (df['allele_balance_Q3'] > thresh).sum(),
    "Q4": (df['allele_balance_Q4'] > thresh).sum()
}

phasing_quadrant = max(biased_count, key=biased_count.get)

# Determine haplotype per variant 
quadrants = ["Q1", "Q2", "Q3", "Q4"]
hap_allele = [] # 'ref' or 'alt' per variant
phased_AB = {q: [] for q in quadrants}

for _, row in df.iterrows():
    q = phasing_quadrant
    ref_col = f'ref_count_{q}'
    alt_col = f'alt_count_{q}'
    total_col = f'total_count_{q}'

    ref = row[ref_col]
    alt = row[alt_col]
    total = row[total_col]

    if total == 0:
        hap = "ref"
    else:
        ref_ratio = ref / total
        alt_ratio = alt / total

        if ref_ratio > thresh:
            hap = "ref"
        elif alt_ratio > thresh:
            hap = "alt"
        else:
            hap = random.choice(['ref', 'alt'])
    hap_allele.append(hap)

    # Compute phased allele balance for all quadrants
    for qi in quadrants:
        total_i = row[f'total_count_{qi}']
        if total_i == 0:
            phased_AB[qi].append(np.nan)
        else:
            if hap == "ref":
                phased_AB[qi].append(row[f'ref_count_{qi}'] / total_i)
            else:
                phased_AB[qi].append(row[f'alt_count_{qi}'] / total_i)
                
# Attach to dataframe
df["phasing_quadrant"] = phasing_quadrant
df["haplotype_allele"] = hap_allele
for qi in quadrants:
    df[f'phased_allele_balance_{qi}'] = phased_AB[qi]

# Write phased data per variant
out_phased_dir = os.path.dirname(args.out_phased_data)
if out_phased_dir and not os.path.exists(out_phased_dir):
    os.makedirs(out_phased_dir, exist_ok=True)

df.to_csv(args.out_phased_data, sep='\t', index=False)

# Summary row
summary = {
    "placenta_id": args.placenta_id,
    "chromosome": args.chromosome,
    "phasing_quadrant": phasing_quadrant,
    "n_shared_variants": int(len(df)),
    "n_biased_Q1": int(biased_count["Q1"]),
    "n_biased_Q2": int(biased_count["Q2"]),
    "n_biased_Q3": int(biased_count["Q3"]),
    "n_biased_Q4": int(biased_count["Q4"]),
    "median_phased_allele_balance_Q1": float(np.nanmedian(df["phased_allele_balance_Q1"])),
    "median_phased_allele_balance_Q2": float(np.nanmedian(df["phased_allele_balance_Q2"])),
    "median_phased_allele_balance_Q3": float(np.nanmedian(df["phased_allele_balance_Q3"])),
    "median_phased_allele_balance_Q4": float(np.nanmedian(df["phased_allele_balance_Q4"])),
}

summary_df = pd.DataFrame([summary])
                          
summary_dir = os.path.dirname(args.out_summary)
if summary_dir and not os.path.exists(summary_dir):
    os.makedirs(summary_dir, exist_ok=True)

header = not os.path.exists(args.out_summary)
summary_df.to_csv(args.out_summary, sep='\t', index=False, mode='a', header=header)