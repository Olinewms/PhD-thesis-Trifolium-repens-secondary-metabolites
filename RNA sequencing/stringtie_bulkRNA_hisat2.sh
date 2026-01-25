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
#SBATCH --time=78:00:00

# Commands go below

## Purge pre-existing modules
module purge

#!/bin/bash

source ~/.bashrc

conda activate samtools
cd /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/RNA_seq_fastqs/

samtools index greenFlyePorechopped_hisat2_output_sorted.bam
samtools index RfFlyePorechopped_hisat2_output_sorted.bam
samtools index RldFlyePorechopped_hisat2_output_sorted.bam
samtools index RlFlyePorechopped_hisat2_output_sorted.bam
samtools index RmFlyePorechopped_hisat2_output_sorted.bam

conda deactivate

SAMPLES="greenFlyePorechopped_hisat2_output_sorted RfFlyePorechopped_hisat2_output_sorted RldFlyePorechopped_hisat2_output_sorted RlFlyePorechopped_hisat2_output_sorted RmFlyePorechopped_hisat2_output_sorted"
for SAMPLE in $SAMPLES; do
    ~/stringtie/stringtie -o ${SAMPLE}.gtf ${SAMPLE}.bam 
done

echo "Finished"