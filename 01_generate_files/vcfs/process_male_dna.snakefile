import os

configfile: "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/valleywise_pilot_config.dna.rdgroups.json"

chr_current = ["8", "X"]
gatk_path = "module load GATK/4.6.0.0; gatk"
bcftools_path = "bcftools"

ruleorder: gatk_selectheterozygous > subset_individuals_vqsr

rule all:
    input:
        expand(
            "/data/Wilson_Lab/projects/placentas_VW_ASE/00_generate_files/vcfs/count_num_variants/"
            "chr{chr}.gatk.called.vqsr.sv.biallelic.snp.{sample}.het.num.variants.txt",
            chr=chr_current,
            sample=config["male_samples"])

rule gatk_combinegvcfs_chr8:
	input:
		ref = "/data/Wilson_Lab/references/GENCODE/GRCh38.p12.genome.XY/GRCh38.p12.genome.XY.fa",
		gvcfs = expand(
			"/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/gvcfs/{sample}/{sample}.GRCh38.p12.genome.XY.chr8.g.vcf.gz", sample=config["male_samples"])
	output:
		"/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/combined_gvcfs/GRCh38.p12.genome.XY.chr8.gatk.combinegvcf.g.vcf.gz"
	params:
		gatk = gatk_path,
		chr_n = "chr8"
	threads:
		4
	run:
		variant_files = []
		for i in input.gvcfs:
			variant_files.append("--variant " + i)
		variant_files = " ".join(variant_files)
		shell(
			"""{params.gatk} --java-options "-Xmx10g" """
			"""CombineGVCFs -R {input.ref} {variant_files} --intervals {params.chr_n} -O {output}""")

rule gatk_combinegvcfs_chrX:
	input:
		ref = "/data/Wilson_Lab/references/GENCODE/GRCh38.p12.genome.XY/GRCh38.p12.genome.XY.fa",
		gvcfs = expand(
			"/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/gvcfs/{sample}/{sample}.GRCh38.p12.genome.XY.chrX.g.vcf.gz", sample=config["male_samples"])
	output:
		"/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/combined_gvcfs/GRCh38.p12.genome.XY.chrX.gatk.combinegvcf.g.vcf.gz"
	params:
		gatk = gatk_path,
		chr_n = "chrX"
	threads:
		4
	run:
		variant_files = []
		for i in input.gvcfs:
			variant_files.append("--variant " + i)
		variant_files = " ".join(variant_files)
		shell(
			"""{params.gatk} --java-options "-Xmx10g" """
			"""CombineGVCFs -R {input.ref} {variant_files} --intervals {params.chr_n} -O {output}""")

rule gatk_genotypegvcf:
    input:
        ref = "/data/Wilson_Lab/references/GENCODE/GRCh38.p12.genome.XY/GRCh38.p12.genome.XY.fa",
        gvcf = "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/combined_gvcfs/GRCh38.p12.genome.XY.chr{chr}.gatk.combinegvcf.g.vcf.gz"
    output:
        "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/genotyped_vcfs/GRCh38.p12.genome.XY.chr{chr}.gatk.called.raw.vcf.gz"
    params:
        gatk = gatk_path
    threads:
        4
    shell:
        """{params.gatk} --java-options "-Xmx10g" """
        """GenotypeGVCFs -R {input.ref} -V {input.gvcf} -O {output}"""

# ----------------
# Filter with VQSR
# ----------------
# chr8

rule gatk_variantrecalibrator_chr8:
    input:
        ref = "/data/Wilson_Lab/references/GENCODE/GRCh38.p12.genome.XY/GRCh38.p12.genome.XY.fa",
        vcf = "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/genotyped_vcfs/GRCh38.p12.genome.XY.chr8.gatk.called.raw.vcf.gz",
        hapmap = "/data/Wilson_Lab/users/sheffermannm/gatk_resources/hapmap_3.3.hg38.vcf.gz",
        omni = "/data/Wilson_Lab/users/sheffermannm/gatk_resources/1000G_omni2.5.hg38.vcf.gz",
        thousandG = "/data/Wilson_Lab/users/sheffermannm/gatk_resources/1000G_phase1.snps.high_confidence.hg38.vcf.gz",
        dbsnp = "/data/Wilson_Lab/users/sheffermannm/gatk_resources/dbsnp_138.hg38.vcf.gz"
    output:
        recal = "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/vqsr/chr8_output_XY.recal",
        tranches = "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/vqsr/chr8_output_XY.tranches"
    params:
        gatk = gatk_path
    shell:
        """{params.gatk} --java-options "-Xmx16g" VariantRecalibrator """
        """-R {input.ref} -V {input.vcf}  """
        """--resource:hapmap,known=false,training=true,truth=true,prior=15.0 {input.hapmap} """
        """--resource:omni,known=false,training=true,truth=false,prior=12.0 {input.omni} """
        """--resource:1000G,known=false,training=true,truth=false,prior=10.0 {input.thousandG} """
        """--resource:dbsnp,known=true,training=false,truth=false,prior=2.0 {input.dbsnp} """
        """-an QD -an MQ -an MQRankSum -an ReadPosRankSum -an FS -an SOR """
        """-mode SNP """
        """--max-gaussians 4 """
        """-O {output.recal} """
        """--tranches-file {output.tranches} """

rule gatk_applyvqsr_chr8:
    input:
        ref = "/data/Wilson_Lab/references/GENCODE/GRCh38.p12.genome.XY/GRCh38.p12.genome.XY.fa",
        vcf = "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/genotyped_vcfs/GRCh38.p12.genome.XY.chr8.gatk.called.raw.vcf.gz",
        tranches = "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/vqsr/chr8_output_XY.tranches",
        recal = "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/vqsr/chr8_output_XY.recal"
    output:
        "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/vqsr/chr8.male.gatk.called.vqsr.vcf.gz"
    params:
        gatk = gatk_path
    shell:
        """{params.gatk} --java-options "-Xmx16g" ApplyVQSR """
        """-R {input.ref} """
        """-V {input.vcf} """
        """-O {output} """
        """--truth-sensitivity-filter-level 99.0 """
        """--tranches-file {input.tranches} """
        """--recal-file {input.recal} """
        """-mode SNP """

rule gatk_selectvariants_chr8:
    input:
        ref = "/data/Wilson_Lab/references/GENCODE/GRCh38.p12.genome.XY/GRCh38.p12.genome.XY.fa",
        vcf = "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/vqsr/chr8.male.gatk.called.vqsr.vcf.gz"
    output:
        "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/vqsr/chr8.male.gatk.called.vqsr.sv.vcf.gz"
    params:
        gatk = gatk_path
    shell:
        """{params.gatk} --java-options "-Xmx16g" SelectVariants """
        """-R {input.ref} """
        """-V {input.vcf} """
        """--exclude-filtered """
        """-O {output} """


# chrX
rule gatk_variantrecalibrator_chrX:
    input:
        ref = "/data/Wilson_Lab/references/GENCODE/GRCh38.p12.genome.XY/GRCh38.p12.genome.XY.fa",
        vcf = "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/genotyped_vcfs/GRCh38.p12.genome.XY.chrX.gatk.called.raw.vcf.gz",
        hapmap = "/data/Wilson_Lab/users/sheffermannm/gatk_resources/hapmap_3.3.hg38.vcf.gz",
        omni = "/data/Wilson_Lab/users/sheffermannm/gatk_resources/1000G_omni2.5.hg38.vcf.gz",
        thousandG = "/data/Wilson_Lab/users/sheffermannm/gatk_resources/1000G_phase1.snps.high_confidence.hg38.vcf.gz",
        dbsnp = "/data/Wilson_Lab/users/sheffermannm/gatk_resources/dbsnp_138.hg38.vcf.gz"
    output:
        recal = "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/vqsr/chrX_output_XY.recal",
        tranches = "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/vqsr/chrX_output_XY.tranches"
    params:
        gatk = gatk_path
    shell:
        """{params.gatk} --java-options "-Xmx16g" VariantRecalibrator """
        """-R {input.ref} -V {input.vcf}  """
        """--resource:hapmap,known=false,training=true,truth=true,prior=15.0 {input.hapmap} """
        """--resource:omni,known=false,training=true,truth=false,prior=12.0 {input.omni} """
        """--resource:1000G,known=false,training=true,truth=false,prior=10.0 {input.thousandG} """
        """--resource:dbsnp,known=true,training=false,truth=false,prior=2.0 {input.dbsnp} """
        """-an QD -an MQ -an MQRankSum -an ReadPosRankSum -an FS -an SOR """
        """--max-gaussians 4 """
        """-mode SNP """
        """-O {output.recal} """
        """--tranches-file {output.tranches} """

rule gatk_applyvqsr_chrX:
    input:
        ref = "/data/Wilson_Lab/references/GENCODE/GRCh38.p12.genome.XY/GRCh38.p12.genome.XY.fa",
        vcf = "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/genotyped_vcfs/GRCh38.p12.genome.XY.chrX.gatk.called.raw.vcf.gz",
        tranches = "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/vqsr/chrX_output_XY.tranches",
        recal = "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/vqsr/chrX_output_XY.recal"
    output:
        "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/vqsr/chrX.male.gatk.called.vqsr.vcf.gz"
    params:
        gatk = gatk_path
    shell:
        """{params.gatk} --java-options "-Xmx16g" ApplyVQSR """
        """-R {input.ref} """
        """-V {input.vcf} """
        """-O {output} """
        """--truth-sensitivity-filter-level 99.0 """
        """--tranches-file {input.tranches} """
        """--recal-file {input.recal} """
        """-mode SNP """

rule gatk_selectvariants_chrX:
    input:
        ref = "/data/Wilson_Lab/references/GENCODE/GRCh38.p12.genome.XY/GRCh38.p12.genome.XY.fa",
        vcf = "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/vqsr/chrX.male.gatk.called.vqsr.vcf.gz"
    output:
        "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/vqsr/chrX.male.gatk.called.vqsr.sv.vcf.gz"
    params:
        gatk = gatk_path
    shell:
        """{params.gatk} --java-options "-Xmx16g" SelectVariants """
        """-R {input.ref} """
        """-V {input.vcf} """
        """--exclude-filtered """
        """-O {output} """

#----------------------------------------
# Further processing VCF
# 1. Restrict to biallelic sites
# 2. Subset VCF files for each individual
# 3. Keep only the heterozygous sites
# Do this for chr8 and chrX
#----------------------------------------
rule gatk_selectbiallelic:
    input:
        ref = "/data/Wilson_Lab/references/GENCODE/GRCh38.p12.genome.XY/GRCh38.p12.genome.XY.fa",
        vcf = "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/vqsr/chr{chr}.male.gatk.called.vqsr.sv.vcf.gz"
    output:
        "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/vqsr/chr{chr}.male.gatk.called.vqsr.sv.biallelic.snp.vcf.gz"
    params:
        gatk = gatk_path
    shell:
        """{params.gatk} SelectVariants """
        """-R {input.ref} """
        """-V {input.vcf} """
        """-O {output} """
        """--select-type-to-include SNP """
        """--restrict-alleles-to BIALLELIC """

# PIPELINE ISSUE: Had to run these commands manually, for some reason "sample" gets turned to "sample.het"
#  likely something to do with the ruleorder
rule subset_individuals_vqsr:
     input:
         "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/vqsr/chr{chr}.male.gatk.called.vqsr.sv.biallelic.snp.vcf.gz"
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
        ref = "/data/Wilson_Lab/references/GENCODE/GRCh38.p12.genome.XY/GRCh38.p12.genome.XY.fa",
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
        """-select "AC == 1" """

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
