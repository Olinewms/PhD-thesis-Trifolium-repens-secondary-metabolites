#!/usr/bin/env bash
#
# Job name
#SBATCH --job-name=hisatMapping_bulkRNA_Rf_revised
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
#SBATCH --time=24:00:00

# Commands go below

## Purge pre-existing modules
module purge

#!/bin/bash

# Stop script if there is an error
set -ueo pipefail

#cd ~/macknight_oliver/pod5_oliver_clover_all/bams_Rf_revised_merging/flye_output_Rf_revised/Rf_revised_dorado_porechopped_assembly

source ~/.bashrc
conda activate hisat2

# HISAT2 reference indexing
#hisat2-build ./Rf_revised_assembly.fasta ./Rf_revised_FlyePorechoppedHISAT2_indexed_genome

# HISAT2 mapping 
cd /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/RNA_seq_fastqs

hisat2 -x ~/macknight_oliver/pod5_oliver_clover_all/bams_Rf_revised_merging/flye_output_Rf_revised/Rf_revised_dorado_porechopped_assembly/Rf_revised_FlyePorechoppedHISAT2_indexed_genome -1 merged_R1_RNASeq_Trepens.fq -2 merged_R2_RNASeq_Trepens.fq -S Rf_revised_FlyePorechopped_hisat2_output.sam | samtools view -b - | samtools sort -o Rf_revised_FlyePorechopped_hisat2_output.sorted.bam - && samtools index Rf_revised_FlyePorechopped_hisat2_output.sorted.bam


# Then pipe hisat2_output.bam.bai to StringTie to make a GTF specific to each genome
# stringtie [-o <output.gtf>] [other_options] <read_alignments.bam> 

conda deactivate

echo "Finished"