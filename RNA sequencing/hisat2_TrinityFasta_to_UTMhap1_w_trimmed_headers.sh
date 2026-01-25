#!/usr/bin/env bash

#SBATCH --job-name=hisat2_trinity
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --ntasks-per-node=2
#SBATCH --cpus-per-task=36
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=3:00:00

#!/bin/bash

# This script is mapping the de novo transcriptome assembly to the UTMhap1 reference genome with the cleaned headers

# Stop script if there is an error
set -ueo pipefail

# Define input and output paths
GENOME_DIR="/home/newol210/macknight_oliver/braker_working_dir/"
OUTPUT_DIR="/home/newol210/macknight_oliver/braker_working_dir/hisat2_output_UTMhap1"
INPUT_FASTA="/home/newol210/macknight_oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/all_R1_and_R2_fastqs/samples_for_trinity_assembly/trinity_de_novo_8_samples/Trinity.fasta"

# Define output filenames
SAMPLE_NAME="Trinity"
SAM_OUTPUT="$OUTPUT_DIR/${SAMPLE_NAME}_hisat2_output.sam"
BAM_OUTPUT="$OUTPUT_DIR/${SAMPLE_NAME}_deNovo_against_UTMhap1.sorted.bam"

# Run HISAT2 in single-end mode with FASTA input
/home/newol210/GeneMark-ETP/tools/hisat2 --very-sensitive -x "${GENOME_DIR}UTM_Trep_v1.0_hap1_genomic_hisat2_indexed" \
    -f -U "$INPUT_FASTA" -S "$SAM_OUTPUT"

# Convert SAM to BAM, sort, and index
/home/newol210/GeneMark-ETP/tools/samtools view -bS "$SAM_OUTPUT" | \
    /home/newol210/GeneMark-ETP/tools/samtools sort -o "$BAM_OUTPUT" -

/home/newol210/GeneMark-ETP/tools/samtools index "$BAM_OUTPUT"

# Optional: Remove SAM file to save space
rm "$SAM_OUTPUT"
