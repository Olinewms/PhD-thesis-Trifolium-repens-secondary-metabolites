#!/usr/bin/env bash
#SBATCH --job-name=STAR_separate_subgenomes
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=50GB
#SBATCH --cpus-per-task=64
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=40:00:00

## Purge pre-existing modules
module purge

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail
source ~/.bashrc
mamba activate /home/newol210/macknight_oliver/mamba_envs/star

### Map to the reference genome
# Repeat this twice: once for each subgenome

# STAR parameters 1
GENOME_DIR="/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1_separate_subgenomes/UTM_hap1_chr_set1_TrTo"
OUTPUT_DIR="/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1_separate_subgenomes/STAR_output_2025_RNA_TrTo_mapping"
THREADS=64
MAX_MULTIMAP=10

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"
ulimit -n 65536

cd /home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/all_R1_and_R2_fastqs/ 

# Loop through R1 paired files

for R1_FASTQ in *_R1_fastp.fastq.gz; do
    # Derive the sample base name by removing the R1 suffix
    SAMPLE_NAME=$(basename "$R1_FASTQ" "_R1_fastp.fastq.gz")

    # Define the R2 paired file
    R2_FASTQ="${SAMPLE_NAME}_R2_fastp.fastq.gz"

    # Unzip R1 and R2
    gunzip -c "$R1_FASTQ" > "${SAMPLE_NAME}_R1_fastp.fastq"
    gunzip -c "$R2_FASTQ" > "${SAMPLE_NAME}_R2_fastp.fastq"

    # Run STAR
    STAR --runMode alignReads \
        --genomeDir "$GENOME_DIR" \
        --outSAMtype BAM SortedByCoordinate \
        --readFilesIn "${SAMPLE_NAME}_R1_fastp.fastq" "${SAMPLE_NAME}_R2_fastp.fastq" \
        --runThreadN "$THREADS" \
        --outFileNamePrefix "${OUTPUT_DIR}${SAMPLE_NAME}_" \
        --outTmpDir "${OUTPUT_DIR}${SAMPLE_NAME}_STARtmp" \
        --outFilterMultimapNmax "$MAX_MULTIMAP"

    # Remove unzipped files
    rm "${SAMPLE_NAME}_R1_fastp.fastq"
    rm "${SAMPLE_NAME}_R2_fastp.fastq"
done

echo "Finished TrTo subgenome"

# STAR parameters 2
GENOME_DIR="/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1_separate_subgenomes/UTM_hap1_chr_set2_TrTp"
OUTPUT_DIR="/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1_separate_subgenomes/STAR_output_2025_RNA_TrTp_mapping"
THREADS=64
MAX_MULTIMAP=10

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"
ulimit -n 65536

cd /home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/all_R1_and_R2_fastqs/ 

# Loop through R1 paired files
for R1_FASTQ in *_R1_fastp.fastq.gz; do
    # Derive the sample base name by removing the R1 suffix
    SAMPLE_NAME=$(basename "$R1_FASTQ" "_R1_fastp.fastq.gz")

    # Define the R2 paired file
    R2_FASTQ="${SAMPLE_NAME}_R2_fastp.fastq.gz"

    # Unzip R1 and R2
    gunzip -c "$R1_FASTQ" > "${SAMPLE_NAME}_R1_fastp.fastq"
    gunzip -c "$R2_FASTQ" > "${SAMPLE_NAME}_R2_fastp.fastq"

    # Run STAR
    STAR --runMode alignReads \
        --genomeDir "$GENOME_DIR" \
        --outSAMtype BAM SortedByCoordinate \
        --readFilesIn "${SAMPLE_NAME}_R1_fastp.fastq" "${SAMPLE_NAME}_R2_fastp.fastq" \
        --runThreadN "$THREADS" \
        --outFileNamePrefix "${OUTPUT_DIR}${SAMPLE_NAME}_" \
        --outTmpDir "${OUTPUT_DIR}${SAMPLE_NAME}_STARtmp" \
        --outFilterMultimapNmax "$MAX_MULTIMAP"

    # Remove unzipped files
    rm "${SAMPLE_NAME}_R1_fastp.fastq"
    rm "${SAMPLE_NAME}_R2_fastp.fastq"
done

echo "Finished TrTp subgenome"
