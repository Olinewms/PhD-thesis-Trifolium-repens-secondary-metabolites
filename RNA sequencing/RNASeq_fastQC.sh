#!/usr/bin/env bash

#SBATCH --job-name=FastQC
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=10:00:00

## Purge pre-existing modules
module purge

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail

cd /home/newol210/macknight_oliver/NoneVsHigh_RNASeq_2023/Illumina_downloads_2023/Processed_Fastq_by_fastp_2023_data

## First QC all fastq's
source ~/.bashrc
mamba activate /home/newol210/macknight_oliver/mamba_envs/fastqc/

# Directory containing the fastq.gz files
input_dir="/home/newol210/macknight_oliver/NoneVsHigh_RNASeq_2023/Illumina_downloads_2023/Processed_Fastq_by_fastp_2023_data"

# Output directory for FastQC results
output_dir="/home/newol210/macknight_oliver/NoneVsHigh_RNASeq_2023/Illumina_downloads_2023/Processed_Fastq_by_fastp_2023_data/fastQC_on_fastp_filtered_reads"

# Create output directory if it doesn't exist
mkdir -p "$output_dir"

# Loop through the R1 files
for r1_file in "$input_dir"/*_R1_fastp.fastq.gz; do
    # Derive the sample name by removing the _R1_001.fastq.gz suffix
    sample_name=$(basename "$r1_file" _R1_fastp.fastq.gz)
    
    # Derive the corresponding R2 file
    r2_file="$input_dir/${sample_name}_R2_fastp.fastq.gz"
    
    # Run FastQC on the paired files
    fastqc "$r1_file" "$r2_file" -o "$output_dir"
done

mamba deactivate
