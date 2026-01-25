#!/usr/bin/env bash
#
# Job name
#SBATCH --job-name=htslib
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
#SBATCH --time=24:00:00

# Commands go below

## Purge pre-existing modules
module purge

#!/bin/bash

source ~/.bashrc

conda activate htslib
cd /projects/health_sciences/bms/biochemistry/macknight_lab/Oliver/RNA_seq_fastqs/

sort -k1,1 -k4,4n greenFlyePorechopped_hisat2_output.gtf > greenFlyePorechopped_hisat2_output.sorted.gtf
sort -k1,1 -k4,4n RfFlyePorechopped_hisat2_output.gtf > RfFlyePorechopped_hisat2_output.sorted.gtf
sort -k1,1 -k4,4n RldFlyePorechopped_hisat2_output.gtf > RldFlyePorechopped_hisat2_output.sorted.gtf
sort -k1,1 -k4,4n RlFlyePorechopped_hisat2_output.gtf > RlFlyePorechopped_hisat2_output.sorted.gtf
sort -k1,1 -k4,4n RmFlyePorechopped_hisat2_output.gtf > RmFlyePorechopped_hisat2_output.sorted.gtf


SAMPLES="greenFlyePorechopped_hisat2_output.sorted RfFlyePorechopped_hisat2_output.sorted RldFlyePorechopped_hisat2_output.sorted RlFlyePorechopped_hisat2_output.sorted RmFlyePorechopped_hisat2_output.sorted"
for SAMPLE in $SAMPLES; do
    bgzip ${SAMPLE}.gtf
    tabix -p gff {SAMPLE}.gtf.gz
done

conda deactivate

echo "Finished"