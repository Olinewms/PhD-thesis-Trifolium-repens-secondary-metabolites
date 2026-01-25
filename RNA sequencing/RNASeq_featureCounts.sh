#!/usr/bin/env bash
#
# Job name
#SBATCH --job-name=FeatureCounts
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
#SBATCH --mem=500GB
#
# Number of CPUs (e.g 16 cores)
#SBATCH --cpus-per-task=64
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
#SBATCH --time=10:00:00

# Commands go below

## Purge pre-existing modules
module purge

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail
source ~/.bashrc

cd /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1/all_bams

conda activate subread

featureCounts -a /home/newol210/macknight_oliver/reference_genomes/UTM_Trep_v1.0_hap1/annotation/stringtie_UTM_Trep_v1_hap1_merged.gtf -o ./featureCounts_output/FeatureCounts_fastpProcessed_17_samples_UTMhap1_counts_fraction_newGTF.txt -T 64 ./*.bam -p -M --fraction
featureCounts -a /home/newol210/macknight_oliver/reference_genomes/UTM_Trep_v1.0_hap1/annotation/stringtie_UTM_Trep_v1_hap1_merged.gtf -o ./featureCounts_output/FeatureCounts_fastpProcessed_17_samples_UTMhap1_counts_noFraction_newGTF.txt -T 64 ./*.bam -p -M

conda deactivate