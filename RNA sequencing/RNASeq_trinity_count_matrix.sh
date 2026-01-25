#!/usr/bin/env bash
#
# Job name
#SBATCH --job-name=trinity_IsoformCount_matrix
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
#SBATCH --mem-per-gpu=80GB
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
#SBATCH --time=48:00:00

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

source ~/.bashrc
conda activate trinity

cd /home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/all_R1_and_R2_fastqs/

# Define the base directory containing all subdirectories
BASE_DIR="/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/all_R1_and_R2_fastqs/"

# Find all RSEM.genes.results files in the subdirectories and join them with a space
ISOFORMS_RESULTS_FILES=$(find "$BASE_DIR" -type f -name "RSEM.isoforms.results" | tr '\n' ' ')

# Define the path to abundance_estimates_to_matrix.pl
ABUNDANCE_SCRIPT="/home/newol210/miniconda3/envs/trinity/bin/abundance_estimates_to_matrix.pl"

# Define the gene-transcript map
GENE_TRANS_MAP="/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/all_R1_and_R2_fastqs/samples_for_trinity_assembly/trinity_de_novo_8_samples/Trinity.fasta.gene_trans_map"

# Run the command
$ABUNDANCE_SCRIPT --est_method RSEM --gene_trans_map $GENE_TRANS_MAP --name_sample_by_basedir $ISOFORMS_RESULTS_FILES

conda deactivate
