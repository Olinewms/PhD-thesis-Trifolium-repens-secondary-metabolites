#!/usr/bin/env bash
#
# Job name
#SBATCH --job-name=dorado_basecall_Rf_revised
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

# Set the output directory
cd /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/pod5_oliver_clover_all
OUT_DIR=$(echo "$(pwd)/dorado_basecalling_Rf_revised")
mkdir -p $OUT_DIR

# Set the necessary files and configs
POD5_DIRS=("./oli_repens_dorado_basecalling_160924_input_pod5/Rf_pod5_2024_barcoded" "./oli_repens_dorado_basecalling_160924_input_pod5/Rf_Rm_Rld_pod5_2024_barcoded_multiplexed")
BAM_FILES=("basecalls_Rf_pod5_2024_barcoded_revised.bam" "basecalls_Rf_Rm_Rld_pod5_2024_barcoded_multiplexed_revised.bam")

# Loop over each pod5 directory
for i in {0..1}; do
    if [ $i -eq 1 ]; then
        # Special command for directory 1 with demultiplexing
        echo "Running basecalling and demultiplexing for directory: ${POD5_DIRS[$i]}"
        ../../dorado-0.8.0-linux-x64/bin/dorado basecaller sup,5mC_5hmC ${POD5_DIRS[$i]} --no-trim --models-directory ../../dorado_models/ --kit-name SQK-NBD114-96 --barcode-both-ends --device cuda:0 > ${BAM_FILES[$i]}
        # Demultiplexing for the first directory
        ../../dorado-0.8.0-linux-x64/bin/dorado demux --kit-name SQK-NBD114-96 --output-dir ${OUT_DIR} ${BAM_FILES[$i]}
    else
        # Regular basecalling for other directories
        echo "Running basecalling for directory: ${POD5_DIRS[$i]}"
        ../../dorado-0.8.0-linux-x64/bin/dorado basecaller sup,5mC_5hmC ${POD5_DIRS[$i]} --models-directory ../../dorado_models/ --kit-name SQK-NBD114-96 --device cuda:0 > ${BAM_FILES[$i]}
    fi
done
