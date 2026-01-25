#!/usr/bin/env bash
#
# Job name
#SBATCH --job-name=Fastp
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
#SBATCH --mem=200GB
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
#SBATCH --time=10:00:00

# Commands go below

## Purge pre-existing modules
module purge

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail

cd /home/newol210/macknight_oliver/NoneVsHigh_RNASeq_2023/Illumina_downloads_2023

source ~/.bashrc
mamba activate /home/newol210/macknight_oliver/mamba_envs/fastp/

# Directory containing the fastq files
INPUT_DIR="/home/newol210/macknight_oliver/NoneVsHigh_RNASeq_2023/Illumina_downloads_2023/OG7931-641472834_sample_fastqs/All_sample_fastqs_raw"

# Output directory for processed files
OUTPUT_DIR="Processed_Fastq_by_fastp_2023_data"
mkdir -p "$OUTPUT_DIR"

# Loop through all R1 fastq files
for R1_FILE in "$INPUT_DIR"/*_R1_001.fastq; do
    # Derive the base sample name (e.g., "c2_S58")
    BASE_NAME=$(basename "$R1_FILE" | sed 's/_R1_001.fastq//')

    # Construct the corresponding R2 file
    R2_FILE="$INPUT_DIR/${BASE_NAME}_R2_001.fastq"

    # Output files
    OUTPUT_R1="$OUTPUT_DIR/${BASE_NAME}_R1_fastp.fastq.gz"
    OUTPUT_R2="$OUTPUT_DIR/${BASE_NAME}_R2_fastp.fastq.gz"
    OUTPUT_MERGED="$OUTPUT_DIR/${BASE_NAME}_mergedPaired_fastp.fastq.gz"
    OUTPUT_UNPAIRED1="$OUTPUT_DIR/${BASE_NAME}_R1_unpaired_fastp.fastq.gz"
    OUTPUT_UNPAIRED2="$OUTPUT_DIR/${BASE_NAME}_R2_unpaired_fastp.fastq.gz"

    # Run fastp
    fastp \
        -i "$R1_FILE" \
        -I "$R2_FILE" \
        -o "$OUTPUT_R1" \
        -O "$OUTPUT_R2" \
        --detect_adapter_for_pe \
        -g -L -Q \
        --unpaired1 "$OUTPUT_UNPAIRED1" \
        --unpaired2 "$OUTPUT_UNPAIRED2"

    echo "Processed $BASE_NAME"
done

echo "All samples have been processed."

conda deactivate