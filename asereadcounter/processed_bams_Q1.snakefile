import os

configfile: "valleywise_pilot_config.rdgroups.json" 

# Tool paths:
fastqc_path = "fastqc"
multiqc_path = "multiqc"
samtools_path = "samtools"
bamtools_path = "bamtools"
perllib_path = "perl"

#Directory to put all the results
output_directory = "/data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/"

rule all:
    input:
        expand(output_directory+"processed_bams/rna/{sample_name}_HISAT_pair_trim_sort_mkdup_rdgrp_XY.bam", sample_name = config["normotensive_male_samples"] + config["hypertensive_male_samples"]),
        expand(output_directory + "processed_bams/rna/{sample_name}_HISAT_pair_trim_sort_mkdup_rdgrp_XX.bam", sample_name = config["normotensive_female_samples"] + config["hypertensive_female_samples"]),
        expand(output_directory+"processed_bams/rna/{sample_name}_HISAT_pair_trim_sort_mkdup_rdgrp_XY.bam.bai", sample_name = config["normotensive_male_samples"] + config["hypertensive_male_samples"]),
        expand(output_directory+"processed_bams/rna/{sample_name}_HISAT_pair_trim_sort_mkdup_rdgrp_XX.bam.bai", sample_name = config["normotensive_female_samples"] + config["hypertensive_female_samples"])

rule HISAT_paired_males:
    input:
        Trimmed_FASTQ1 = output_directory+"trimmed_fastqs_rna/{sample_name}_trimmed_R1.fastq.gz",
        Trimmed_FASTQ2 = output_directory+"trimmed_fastqs_rna/{sample_name}_trimmed_R2.fastq.gz"
    output:
        out_1 = output_directory+"processed_bams/rna/{sample_name}_HISAT_pair_trim_XY.sam"
    params:
        HISAT_Index_male = config["HG38_Transcriptome_Index_HISAT_Path_male"],
    shell:
        "hisat2 -q --rna-strandness RF -p 8 -x {params.HISAT_Index_male} -1 {input.Trimmed_FASTQ1} -2 {input.Trimmed_FASTQ2} -S {output.out_1}"
       

rule HISAT_paired_females:
    input:
        Trimmed_FASTQ1 = output_directory+"trimmed_fastqs_rna/{sample_name}_trimmed_R1.fastq.gz",
        Trimmed_FASTQ2 = output_directory+"trimmed_fastqs_rna/{sample_name}_trimmed_R2.fastq.gz"
    output:
        out_1 = output_directory+"processed_bams/rna/{sample_name}_HISAT_pair_trim_XX.sam"
    params:
        HISAT_Index_female = config["HG38_Transcriptome_Index_HISAT_Path_female"],
    shell:
        "hisat2 -q --rna-strandness RF -p 8 -x {params.HISAT_Index_female} -1 {input.Trimmed_FASTQ1} -2 {input.Trimmed_FASTQ2} -S {output.out_1}"


#males
rule samtools_view_males:
    input:
        SAM = output_directory+"processed_bams/rna/{sample_name}_HISAT_pair_trim_XY.sam"
    output:
        BAM = output_directory+"processed_bams/rna/{sample_name}_HISAT_pair_trim_XY.bam"
    shell:
        "samtools view -b {input.SAM} > {output.BAM}"

rule bam_sort_males:
    input:
        IN_BAM = output_directory+"processed_bams/rna/{sample_name}_HISAT_pair_trim_XY.bam"
    output:
        sort_BAM = output_directory+"processed_bams/rna/{sample_name}_HISAT_pair_trim_sort_XY.bam"
    shell:
        "bamtools sort -in {input.IN_BAM} -out {output.sort_BAM}"

rule AddReadGrps_males:
    input:
        Read_BAM = output_directory+"processed_bams/rna/{sample_name}_HISAT_pair_trim_sort_XY.bam"
    output:
        BAM = output_directory+"processed_bams/rna/{sample_name}_HISAT_pair_trim_sort_rdgrp_XY.bam"
    params:
        id = lambda wildcards: config[wildcards.sample_name]["ID"],
        sm = lambda wildcards: config[wildcards.sample_name]["SM"],
        lb = lambda wildcards: config[wildcards.sample_name]["LB"],
        pu = lambda wildcards: config[wildcards.sample_name]["PU"],
        pl = lambda wildcards: config[wildcards.sample_name]["PL"],
    shell:
        "java -Xmx14g -jar /usr/local/apps/picard/3.3.0/picard.jar AddOrReplaceReadGroups I={input.Read_BAM} O={output.BAM} "
        "RGID={params.id} RGPU={params.pu} RGSM={params.sm} RGPL={params.pl} RGLB={params.lb} VALIDATION_STRINGENCY=LENIENT"

rule MarkDups_males:
    input:
        sort_BAM = output_directory+"processed_bams/rna/{sample_name}_HISAT_pair_trim_sort_rdgrp_XY.bam"
    output:
        BAM = output_directory+"processed_bams/rna/{sample_name}_HISAT_pair_trim_sort_mkdup_rdgrp_XY.bam",
        metrics = output_directory+"processed_bams/rna/stats/{sample_name}.XY.picard_mkdup_metrics.txt"
    shell:
        r"""
        module load picard
        mkdir -p /data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/processed_bams/rna/stats
        java -Xmx14g -jar /usr/local/apps/picard/3.3.0/picard.jar MarkDuplicates \
        I={input.sort_BAM} \
        O={output.BAM} \
        M={output.metrics} \
        VALIDATION_STRINGENCY=LENIENT
        """ 

rule index_bam_males:
    input:
        BAM = output_directory+"processed_bams/rna/{sample_name}_HISAT_pair_trim_sort_mkdup_rdgrp_XY.bam"
    output:
        BAI = output_directory+"processed_bams/rna/{sample_name}_HISAT_pair_trim_sort_mkdup_rdgrp_XY.bam.bai"
    params:
        bamtools = bamtools_path
    shell:
        "{params.bamtools} index -in {input.BAM}"


#females
rule samtools_view_females:
    input:
        SAM = output_directory+"processed_bams/rna/{sample_name}_HISAT_pair_trim_XX.sam"
    output:
        BAM = output_directory+"processed_bams/rna/{sample_name}_HISAT_pair_trim_XX.bam"
    shell:
        "samtools view -b {input.SAM} > {output.BAM}"

rule bam_sort_females:
    input:
        IN_BAM = output_directory+"processed_bams/rna/{sample_name}_HISAT_pair_trim_XX.bam"
    output:
        sort_BAM = output_directory+"processed_bams/rna/{sample_name}_HISAT_pair_trim_sort_XX.bam"
    shell:
        "bamtools sort -in {input.IN_BAM} -out {output.sort_BAM}"

rule AddReadGrps_females:
    input:
        Read_BAM = output_directory+"processed_bams/rna/{sample_name}_HISAT_pair_trim_sort_XX.bam"
    output:
        BAM = output_directory+"processed_bams/rna/{sample_name}_HISAT_pair_trim_sort_rdgrp_XX.bam"
    params:
        id = lambda wildcards: config[wildcards.sample_name]["ID"],
        sm = lambda wildcards: config[wildcards.sample_name]["SM"],
        lb = lambda wildcards: config[wildcards.sample_name]["LB"],
        pu = lambda wildcards: config[wildcards.sample_name]["PU"],
        pl = lambda wildcards: config[wildcards.sample_name]["PL"],
    shell:
        "java -Xmx14g -jar /usr/local/apps/picard/3.3.0/picard.jar AddOrReplaceReadGroups I={input.Read_BAM} O={output.BAM} "
        "RGID={params.id} RGPU={params.pu} RGSM={params.sm} RGPL={params.pl} RGLB={params.lb} VALIDATION_STRINGENCY=LENIENT"

rule MarkDups_females:
    input:
        sort_BAM = output_directory+"processed_bams/rna/{sample_name}_HISAT_pair_trim_sort_rdgrp_XX.bam"
    output:
        BAM = output_directory+"processed_bams/rna/{sample_name}_HISAT_pair_trim_sort_mkdup_rdgrp_XX.bam",
        metrics = output_directory+"processed_bams/rna/stats/{sample_name}.XX.picard_mkdup_metrics.txt"
    shell:
        r"""
        module load picard
        mkdir -p /data/Wilson_Lab/projects/placenta_multiomics/valleywise_pilot/processed_bams/rna/stats
        java -Xmx14g -jar /usr/local/apps/picard/3.3.0/picard.jar MarkDuplicates \
        I={input.sort_BAM} \
        O={output.BAM} \
        M={output.metrics} \
        VALIDATION_STRINGENCY=LENIENT
        """ 

rule index_bam_females:
    input:
        BAM = output_directory+"processed_bams/rna/{sample_name}_HISAT_pair_trim_sort_mkdup_rdgrp_XX.bam"
    output:
        BAI = output_directory+"processed_bams/rna/{sample_name}_HISAT_pair_trim_sort_mkdup_rdgrp_XX.bam.bai"
    params:
        bamtools = bamtools_path
    shell:
        "{params.bamtools} index -in {input.BAM}"