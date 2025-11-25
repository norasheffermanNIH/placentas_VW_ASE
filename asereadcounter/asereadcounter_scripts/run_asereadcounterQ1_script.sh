#!/bin/bash
#SBATCH --job-name=asereadcounter # Job name
#SBATCH -o slurm.%j.out                # STDOUT (%j = JobId)
#SBATCH -e slurm.%j.err                # STDERR (%j = JobId)

cd /data/Wilson_Lab/projects/placentas_VW_ASE/asereadcounter

