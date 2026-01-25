#!/usr/bin/env bash
#SBATCH --job-name=FeatureCounts
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=10GB
#SBATCH --cpus-per-task=64
#SBATCH --output=slurm_%j.log
#SBATCH --error=slurm_%j.err
#SBATCH --time=10:00:00

# Purge pre-existing modules
module purge

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail
source ~/.bashrc

mamba activate /home/newol210/macknight_oliver/mamba_envs/subread

cd /home/newol210/macknight_oliver/featureCounts_working_dir_braker_annotations/  

featureCounts --verbose -T 64 -a ../braker_working_dir/braker/braker.gtf -o featureCounts_fastpProcessed_17_samples_UTMhap1_counts_fraction_brakerGTF.txt ../NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1/all_bams/sorted_and_indexed_bams/*.bam -p -M -O --fraction

# This version of the command gave lots of Unassigned_Ambiguity reads, whereas the previous gave none per sample
featureCounts --verbose -T 64 -t exon -g gene_id -a ../braker_working_dir/braker/braker.gtf -o featureCounts_fastpProcessed_17_samples_UTMhap1_counts_fraction_brakerGTF_attempt2.txt ../NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1/all_bams/sorted_and_indexed_bams/*.bam -p -M --fraction

# This command was to check if the Unassigned_Ambiguity reads were assigned in the first command becaues of the -O parameter (it was)
featureCounts --verbose -T 64 -a ../braker_working_dir/braker/braker.gtf -o featureCounts_fastpProcessed_17_samples_UTMhap1_counts_fraction_brakerGTF_3.txt ../NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1/all_bams/sorted_and_indexed_bams/*.bam -p -M --fraction

# This command was to see if I could get the transcript ID's in the first column of the output, rather than the gene ID
featureCounts --verbose -T 64 -g transcript_id -a ../braker_working_dir/braker/braker.gtf -o featureCounts_fastpProcessed_17_samples_UTMhap1_counts_fraction_brakerGTF_attempt4.txt ../NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1/all_bams/sorted_and_indexed_bams/*.bam -p -M -O --fraction

# Then I repeated the command above but included the 2023 RNA-Seq data that I processed identically to the 2025 dataset
# Note that before running this, I temporarily moved all the 2023 .bams to /NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1/all_bams/sorted_and_indexed_bams/
featureCounts --verbose -T 64 -g transcript_id -a ../braker_working_dir/braker/braker.gtf -o featureCounts_fastpProcessed_17_samples_UTMhap1_counts_fraction_brakerGTF_inc2023_dataset.txt ../NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1/all_bams/sorted_and_indexed_bams/*.bam -p -M -O --fraction

mamba deactivate
