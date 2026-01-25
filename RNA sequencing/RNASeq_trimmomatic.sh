#!/usr/bin/env bash

#SBATCH --job-name=Trimming
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=500GB
#SBATCH --cpus-per-task=128
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=10:00:00

# Purge pre-existing modules
module purge

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail

cd /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/
source ~/.bashrc

###  Use Trimmomatic to trim reads

# Define input and output directories
INPUT_DIR="NoneVsMidVsHigh_RNASeq"
OUTPUT_DIR="/projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/NoneVsMidVsHigh_RNASeq/TrimmedTrimmomatic_reads"
ADAPTERS_FILE="/projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/NoneVsMidVsHigh_RNASeq/adapters.fa"
THREADS=128

# Create output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# Load Trimmomatic module if running on a cluster (comment out/uncomment as needed)
module load Trimmomatic

# Loop through the paired-end files
for R1 in ${INPUT_DIR}/*_R1_001.fastq.gz; do
    # Derive R2 filename and sample name
    R2=${R1/_R1_/_R2_}
    SAMPLE=$(basename ${R1} _R1_001.fastq.gz)

    # Define output filenames
    OUT_R1_PAIRED="${OUTPUT_DIR}/${SAMPLE}_R1_paired.fastq.gz"
    OUT_R1_UNPAIRED="${OUTPUT_DIR}/${SAMPLE}_R1_unpaired.fastq.gz"
    OUT_R2_PAIRED="${OUTPUT_DIR}/${SAMPLE}_R2_paired.fastq.gz"
    OUT_R2_UNPAIRED="${OUTPUT_DIR}/${SAMPLE}_R2_unpaired.fastq.gz"

    # Run Trimmomatic for paired-end trimming
    java -jar ~/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads $THREADS \
        $R1 $R2 \
        $OUT_R1_PAIRED $OUT_R1_UNPAIRED \
        $OUT_R2_PAIRED $OUT_R2_UNPAIRED \
        ILLUMINACLIP:${ADAPTERS_FILE}:2:30:10 \
        LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
done

echo "Trimming completed. Output files are in $OUTPUT_DIR."
