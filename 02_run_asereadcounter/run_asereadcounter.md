## 02_run_asereadcounter
**Goal**: Count allele-specific reads at variant sites for each quadrant of each placenta

**Directory**:
`/data/Wilson_Lab/projects/placentas_VW_ASE/02_run_asereadcounter`

**Scripts**:
- `asereadcounter_script.py` - Build ASEReadCounter commands for all quadrant samples and writes them to a SLURM submission script
- `run_asereadcounter_script.py` - Runs job submissions from `asereadcounter_script.py `

**Files**:
- `correct_swapped_samples.json` - Config file that outlines paths for RNA BAMs and DNA VCFs

**Steps**:

1. Confirm that the correct config file and all inputs are present in `asereadcounter_script.py`. 
2. Generate the SLURM job script. 
```
python asereadcounterscript.py > run_asereadcounter_script.sh
```
3. Submit jobs.
```
sbatch run_asereadcounter_script.sh
```

**Output**:
`/data/Wilson_Lab/projects/placentas_VW_ASE/02_run_asereadcounter/HISAT`

This directory contains tables of reference and alternate allele counts at specific variant sites for each quadrant of each placenta on chrX and chr8.