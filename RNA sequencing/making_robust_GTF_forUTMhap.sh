#!/usr/bin/env bash

#SBATCH --job-name=stringtie
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=200GB
#SBATCH --cpus-per-task=128
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=30:00:00

# Purge pre-existing modules
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
