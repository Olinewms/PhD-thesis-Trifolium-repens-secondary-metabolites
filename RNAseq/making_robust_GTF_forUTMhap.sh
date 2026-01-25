#!/usr/bin/env bash
#
# Job name
#SBATCH --job-name=stringtie
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
#SBATCH --cpus-per-task=128
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
#SBATCH --time=30:00:00

# Commands go below

## Purge pre-existing modules
module purge

#!/bin/bash

source ~/.bashrc

conda activate samtools
cd /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1/all_bams

#!/bin/bash

# Directory for output GTF files
output_dir="./stringtie_gtf"
mkdir -p $output_dir

# Loop through all BAM files
for bam_file in *.bam; do
    # Extract the base name without the file extension
    sample_name=$(basename "$bam_file" .bam)

    # Define the sorted BAM filename
    sorted_bam="${sample_name}_sorted.bam"

    # Sort the BAM file
    echo "Sorting $bam_file..."
    samtools sort -o "$sorted_bam" "$bam_file"

    # Index the sorted BAM file
    echo "Indexing $sorted_bam..."
    samtools index "$sorted_bam"

    # Run stringtie
    echo "Running stringtie for $sorted_bam..."
    ~/stringtie/stringtie -o "$output_dir/${sample_name}.gtf" "$sorted_bam"
done

# Merge all GTF files into a single file
merged_gtf="merged_output.gtf"
echo "Merging all GTF files into $merged_gtf..."
~/stringtie/stringtie --merge -o "$merged_gtf" <(ls $output_dir/*.gtf)

echo "Processing complete! Merged GTF file is $merged_gtf."

conda deactivate