#!/usr/bin/env bash

#SBATCH --job-name=porechop_dorado_basecalled_5_Trepens
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --ntasks-per-node=1
#SBATCH --mem=256GB
#SBATCH --cpus-per-task=64
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=72:00:00

# Purge pre-existing modules
module purge

# Load the CUDA module (ensure you load a specific version)
module load cuda/11.8

# Check CUDA devices assigned by SLURM
echo "CUDA_VISIBLE_DEVICES: $CUDA_VISIBLE_DEVICES"

# Run dorado basecaller script
/projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/Porechop_dorado_fastqs.sh

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail

cd /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/Porechop/

# Use these to trim reads using porechop
porechop -i ../Porechop_input_files/basecalls_Green_pod5_2023.fastq.gz -o basecalls_Green_pod5_2023_porechopped.fastq.gz --threads 64
porechop -i ../Porechop_input_files/basecalls_Rl_pod5_2023.fastq.gz -o basecalls_Rl_pod5_2023_porechopped.fastq.gz --threads 64
porechop -i ../Porechop_input_files/Rf_whole_genome_seq_Margot_forde_SUP_5mC_5hmC_merged.fastq.gz -o Rf_whole_genome_seq_Margot_forde_SUP_5mC_5hmC_merged_porechopped.fastq.gz --threads 64
porechop -i ../Porechop_input_files/Rld_whole_genome_seq_SUP_5mC_5hmC_merged.fastq.gz -o Rld_whole_genome_seq_SUP_5mC_5hmC_merged.fastq_porechopped.fastq.gz --threads 64
porechop -i ../Porechop_input_files/Rm_whole_genome_seq_SUP_5mC_5hmC_merged.fastq.gz -o Rm_whole_genome_seq_SUP_5mC_5hmC_merged.fastq_porechopped.fastq.gz --threads 64

echo "Finished trimming all dorado Fastq files"
