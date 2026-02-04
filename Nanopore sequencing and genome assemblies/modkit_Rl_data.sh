#!/usr/bin/env bash

#SBATCH --job-name=modkit_Rl
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=200GB
#SBATCH --cpus-per-task=64
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --mail-user=newol210@student.otago.ac.nz
#SBATCH --mail-type=END,FAIL
#SBATCH --time=42:00:00

# Purge pre-existing modules
module purge

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail

cd /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/Rl_5mC_guppy_basecalling/guppy_basecalling/pass

source ~/.bashrc

# Concatenate all passed bams
samtools cat -o Rl_guppy_5mC_merged.bam ./*.bam

# Sort guppy basecalled merged bam file
samtools sort Rl_guppy_5mC_merged.bam > Rl_guppy_5mC_merged_sorted.bam

# Index the sorted basecalled merged bam file

# Use modkit on sorted bam
../../../dist_modkit_v0.4.1_cec0a0b/modkit pileup Rl_guppy_5mC_merged_sorted.bam --force-allow-implicit --filter-threshold 0.8 ./Rl_modkit_pileup_filterThresholdIncreased.bed --log-filepath ./pileup_Rl_filterThresholdIncreased.log

# Sort and index bed file
conda activate htslib

sort -k1,1 -k2,2n Rl_modkit_pileup_filterThresholdIncreased.bed | bgzip -c > Rl_modkit_pileup_filterThresholdIncreased_sorted.bed.gz && tabix -p bed Rl_modkit_pileup_filterThresholdIncreased_sorted.bed.gz

conda deactivate
