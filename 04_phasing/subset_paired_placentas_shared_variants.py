# This script will subset paired placenta samples for shared variants. This means that only variants that are present in both samples of a pair will be retained.
import pandas as pd
import json
import sys
import os

chrom = sys.argv[1].strip()
chrom = chrom.replace("[","").replace("]","").replace("'","").replace('"',"")

totalCount_threshold = 10

# Where the allele balance tables are stored
base = "/data/Wilson_Lab/projects/placentas_VW_ASE/03_analyze_ase/allele_balance_tables/"

# Load config
with open("/data/Wilson_Lab/projects/placentas_VW_ASE/02_run_asereadcounter/correct_swapped_samples.json") as json_file:
    config = json.load(json_file)

placentas = sorted(config["dna_rna_females"].keys())
quadrants = ["Q1", "Q2", "Q3", "Q4"]

for placenta in placentas:
    # Build paths to Q1-Q4 allele balance files
    paths = {}
    for quad in quadrants:
        filename = f"{placenta}_{quad}_chr{chrom}_allele_balance.tsv"
        paths[quad] = os.path.join(base, quad, f"chr{chrom}", filename)
    
    # Read Q1-Q4
    q1 = pd.read_csv(paths["Q1"], sep="\t")
    q2 = pd.read_csv(paths["Q2"], sep="\t")
    q3 = pd.read_csv(paths["Q3"], sep="\t")
    q4 = pd.read_csv(paths["Q4"], sep="\t")

    # Keep only needed columns and rename
    q1 = q1[["chr", "position", "ref_count", "alt_count", "total_count"]].rename(
        columns={"ref_count": "ref_count_Q1", "alt_count": "alt_count_Q1", "total_count": "total_count_Q1"})
    q2 = q2[["chr", "position", "ref_count", "alt_count", "total_count"]].rename(
        columns={"ref_count": "ref_count_Q2", "alt_count": "alt_count_Q2", "total_count": "total_count_Q2"})
    q3 = q3[["chr", "position", "ref_count", "alt_count", "total_count"]].rename(
        columns={"ref_count": "ref_count_Q3", "alt_count": "alt_count_Q3", "total_count": "total_count_Q3"})
    q4 = q4[["chr", "position", "ref_count", "alt_count", "total_count"]].rename(
        columns={"ref_count": "ref_count_Q4", "alt_count": "alt_count_Q4", "total_count": "total_count_Q4"})

    # Find shared variants
    shared_variants = (
        q1.merge(q2, on=["chr", "position"], how="inner")
          .merge(q3, on=["chr", "position"], how="inner")
          .merge(q4, on=["chr", "position"], how="inner"))
    
    # Compute allele balance for each quadrant:
    for q in quadrants:
        shared_variants[f"allele_balance_{q}"] = (
            shared_variants[[f"ref_count_{q}", f"alt_count_{q}"]].max(axis=1)
            / shared_variants[f"total_count_{q}"])
        
    # Filter based on total count threshold. This removes variants if the total count is less than the threshold
    shared_variants_threshold = shared_variants[
        (shared_variants["total_count_Q1"] >= totalCount_threshold) &
        (shared_variants["total_count_Q2"] >= totalCount_threshold) &
        (shared_variants["total_count_Q3"] >= totalCount_threshold) &
        (shared_variants["total_count_Q4"] >= totalCount_threshold)]

    # Output path: one file per placenta and chromosome
    out_dir = "/data/Wilson_Lab/projects/placentas_VW_ASE/04_phasing/paired_placentas_shared_variants/"
    os.makedirs(out_dir, exist_ok=True)

    out_file = os.path.join(
        out_dir,
        f"{placenta}_paired_placentas_shared_variants_chr{chrom}.csv")

    shared_variants_threshold.to_csv(out_file, sep = "\t", index=False)
            
    # This prints out a summary table with: sample id, sample name, chromosome, total number of shared variants, number of shared variants with allele balance > 0.75 in quadrant 1, number of shared variants with allele balance > 0.75 in quadrant 2, number of shared variants with allele balance > 0.75 in quadrant 3, number of shared variants with allele balance > 0.75 in quadrant 4
    out = [
        placenta, f"chr{chrom}", str(shared_variants_threshold.shape[0]), 
        str(len(shared_variants_threshold[shared_variants_threshold["allele_balance_Q1"] > 0.8])),
        str(len(shared_variants_threshold[shared_variants_threshold["allele_balance_Q2"] > 0.8])),
        str(len(shared_variants_threshold[shared_variants_threshold["allele_balance_Q3"] > 0.8])),
        str(len(shared_variants_threshold[shared_variants_threshold["allele_balance_Q4"] > 0.8]))]
    print (','.join(out))