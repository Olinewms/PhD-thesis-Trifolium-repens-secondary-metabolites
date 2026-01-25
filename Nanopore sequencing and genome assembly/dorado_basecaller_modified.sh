# This script is for multi-sample basecalling using dorado basecalling models. 

#!/usr/bin/env bash
#SBATCH --job-name=dorado_basecall
#SBATCH --account=newol210
#SBATCH --partition=aoraki_gpu_A100_80GB
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1
#SBATCH --mem-per-gpu=80GB
#SBATCH --cpus-per-task=32
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=72:00:00

## Purge pre-existing modules
module purge

## Load the CUDA module (ensure you load a specific version)
module load cuda/11.8

# Check CUDA devices assigned by SLURM
echo "CUDA_VISIBLE_DEVICES: $CUDA_VISIBLE_DEVICES"

## Run nvidia-smi to check GPU status
nvidia-smi

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail

# Set the output directory
cd /projects/health_sciences/bms/biochemistry/macknight_lab/pod5_oliver_clover_all
OUT_DIR=$(echo "$(pwd)/dorado_basecalling_oli_all")
mkdir -p $OUT_DIR

# Set the necessary files and configs
# DORADO_MODEL=$(echo "$HOME/whichever_basecall_model_you_choose")
POD5_DIRS=("./oli_repens_dorado_basecalling_160924/Green_pod5_2023" "./oli_repens_dorado_basecalling_160924/Rf_pod5_2024_barcoded" "./oli_repens_dorado_basecalling_160924/Rf_Rm_Rld_pod5_2024_barcoded_multiplexed" "./oli_repens_dorado_basecalling_160924/Rld_pod5_2024_barcoded" "./oli_repens_dorado_basecalling_160924/Rl_pod5_2023" "./oli_repens_dorado_basecalling_160924/Rm_pod5_2024_barcoded")
BAM_FILES=("basecalls_Green_pod5_2023.bam" "basecalls_Rf_pod5_2024_barcoded.bam" "basecalls_Rf_Rm_Rld_pod5_2024_barcoded_multiplexed.bam" "basecalls_Rld_pod5_2024_barcoded.bam" "basecalls_Rl_pod5_2023.bam" "basecalls_Rm_pod5_2024_barcoded.bam")

# Commands specific to each directory
KIT_NAMES=("SQK-LSK114" "SQK-NBD114-96" "SQK-NBD114-96" "SQK-NBD114-96" "SQK-LSK110" "SQK-NBD114-96")

# Loop over each pod5 directory
for i in {0..5}; do
    if [ $i -eq 2 ]; then
        # Special command for directory 3 with demultiplexing
        echo "Running basecalling and demultiplexing for directory: ${POD5_DIRS[$i]}"
        ../dorado-0.8.0-linux-x64/bin/dorado basecaller sup,5mC_5hmC ${POD5_DIRS[$i]} --no-trim --models-directory ../dorado_models/ --kit-name ${KIT_NAMES[$i]} --barcode-both-ends --device cuda:0 > ${BAM_FILES[$i]}
        # Demultiplexing for the third directory
        ../dorado-0.8.0-linux-x64/bin/dorado demux --kit-name ${KIT_NAMES[$i]} --output-dir ${OUT_DIR} ${BAM_FILES[$i]}
    elif [ $i -eq 1 ]; then
        echo "Running basecalling and demultiplexing for directory: ${POD5_DIRS[$i]}"
        ../dorado-0.8.0-linux-x64/bin/dorado basecaller sup,5mC_5hmC ${POD5_DIRS[$i]} --models-directory ../dorado_models/ --kit-name ${KIT_NAMES[$i]} --device cuda:0 > ${BAM_FILES[$i]}
    elif [ $i -eq 3 ]; then
        echo "Running basecalling and demultiplexing for directory: ${POD5_DIRS[$i]}"
        ../dorado-0.8.0-linux-x64/bin/dorado basecaller sup,5mC_5hmC ${POD5_DIRS[$i]} --models-directory ../dorado_models/ --kit-name ${KIT_NAMES[$i]} --device cuda:0 > ${BAM_FILES[$i]}
    elif [ $i -eq 4 ]; then
        echo "Running basecalling and demultiplexing for directory: ${POD5_DIRS[$i]}"
        ../dorado-0.8.0-linux-x64/bin/dorado basecaller sup ${POD5_DIRS[$i]} --models-directory ../dorado_models/ --device cuda:0 > ${BAM_FILES[$i]}
    elif [ $i -eq 5 ]; then
        echo "Running basecalling and demultiplexing for directory: ${POD5_DIRS[$i]}"
        ../dorado-0.8.0-linux-x64/bin/dorado basecaller sup,5mC_5hmC ${POD5_DIRS[$i]} --models-directory ../dorado_models/ --kit-name ${KIT_NAMES[$i]} --device cuda:0 > ${BAM_FILES[$i]}
    else
        # Regular basecalling for other directories
        echo "Running basecalling for directory: ${POD5_DIRS[$i]}"
        ../dorado-0.8.0-linux-x64/bin/dorado basecaller sup,5mC_5hmC ${POD5_DIRS[$i]} --models-directory ../dorado_models/ --device cuda:0 > ${BAM_FILES[$i]}
    fi
done
