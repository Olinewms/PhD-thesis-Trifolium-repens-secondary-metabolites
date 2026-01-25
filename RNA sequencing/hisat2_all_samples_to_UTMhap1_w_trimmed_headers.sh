#!/usr/bin/env bash

#SBATCH --job-name=Hisat2_all_samples
#SBATCH --account=newol210
#SBATCH --partition=aoraki_gpu_A100_40GB
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1
#SBATCH --mem-per-gpu=40GB
#SBATCH --cpus-per-task=32
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=92:00:00

# Purge pre-existing modules
module purge

# Load the CUDA module (ensure you load a specific version)
module load cuda/11.8

# Check CUDA devices assigned by SLURM
echo "CUDA_VISIBLE_DEVICES: $CUDA_VISIBLE_DEVICES"

# Run nvidia-smi to check GPU status
nvidia-smi

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail

cd /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/all_R1_and_R2_fastqs/

# HISAT2 parameters
GENOME_DIR="/home/newol210/macknight_oliver/braker_working_dir/"
OUTPUT_DIR="/home/newol210/macknight_oliver/braker_working_dir/hisat2_output_UTMhap1"

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Loop through R1 paired files
for R1_FASTQ in *_R1_fastp.fastq.gz; do
    # Derive the sample base name by removing the R1 suffix
    SAMPLE_NAME=$(basename "$R1_FASTQ" "_R1_fastp.fastq.gz")

    # Define the R2 paired file
    R2_FASTQ="${SAMPLE_NAME}_R2_fastp.fastq.gz"

    # Check if R2 file exists
    if [[ ! -f "$R2_FASTQ" ]]; then
        echo "Error: Paired file $R2_FASTQ not found for $R1_FASTQ" >&2
        continue
    fi

    # Run HISAT2 directly on gzipped files
    /home/newol210/GeneMark-ETP/tools/hisat2 -x "${GENOME_DIR}UTM_Trep_v1.0_hap1_genomic_hisat2_indexed" \
        -1 "$R1_FASTQ" -2 "$R2_FASTQ" | \
        /home/newol210/GeneMark-ETP/tools/samtools view -bS - | \
        /home/newol210/GeneMark-ETP/tools/samtools sort -o "$OUTPUT_DIR/${SAMPLE_NAME}.sorted.bam" -

    # Index the sorted BAM file
    /home/newol210/GeneMark-ETP/tools/samtools index "$OUTPUT_DIR/${SAMPLE_NAME}.sorted.bam"
done
