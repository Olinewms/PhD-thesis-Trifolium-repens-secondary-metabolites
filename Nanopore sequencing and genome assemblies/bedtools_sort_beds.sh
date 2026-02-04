#!/usr/bin/env bash

#SBATCH --job-name=bedtools_sort_beds
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=1TB
#SBATCH --cpus-per-task=64
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=78:00:00

# Purge pre-existing modules
module purge

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail

cd /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/minimap2_output/

source ~/.bashrc
conda activate bedtools

SAMPLES="Rf_mapped_to_RfFlyeAssembly Rld_mapped_to_RldFlyeAssembly Rm_mapped_to_RmFlyeAssembly"
for SAMPLE in $SAMPLES; do
    bedtools sort -i ${SAMPLE}.bed > ${SAMPLE}_sorted.bed
done

conda deactivate
conda activate samtools

SAMPLES="Rf_mapped_to_RfFlyeAssembly_sorted Rld_mapped_to_RldFlyeAssembly_sorted Rm_mapped_to_RmFlyeAssembly_sorted"
for SAMPLE in $SAMPLES; do
    tabix ${SAMPLE}.bed
done

conda deactivate

echo "Finished"
