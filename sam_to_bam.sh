#!/usr/bin/env bash
#
# Job name
#SBATCH --job-name=sam2bam
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
#SBATCH --time=78:00:00

# Commands go below

## Purge pre-existing modules
module purge

#!/bin/bash

source ~/.bashrc

conda activate samtools
cd /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/RNA_seq_fastqs/

samtools view -bS greenFlyePorechopped_hisat2_output.sam | samtools sort -o greenFlyePorechopped_hisat2_output_sorted.bam | samtools index -
samtools view -bS RfFlyePorechopped_hisat2_output.sam | samtools sort -o RfFlyePorechopped_hisat2_output_sorted.bam | samtools index -
samtools view -bS RldFlyePorechopped_hisat2_output.sam | samtools sort -o RldFlyePorechopped_hisat2_output_sorted.bam | samtools index -
samtools view -bS RlFlyePorechopped_hisat2_output.sam | samtools sort -o RlFlyePorechopped_hisat2_output_sorted.bam | samtools index -
samtools view -bS RmFlyePorechopped_hisat2_output.sam | samtools sort -o RmFlyePorechopped_hisat2_output_sorted.bam | samtools index -

conda deactivate

echo "Finished"

