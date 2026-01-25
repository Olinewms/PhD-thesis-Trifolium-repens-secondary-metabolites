# This script uses the amino-acid sequences for each predicted transcript found by BRAKER3 (braker_asterisks_removed.aa), with asterisks denoting stop codons removed, to find functional annotations. 

#!/usr/bin/env bash
#SBATCH --job-name=eggnog
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=64
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=24:00:00

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail

#!/bin/bash
source ~/.bashrc
mamba activate /home/newol210/macknight_oliver/mamba_envs/eggnog

cd /home/newol210/macknight_oliver/eggnog_mapper_working_dir
emapper.py --cpu 64 --sensmode more-sensitive -i ~/macknight_oliver/braker_working_dir/braker/braker_asterisks_removed.aa -o braker_asterisks_removed_aa_eggnog

mamba deactivate
