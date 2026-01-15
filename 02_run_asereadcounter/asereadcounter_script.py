import json
import itertools

#Load config
with open("/data/Wilson_Lab/projects/placentas_VW_ASE/02_run_asereadcounter/correct_swapped_samples.json") as config_json:
    config = json.load(config_json)

chromosomes = ["8", "X"]
quadrants = ["Q1", "Q2", "Q3", "Q4"]

gatk_path = "module load GATK/4.6.0.0; gatk"

refXX = "/data/Wilson_Lab/references/GENCODE/GRCh38.p12.genome.XXonly/GRCh38.p12.genome.XXonly.fa"

output_directory = "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/vqsr/"
final_output = "/data/Wilson_Lab/projects/placentas_VW_ASE/02_run_asereadcounter/"

# for all female samples

# iterate through the dna samples and matching rna samples
#    each with chromsomes 8 and X
#    each with quadrants Q1 to Q4
# issue a ASEReadCounter command
for placenta in config["dna_rna_females"]:
    for quadrant in quadrants:
        entry = config["dna_rna_females"][placenta][quadrant]
        rna_sample_id = entry["rna_sample"]
        vcf_id = entry["vcf"]
        bam_dir = entry["bam_dir"]
        for chrom in chromosomes:
            # VCF file
            sites = output_directory+"chr"+chrom+".gatk.called.vqsr.sv.biallelic.snp."+vcf_id+".het.vcf"

            # BAM file
            bam = bam_dir+rna_sample_id+"_HISAT_pair_trim_sort_mkdup_rdgrp_XX.bam"

            # Output file that combines vcf, bam, and chromosome
            outdir = final_output+"HISAT/"+quadrant+"/chr"+chrom+"/"
            print(f"mkdir -p {outdir}")
            outputfile = outdir+placenta+"_"+quadrant+"_chr"+chrom+"_females.tsv"
                
            # Compose command and use it to compose a bash script
            command = gatk_path + " ASEReadCounter -R " + refXX + " --output " + outputfile + " --input " + bam + " --variant " + sites + " --min-depth-of-non-filtered-base 1 --min-mapping-quality 10 --min-base-quality 10"
            print(f"sbatch --time=24:00:00 --mem=20G -n 2 --wrap=\"{command}\"")