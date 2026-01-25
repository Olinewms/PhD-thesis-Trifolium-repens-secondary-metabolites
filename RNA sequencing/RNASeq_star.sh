#!/usr/bin/env bash

#SBATCH --job-name=STAR
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=200GB
#SBATCH --cpus-per-task=64
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=48:00:00

## Purge pre-existing modules
module purge

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail
source ~/.bashrc
mamba activate /home/newol210/macknight_oliver/mamba_envs/star

### Index the reference genome
cd /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/reference_genomes/UTM_Trep_v1.0_hap1
STAR --runMode genomeGenerate --genomeDir star_genome_indexing/ --genomeFastaFiles ./star_genome_annotation/GCA_030914245.1_UTM_Trep_v1.0_hap1_genomic.fna --sjdbGTFfile annotation/stringtie_UTM_Trep_v1_hap1_merged.gtf --genomeSAindexNbases 13 --runThreadN 64

### Map to the reference genome
cd /home/newol210/macknight_oliver/NoneVsHigh_RNASeq_2023/Illumina_downloads_2023/Processed_Fastq_by_fastp_2023_data

# STAR parameters
GENOME_DIR="/projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/reference_genomes/UTM_Trep_v1.0_hap1/star_genome_indexing/"
OUTPUT_DIR="/home/newol210/macknight_oliver/NoneVsHigh_RNASeq_2023/Illumina_downloads_2023/Processed_Fastq_by_fastp_2023_data/fastp_processedReads2023_data_mapped_to_UTM_hap1/"
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
done

mamba deactivate
