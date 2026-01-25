#!/usr/bin/env bash
#
# Job name
#SBATCH --job-name=eggnog
#
# Account name
#SBATCH --account=newol210
#
# Partition
#SBATCH --partition=aoraki
#
# Number of tasks per partition
#SBATCH --ntasks-per-node=1
#
# Number of CPUs (e.g 16 cores)
#SBATCH --cpus-per-task=64
#
# File to save stdout output
#SBATCH --output=slurm_%j.log
#
# File to save stderr (Error logfile)
#SBATCH --error=slurm_%j.err
#
# Time required to run job (hh:mm:ss)
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