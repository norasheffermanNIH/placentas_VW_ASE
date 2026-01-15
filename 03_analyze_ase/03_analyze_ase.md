## 03_analyze_ase
**Goal**: Calculate allele balance at variant sites for each quadrant of each placenta

**Directory**:
`/data/Wilson_Lab/projects/placentas_VW_ASE/03_analyze_ase`

**Scripts**:
- `calc_allele_balance.py` - Calculates allele balance
- `analyze_ase_script.py` - Builds commands that calculate the allele balance for all quadrant samples and writes them to a SLURM submission script
    * The script filters out variants with a total coverage less than 10, can be changed to more or less
- `run_analyze_ase_script.py` - Runs job submissions from `analyze_ase_script.py `

**Steps**:

1. Confirm that the correct config file, calculate allele balance file, and all inputs are present in `analyze_ase_script.py`. 
2. Generate the SLURM job script. 
```
python analyze_ase_script.py > run_analyze_ase_script.sh
```
3. Submit jobs.
```
sbatch run_analyze_ase_script.sh
```

**Output**:
`/data/Wilson_Lab/projects/placentas_VW_ASE/03_analyze_ase/allele_balance_tables`

This directory contains tables calculating the allele balance  at specific variant sites for each quadrant of each placenta on chrX and chr8.
