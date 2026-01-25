#!/usr/bin/env bash
#
# Job name
#SBATCH --job-name=porechop_dorado_basecalled_5_Trepens
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
# Memory per GPU
#SBATCH --mem=256GB
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
#SBATCH --time=72:00:00

# Commands go below

## Purge pre-existing modules
module purge

## Load the CUDA module (ensure you load a specific version)
# module load cuda/11.8

# Check CUDA devices assigned by SLURM
# echo "CUDA_VISIBLE_DEVICES: $CUDA_VISIBLE_DEVICES"

# Run dorado basecaller script
# /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/Porechop_dorado_fastqs.sh

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail

cd /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/Porechop/

porechop -i ../Porechop_input_files/basecalls_Green_pod5_2023.fastq.gz -o basecalls_Green_pod5_2023_porechopped.fastq.gz --threads 64
porechop -i ../Porechop_input_files/basecalls_Rl_pod5_2023.fastq.gz -o basecalls_Rl_pod5_2023_porechopped.fastq.gz --threads 64
porechop -i ../Porechop_input_files/Rf_whole_genome_seq_Margot_forde_SUP_5mC_5hmC_merged.fastq.gz -o Rf_whole_genome_seq_Margot_forde_SUP_5mC_5hmC_merged_porechopped.fastq.gz --threads 64
porechop -i ../Porechop_input_files/Rld_whole_genome_seq_SUP_5mC_5hmC_merged.fastq.gz -o Rld_whole_genome_seq_SUP_5mC_5hmC_merged.fastq_porechopped.fastq.gz --threads 64
porechop -i ../Porechop_input_files/Rm_whole_genome_seq_SUP_5mC_5hmC_merged.fastq.gz -o Rm_whole_genome_seq_SUP_5mC_5hmC_merged.fastq_porechopped.fastq.gz --threads 64

echo "Finished Porechopping all dorado Fastq files"