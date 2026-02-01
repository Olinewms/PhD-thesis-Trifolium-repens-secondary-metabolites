#!/usr/bin/env bash

#SBATCH --job-name=lastz
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-gpu=10GB
#SBATCH --cpus-per-task=32
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=1:00:00

# Purge pre-existing modules
module purge

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail

lastz ../Rl_dorado_porechopped_assembly/contig_6710.fasta[multiple] ./lastz_green/all_green_AGD5_contigs_and_purple_contig_6709.fasta[multiple] \
  --format=rdotplot > lastz_green/contig_alignment_to_Rl_contig_6710.rdotplot
