#!/usr/bin/env bash
#
# Job name
#SBATCH --job-name=indexBeds
#
# Account name
#SBATCH --account=newol210
#
# Partition
#SBATCH --partition=aoraki
#
# Ensure the allocation only goes on a single node
#SBATCH --nodes=1
#
# Number of tasks per partition
#SBATCH --ntasks-per-node=1
#
# Memory per GPU
#SBATCH --mem=200GB
#
# Number of CPUs (e.g 16 cores)
#SBATCH --cpus-per-task=128
#
# File to save stdout output
#SBATCH --output=slurm_%j.log
#
# File to save stderr (Error logfile)
#SBATCH --error=slurm_%j.err
#
# Email
#SBATCH --mail-user=newol210@student.otago.ac.nz
#SBATCH --mail-type=END,FAIL
#
# Time required to run job (hh:mm:ss)
#SBATCH --time=78:00:00

# Commands go below

## Purge pre-existing modules
module purge

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail

source ~/.bashrc

cd /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/modkit_pileups_doradoBAMS/

conda activate htslib

sort -k1,1 -k2,2n Rf_mapped_to_RfFlyeAssembly_sorted_modkit_pileup.bed | bgzip -c > Rf_mapped_to_RfFlyeAssembly_sorted_modkit_pileup_sorted.bed.gz && tabix -p bed Rf_mapped_to_RfFlyeAssembly_sorted_modkit_pileup_sorted.bed.gz
sort -k1,1 -k2,2n Rld_mapped_to_RldFlyeAssembly_sorted_modkit_pileup.bed | bgzip -c > Rld_mapped_to_RldFlyeAssembly_sorted_modkit_pileup_sorted.bed.gz && tabix -p bed Rld_mapped_to_RldFlyeAssembly_sorted_modkit_pileup_sorted.bed.gz
sort -k1,1 -k2,2n Rm_mapped_to_RmFlyeAssembly_sorted_modkit_pileup.bed | bgzip -c > Rm_mapped_to_RmFlyeAssembly_sorted_modkit_pileup_sorted.bed.gz && tabix -p bed Rm_mapped_to_RmFlyeAssembly_sorted_modkit_pileup_sorted.bed.gz

conda deactivate

echo "Finished"

