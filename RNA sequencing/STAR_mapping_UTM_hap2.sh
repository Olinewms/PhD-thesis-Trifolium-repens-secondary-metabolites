#!/usr/bin/env bash

#SBATCH --job-name=STAR_UTM_hap2
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=400GB
#SBATCH --cpus-per-task=64
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=48:00:00

# Purge pre-existing modules
module purge

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail
source ~/.bashrc
mamba activate /home/newol210/macknight_oliver/mamba_envs/star

### Index the reference genome
GENOME_DIR="/home/newol210/macknight_oliver/reference_genomes/UTM_Trep_v1.0_hap2/ncbi_dataset/data/GCA_030914255.1"

STAR --runThreadN 64 \
     --runMode genomeGenerate \
     --genomeDir ${GENOME_DIR} \
     --genomeFastaFiles ${GENOME_DIR}/UTM_Trep_v1.0_hap2_cleaned_headers.fna \
     --genomeSAindexNbases 13
    
### Map to the indexed reference genome
cd /home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/all_R1_and_R2_fastqs

# STAR parameters
OUTPUT_DIR="/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap2"
THREADS=64
MAX_MULTIMAP=10

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"
ulimit -n 65536

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
    
    # Remove TMP dir
    rm -r "${OUTPUT_DIR}${SAMPLE_NAME}_STARtmp"
    
    # Remove splice junction files
    rm "${OUTPUT_DIR}${SAMPLE_NAME}_SJ.out.tab"
done

mamba deactivate
