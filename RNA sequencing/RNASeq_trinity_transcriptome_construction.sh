#!/usr/bin/env bash

#SBATCH --job-name=trinity_transcriptome_construction
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=500G
#SBATCH --cpus-per-task=128
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=160:00:00

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail
source ~/.bashrc

conda activate trinity

# Directory containing a subsample of the RNA-Seq fastq files
# This directory contained R1 and R2 fastq's for samples c2, c4, N1, N3, L1, L3, H1, and H2 (idealistically, it would contain all samples, but this takes an unrealistically large amount of time and memory)
FASTQ_DIR="/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/all_R1_and_R2_fastqs/samples_for_trinity_assembly"

# Output directory for Trinity
OUTPUT_DIR="/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/all_R1_and_R2_fastqs/samples_for_trinity_assembly/trinity_de_novo_8_samples"

# Collect all R1 and R2 fastq files
LEFT_FILES=$(ls ${FASTQ_DIR}/*_R1_*.fastq.gz | tr '\n' ',')
RIGHT_FILES=$(ls ${FASTQ_DIR}/*_R2_*.fastq.gz | tr '\n' ',')

# Remove trailing commas
LEFT_FILES=${LEFT_FILES%,}
RIGHT_FILES=${RIGHT_FILES%,}

# Trinity command (this script took ~4.5 days to complete)
TRINITY_CMD="Trinity --seqType fq --left ${LEFT_FILES} --right ${RIGHT_FILES} --output ${OUTPUT_DIR} --max_memory 500G --verbose"

# Print the command for confirmation
echo "Running Trinity with the following command:"
echo "${TRINITY_CMD}"

# Execute the command
eval ${TRINITY_CMD}

conda deactivate

