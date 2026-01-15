# This script calculates the allele balance
import argparse

parser = argparse.ArgumentParser(description = 'Calculate allele balance (unphased)')
parser.add_argument('--input', required = True, help = 'Input the path to the output from asereadcounter')
parser.add_argument('--output', required = True, help = 'Inputh the path to the output file')

args = parser.parse_args()

# Header of the input file: contig	position	variantID	refAllele	altAllele	refCount	altCount	totalCount	lowMAPQDepth	lowBaseQDepth	rawDepth	otherBases	improperPairs
input = args.input

# Format of output file:
output = open(args.output, 'w')
header = ['chr', 'position', 'ref_allele', 'alt_allele', 'ref_count', 'alt_count', 'total_count', 'allele_balance']
print ('\t'.join(header), file = output)

with open(input, 'r') as f:
    for line in f:
        if line.startswith('contig'):
            continue
    
        items = line.rstrip('\n').split('\t')

        # Extract counts
        total = int(items[7])
        ref = float(items[5])
        alt = float(items[6])

        # Skip variants with total coverage < 10
        if total < 10:
            continue

        # Compute allele balance
        ref_ratio = ref / total
        alt_ratio = alt / total
        allele_balance = max(ref_ratio, alt_ratio)
        
        # Prepare output
        out = [
            items[0], #chr
            items[1], #position
            items[3], #ref_allele
            items[4], #alt_allele
            items[5], #ref_count
            items[6], #alt_count
            items[7], #total_count,
            f"{allele_balance:.4f}" #allele_balance
        ]

        print('\t'.join(out), file=output)
