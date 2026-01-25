#!/usr/bin/env bash
#
# Job name
#SBATCH --job-name=Porechop_and_Flye_Rf_revised
#
# Account name
#SBATCH --account=newol210
#
# Partition
#SBATCH --partition=aoraki_gpu_A100_80GB
#
# Number of tasks per partition
#SBATCH --ntasks-per-node=1
#
# Number of GPUs 
#SBATCH --gres=gpu:1
#
# Memory per GPU
#SBATCH --mem-per-gpu=500GB
#
# Number of CPUs (e.g 16 cores)
#SBATCH --cpus-per-task=32
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
module load cuda/11.8

# Check CUDA devices assigned by SLURM
echo "CUDA_VISIBLE_DEVICES: $CUDA_VISIBLE_DEVICES"

## Run nvidia-smi to check GPU status
#nvidia-smi

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail

source ~/.bashrc

#conda activate samtools

cd /home/newol210/macknight_oliver/pod5_oliver_clover_all/bams_Rf_revised_merging

#samtools sort 51f911009153859b6e247aa09e95aa42bfe0e085_SQK-NBD114-96_barcode16.bam > 51f911009153859b6e247aa09e95aa42bfe0e085_SQK-NBD114-96_barcode16_sorted.bam
#samtools sort 51f911009153859b6e247aa09e95aa42bfe0e085_SQK-NBD114-96_barcode39.bam > 51f911009153859b6e247aa09e95aa42bfe0e085_SQK-NBD114-96_barcode39_sorted.bam
#samtools sort basecalls_Rf_pod5_2024_barcoded_revised.bam > basecalls_Rf_pod5_2024_barcoded_revised_sorted.bam

#samtools merge Rf_revised_merged.bam 51f911009153859b6e247aa09e95aa42bfe0e085_SQK-NBD114-96_barcode16_sorted.bam 51f911009153859b6e247aa09e95aa42bfe0e085_SQK-NBD114-96_barcode39_sorted.bam basecalls_Rf_pod5_2024_barcoded_revised_sorted.bam
#samtools fastq Rf_revised_merged.bam > Rf_revised_merged.fastq 

#conda deactivate

#porechop -i Rf_revised_merged.fastq -o Rf_revised_merged_porechopped.fastq.gz --threads 64

~/miniconda3/bin/flye --nano-hq Rf_revised_merged_porechopped.fastq.gz -o ./flye_output_Rf_revised/Rf_revised_dorado_porechopped_assembly -g 1g -t 64 -i 4 --keep-haplotypes
echo "Finished Rf revised assembly"
