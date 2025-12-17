# ------
# README:
# before running this snakemake file, please edit line 15 to give the correct path to GATK.
# before running this snakemake file, please edit line 837 to give the correct path to the python script
# The script calc_num_site_in_vcf.py can be found at https://github.com/tanyaphung/vcfhelper
# ------
import os

configfile: "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/valleywise_pilot_config.dna.rdgroups.json"

chr_current = ["8", "X"]
gatk_path = "module load GATK/4.6.0.0; gatk"
bcftools_path = "bcftools"

ruleorder: gatk_selectheterozygous > subset_individuals_vqsr

rule all:
    input:
        expand("/data/Wilson_Lab/projects/placentas_VW_ASE/00_generate_files/vcfs/count_num_variants/"
        "chr{chr}.gatk.called.vqsr.sv.biallelic.snp.{sample}.het.num.variants.txt",
        chr=chr_current,
        sample=config["female_samples"]
    )

rule subset_individuals_vqsr:
     input:
         "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/vqsr/chr{chr}.gatk.called.vqsr.sv.biallelic.snp.vcf.gz"
     output:
         "/data/Wilson_Lab/projects/placentas_VW_ASE/00_generate_files/vcfs/vqsr/chr{chr}.gatk.called.vqsr.sv.biallelic.snp.{sample}.vcf"
     params:
         bcftools = bcftools_path,
         sample = "{sample}"
     shell:
         """{params.bcftools} view -s {params.sample} {input} > {output}"""

# After subsetting for each individual. In some individuals,
# the genotypes could be homozygous for the reference. This next rule is to remove these sites.
rule gatk_selectheterozygous:
    input:
        ref = "/data/Wilson_Lab/references/GENCODE/GRCh38.p12.genome.XXonly/GRCh38.p12.genome.XXonly.fa",
        vcf = "/data/Wilson_Lab/projects/placentas_VW_ASE/00_generate_files/vcfs/vqsr/chr{chr}.gatk.called.vqsr.sv.biallelic.snp.{sample}.vcf"
    output:
        "/data/Wilson_Lab/projects/placentas_VW_ASE/00_generate_files/vcfs/vqsr/chr{chr}.gatk.called.vqsr.sv.biallelic.snp.{sample}.het.vcf"
    params:
        gatk = gatk_path
    shell:
        """{params.gatk} SelectVariants """
        """-R {input.ref} """
        """-V {input.vcf} """
        """-O {output} """
        """-select 'AC == 1' """

# Tabulate number of heterozygous variants
rule count_number_of_heterozygous_variants:
    input:
        "/data/Wilson_Lab/projects/placentas_VW_ASE/00_generate_files/vcfs/vqsr/chr{chr}.gatk.called.vqsr.sv.biallelic.snp.{sample}.het.vcf"
    output:
        "/data/Wilson_Lab/projects/placentas_VW_ASE/00_generate_files/vcfs/count_num_variants/chr{chr}.gatk.called.vqsr.sv.biallelic.snp.{sample}.het.num.variants.txt"
    params:
        script = "/data/Wilson_Lab/projects/placentas_VW_ASE/00_generate_files/vcfs/calc_num_site_in_vcf.py",
        id = "chr{chr}"
    shell:
        """
        python {params.script} --vcf {input} --id {params.id} > {output}
        """
