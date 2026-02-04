#!/usr/bin/env bash

#SBATCH --job-name=indexBeds
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=200GB
#SBATCH --cpus-per-task=128
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=78:00:00

# Purge pre-existing modules
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

