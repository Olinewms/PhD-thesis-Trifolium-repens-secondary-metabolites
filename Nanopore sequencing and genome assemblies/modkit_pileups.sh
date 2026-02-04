#!/usr/bin/env bash

#SBATCH --job-name=modkit
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=600GB
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

# Make a bedMethyl table for each sortec bam file
SAMPLES="Rf_mapped_to_RfFlyeAssembly_sorted Rld_mapped_to_RldFlyeAssembly_sorted Rm_mapped_to_RmFlyeAssembly_sorted"
for SAMPLE in $SAMPLES; do
    ../dist_modkit_v0.4.1_cec0a0b/modkit pileup ${SAMPLE}.bam --force-allow-implicit /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/modkit_pileups_doradoBAMS/${SAMPLE}_modkit_pileup.bed --log-filepath /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/modkit_pileups_doradoBAMS/pileup.log
done

echo "Finished"
