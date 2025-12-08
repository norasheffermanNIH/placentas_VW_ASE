#!/bin/bash
#SBATCH --mem=10G
#SBATCH -c 2
#SBATCH -t 02:00:00
#SBATCH -J plot_Qs
#SBATCH -o plot_Qs.out

module load R

Rscript make_unphased_allele_balance_plots.R Q1
Rscript make_unphased_allele_balance_plots.R Q2
Rscript make_unphased_allele_balance_plots.R Q3
Rscript make_unphased_allele_balance_plots.R Q4