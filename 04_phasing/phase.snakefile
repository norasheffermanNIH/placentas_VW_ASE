configfile: "/data/Wilson_Lab/projects/placentas_VW_ASE/02_run_asereadcounter/correct_swapped_samples.json"

PLACENTAS = sorted(config["dna_rna_females"].keys())
QUADRANTS = ["Q1", "Q2", "Q3", "Q4"]
CHROMS = ["8", "X"]

rule all:
    input:
        expand(
            "/data/Wilson_Lab/projects/placentas_VW_ASE/04_phasing/phased_allele_balance/{placenta}_chr{chrom}_phased_allele_balance_summary.tsv",
            placenta = PLACENTAS, chrom = CHROMS),
        expand(
            "/data/Wilson_Lab/projects/placentas_VW_ASE/04_phasing/phased_allele_balance/{placenta}_chr{chrom}_phased_allele_balance_data.tsv",
            placenta = PLACENTAS, chrom = CHROMS)

rule phase:
    input:
        "/data/Wilson_Lab/projects/placentas_VW_ASE/04_phasing/paired_placentas_shared_variants/{placenta}_paired_placentas_shared_variants_chr{chrom}.csv"
    output:
        summary = "/data/Wilson_Lab/projects/placentas_VW_ASE/04_phasing/phased_allele_balance/{placenta}_chr{chrom}_phased_allele_balance_summary.tsv",
        phased_data = "/data/Wilson_Lab/projects/placentas_VW_ASE/04_phasing/phased_allele_balance/{placenta}_chr{chrom}_phased_allele_balance_data.tsv"  
    params:
        script = "/data/Wilson_Lab/projects/placentas_VW_ASE/04_phasing/phase.py",
        placenta = "{placenta}",
        chromosome = "{chrom}"
    shell:
        """
        python3 {params.script} --placenta_id {params.placenta} --chromosome chr{params.chromosome} --shared_variants {input} --out_summary {output.summary} --out_phased_data {output.phased_data}
        """