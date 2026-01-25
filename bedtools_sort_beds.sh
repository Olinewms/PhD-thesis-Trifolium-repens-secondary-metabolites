#!/usr/bin/env bash
#
# Job name
#SBATCH --job-name=bedtools_sort_beds
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
#SBATCH --mem=1TB
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