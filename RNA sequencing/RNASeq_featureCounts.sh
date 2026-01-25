#!/usr/bin/env bash

#SBATCH --job-name=FeatureCounts
#SBATCH --account=newol210
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=500GB
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

cd /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/NoneVsMidVsHigh_RNASeq/Processed_Fastq_by_fastp_attempt2/fastp_processedReads_mapped_to_UTM_hap1/all_bams

conda activate subread

# This command uses count fractioning:
featureCounts -a /home/newol210/macknight_oliver/reference_genomes/UTM_Trep_v1.0_hap1/annotation/stringtie_UTM_Trep_v1_hap1_merged.gtf -o ./featureCounts_output/FeatureCounts_fastpProcessed_17_samples_UTMhap1_counts_fraction_newGTF.txt -T 64 ./*.bam -p -M --fraction

# This command does not use count fractioning:
featureCounts -a /home/newol210/macknight_oliver/reference_genomes/UTM_Trep_v1.0_hap1/annotation/stringtie_UTM_Trep_v1_hap1_merged.gtf -o ./featureCounts_output/FeatureCounts_fastpProcessed_17_samples_UTMhap1_counts_noFraction_newGTF.txt -T 64 ./*.bam -p -M

conda deactivate
