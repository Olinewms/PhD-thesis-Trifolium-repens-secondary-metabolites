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
#SBATCH --time=78:00:00

# Purge pre-existing modules
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
